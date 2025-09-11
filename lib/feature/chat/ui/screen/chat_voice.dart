// lib/feature/chat/ui/screen/voice_chat_screen.dart

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:broker/core/helpers/cash_helper.dart';
import 'package:broker/feature/chat/ui/widget/chat_widget.dart';
import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/like/logic/fav_cubit.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// A custom audio source for the `just_audio` player that streams bytes.
class StreamingAudioSource extends ja.StreamAudioSource {
  final StreamController<Uint8List> _byteStreamController;

  StreamingAudioSource(this._byteStreamController);

  @override
  Future<ja.StreamAudioResponse> request([int? start, int? end]) async {
    return ja.StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: 0,
      stream: _byteStreamController.stream,
      contentType: 'audio/wav',
    );
  }
}

/// A full-screen voice chat interface.
class VoiceChatScreen extends StatefulWidget {
  final FavCubit favCubit;

  const VoiceChatScreen({
    Key? key,
    required this.favCubit,
  }) : super(key: key);

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final recorder = fs.FlutterSoundRecorder();
  final player = ja.AudioPlayer();
  final wsUrl =
      'wss://api.elevenlabs.io/v1/convai/conversation?agent_id=agent_01jxvx0pagev7rzteynqzkk8eb';

  WebSocketChannel? channel;
  StreamSubscription? socketSubscription;
  StreamSubscription<Uint8List>? recorderSubscription;
  StreamSubscription? playerStateSubscription;

  final _recorderAudioStreamController =
      StreamController<Uint8List>.broadcast();

  bool isRecording = false;
  bool isMuted = false;
  bool isSessionConfirmed = false;
  bool isAgentSpeaking = false;

  final List<int> _audioBuffer = [];
  Timer? _speechEndTimer;

  String _agentResponseText = "ابدأ المكالمة للتحدث مع المساعد الصوتي";

  @override
  void initState() {
    super.initState();
    initRecorderAndPlayer();
  }

  @override
  void dispose() {
    // Ensure all resources are released properly.
    stopRecording();
    playerStateSubscription?.cancel();
    recorder.closeRecorder();
    player.dispose();
    _recorderAudioStreamController.close();
    super.dispose();
  }

  // --- Core Logic Methods (Unchanged) ---

  Uint8List _createWavHeader() {
    final header = ByteData(44);
    const sampleRate = 16000;
    const numChannels = 1;
    const bitsPerSample = 16;
    final byteRate = sampleRate * numChannels * bitsPerSample ~/ 8;

    header.setUint8(0, 0x52); // "R"
    header.setUint8(1, 0x49); // "I"
    header.setUint8(2, 0x46); // "F"
    header.setUint8(3, 0x46); // "F"
    header.setUint32(4, 0xFFFFFFFF, Endian.little); // ChunkSize (placeholder)
    header.setUint8(8, 0x57); // "W"
    header.setUint8(9, 0x41); // "A"
    header.setUint8(10, 0x56); // "V"
    header.setUint8(11, 0x45); // "E"
    header.setUint8(12, 0x66); // "f"
    header.setUint8(13, 0x6D); // "m"
    header.setUint8(14, 0x74); // "t"
    header.setUint8(15, 0x20); // " "
    header.setUint32(16, 16, Endian.little); // Subchunk1Size
    header.setUint16(20, 1, Endian.little); // AudioFormat (PCM)
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(28, byteRate, Endian.little);
    header.setUint16(32, numChannels * bitsPerSample ~/ 8, Endian.little);
    header.setUint16(34, bitsPerSample, Endian.little);
    header.setUint8(36, 0x64); // "d"
    header.setUint8(37, 0x61); // "a"
    header.setUint8(38, 0x74); // "t"
    header.setUint8(39, 0x61); // "a"
    header.setUint32(40, 0xFFFFFFFF, Endian.little); // Subchunk2Size (placeholder)

    return header.buffer.asUint8List();
  }

  Future<void> initRecorderAndPlayer() async {
    await Permission.microphone.request();
    await recorder.openRecorder();

    playerStateSubscription = player.playerStateStream.listen((state) {
      if (state.processingState == ja.ProcessingState.completed) {
        if (mounted) {
          setState(() {
            isAgentSpeaking = false;
          });
        }
      }
    });
  } void startRecording() async {

    if (isRecording) return;
    setState(() {
      isRecording = true;
      _agentResponseText = "جاري الاتصال...";
    });

    try {
       final userId = await CashHelper.getStringSecured(key: Keys.id);
      channel = IOWebSocketChannel.connect(
        Uri.parse(wsUrl),
        headers: {'user-id':userId,
        'user_id': userId,
        },
      );

      socketSubscription = channel!.stream.listen(
        _onSocketData,
        onError: (error) => stopRecording(),
        onDone: () => stopRecording(),
      );

      recorderSubscription =
          _recorderAudioStreamController.stream.listen((buffer) {
        
        // ++++++++++++++++++++++++++++++++++++++++++++++++
        // VVV           هذا هو التعديل المطلوب           VVV
        // ++++++++++++++++++++++++++++++++++++++++++++++++
        // تم إزالة شرط "!isAgentSpeaking" من هنا للسماح بالمقاطعة
        if (isSessionConfirmed && channel != null && !isMuted) {
          channel!.sink.add(jsonEncode({"user_audio_chunk": base64Encode(buffer)}));
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++
        // VVV         نهاية التعديل المطلوب              VVV
        // ++++++++++++++++++++++++++++++++++++++++++++++++

      });

      await recorder.startRecorder(
        toFile: 'tau_file.pcm',
        codec: fs.Codec.pcm16,
        toStream: _recorderAudioStreamController.sink,
        sampleRate: 16000,
        numChannels: 1,
      );
    } catch (e) {
      stopRecording();
    }
  }  void _onSocketData(dynamic data) async {
    if (data is! String) return;
    try {
      final decoded = jsonDecode(data) as Map<String, dynamic>;

      if (decoded.containsKey('audio_event')) {
        final audioBase64 = decoded['audio_event']['audio_base_64'] as String;
        final audioBytes = base64Decode(audioBase64);
        _speechEndTimer?.cancel();
        _audioBuffer.addAll(audioBytes);
        if (mounted) setState(() => isAgentSpeaking = true);
        _speechEndTimer = Timer(const Duration(milliseconds: 500), () {
          _playBufferedAudio();
        });
        return;
      }

      final messageType = decoded['type'] as String?;
      switch (messageType) {
        case 'conversation_initiation_metadata':
          if (mounted) setState(() => isSessionConfirmed = true);
          break;
        case 'agent_response':
          final responseText = decoded['agent_response_event']['agent_response'] as String;
          if (mounted) setState(() => _agentResponseText = responseText);
          break;
        case 'ping':
          final eventId = decoded['ping_event']['event_id'];
          channel?.sink.add(jsonEncode({"type": "pong", "event_id": eventId}));
          break;
      }
    } catch (e, s) {
      print("❌ [ERROR] Processing JSON: $e\n$s\nData: $data");
    }
  }
ImageProvider _safeImageProvider(String? url) {
  // فاضي/Null → استعمل صورة افتراضية
  if (url == null || url.trim().isEmpty) {
    return const AssetImage('assets/img/person.png');
  }
  final uri = Uri.tryParse(url.trim());

  // اسمح بس بـ http/https/data (تجاهل file:// في CircleAvatar/Network)
  if (uri == null ||
      !(uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'data')) {
    return const AssetImage('assets/img/person.png');
  }
  return NetworkImage(url.trim());
}
  Future<void> _playBufferedAudio() async {
    if (_audioBuffer.isEmpty) {
      if (mounted) setState(() => isAgentSpeaking = false);
      return;
    }
    final fullAudioData = Uint8List.fromList(_createWavHeader() + _audioBuffer);
    _audioBuffer.clear();
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_audio.wav');
      await tempFile.writeAsBytes(fullAudioData, flush: true);
      await player.setFilePath(tempFile.path);
      await player.play();
    } catch (e) {
      print("❌ [ERROR] Playing audio: $e");
    }
  }

  void stopRecording() async {
    if (!isRecording && channel == null) return;
    _speechEndTimer?.cancel();
    _audioBuffer.clear();
    if (recorder.isRecording) await recorder.stopRecorder();
    if (player.playing) await player.stop();
    await recorderSubscription?.cancel();
    await socketSubscription?.cancel();
    await channel?.sink.close();
    recorderSubscription = null;
    socketSubscription = null;
    channel = null;
    if (mounted) {
      setState(() {
        isRecording = false;
        isSessionConfirmed = false;
        isAgentSpeaking = false;
        _agentResponseText = "ابدأ المكالمة للتحدث مع المساعد الصوتي";
      });
    }
  }

  // --- Build Method (Modified for Full Screen) ---

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.favCubit,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset(
              'assets/img/image 2.png',
              fit: BoxFit.cover,
            ),
            // UI Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Top Bar with Back Button and Profile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                       CircleAvatar(
  radius: 20,
  backgroundImage: _safeImageProvider(
    ProfileCubit.get(context).profileUser?.image,
  ),
),
                      ],
                    ),
                    
                    // ============ START: MODIFIED CODE ============
                    // This Expanded widget will take all remaining vertical space
                    Expanded(
                      // Center will position the content in the middle of the available space
                      child: Center(
                        // SingleChildScrollView allows scrolling if the text is too long
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ChatWidget(
                            key: ValueKey(_agentResponseText),
                            msg: _agentResponseText,
                            chatIndex: 1,
                            // Bind this to the actual speaking state for better UI feedback
                            isCurrentlyReceiving: isAgentSpeaking,
                          ),
                        ),
                      ),
                    ),
                    // ============= END: MODIFIED CODE =============

                    // Bottom Controls Bar
                    Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isRecording)
                            Lottie.asset(
                                'assets/img/Animation - 1748525990399.json'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isMuted ? Icons.mic_off : Icons.mic,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  setState(() => isMuted = !isMuted);
                                },
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: ElevatedButton.icon(
                                  icon: Icon(
                                    isRecording ? Icons.call_end : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    isRecording ? 'End Call' : 'Start Call',
                                    style: TextStyles.sarabunSemiBold32White
                                        .copyWith(fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                  onPressed: isRecording ? stopRecording : startRecording,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}