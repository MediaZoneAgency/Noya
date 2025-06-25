import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';

// ---  هذا هو الكلاس المساعد الذي قمنا بإعادته (الحل) ---
// هذا هو "المبنى الفعلي" الذي يرث من "المخطط"
class StreamingAudioSource extends ja.StreamAudioSource {
  final StreamController<Uint8List> _audioStreamController;

  StreamingAudioSource(
      this._audioStreamController); // هذا هو الكونستركتور الصحيح

  @override
  Future<ja.StreamAudioResponse> request([int? start, int? end]) async {
    return ja.StreamAudioResponse(
      sourceLength: null,
      contentLength: null,
      offset: 0,
      stream: _audioStreamController.stream,
      // نحدد النوع هنا ليتطابق مع ما نطلبه من الخادم
      contentType: 'audio/pcm;rate=16000',
    );
  }
}

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({Key? key}) : super(key: key);

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final recorder = fs.FlutterSoundRecorder();
  final player = ja.AudioPlayer();
  final wsUrl =
      'wss://api.elevenlabs.io/v1/convai/conversation?agent_id=agent_01jxvx0pagev7rzteynqzkk8eb&output_format_pcm_16000=true';

  WebSocketChannel? channel;
  StreamSubscription? socketSubscription;
  StreamSubscription? recorderSubscription;
  StreamSubscription? playerStateSubscription;

  final _incomingAudioStreamController =
      StreamController<Uint8List>.broadcast();
  final _recorderAudioStreamController =
      StreamController<Uint8List>.broadcast();

  bool isRecording = false;
  bool isSessionConfirmed = false;
  bool isAgentSpeaking = false;
  bool _isPlayerConfigured = false;

  @override
  void initState() {
    super.initState();
    initRecorderAndPlayer();
  }

  Future<void> initRecorderAndPlayer() async {
    await Permission.microphone.request();
    await recorder.openRecorder();

    playerStateSubscription = player.playerStateStream.listen((state) {
      if (state.processingState == ja.ProcessingState.completed) {
        if (isAgentSpeaking && mounted) {
          print("Agent finished speaking.");
          setState(() {
            isAgentSpeaking = false;
          });
        }
      }
    });
  }

  void startRecording() async {
    if (isRecording) return;
    setState(() {
      isRecording = true;
    });

    try {
      channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      print("🌐 WebSocket connecting...");

      socketSubscription =
          channel!.stream.listen(_onSocketData, onError: (error) {
        print(" WebSocket Error: $error");
        stopRecording();
      }, onDone: () {
        print(" WebSocket disconnected.");
        stopRecording();
      });

      recorderSubscription =
          _recorderAudioStreamController.stream.listen((buffer) {
        if (isSessionConfirmed && !isAgentSpeaking && channel != null) {
          channel!.sink
              .add(jsonEncode({"user_audio_chunk": base64Encode(buffer)}));
        }
      });

      await recorder.startRecorder(
        codec: fs.Codec.pcm16,
        toStream: _recorderAudioStreamController.sink,
        sampleRate: 16000,
        numChannels: 1,
      );
    } catch (e) {
      print("❌ Failed to start recording: $e");
      stopRecording();
    }
  }

  void _onSocketData(dynamic data) async {
    print(data);
    if (data is! String) return;

    try {
      final decoded = jsonDecode(data) as Map<String, dynamic>;

      if (decoded['audio_event']?['audio_base_64'] != null) {
        final audioBytes =
            base64Decode(decoded['audio_event']['audio_base_64']);
        print("🎤 Received audio chunk: ${audioBytes.length} bytes");

        if (!_isPlayerConfigured) {
          print("⚙️ Configuring player for streaming...");

          // --- هنا قمنا باستدعاء الكلاس المساعد الصحيح ---
          final audioSource =
              StreamingAudioSource(_incomingAudioStreamController);

          await player.setAudioSource(audioSource, preload: false);
          _isPlayerConfigured = true;

          _incomingAudioStreamController.add(audioBytes);
          player.play();

          if (mounted) {
            setState(() {
              isAgentSpeaking = true;
            });
          }
        } else {
          _incomingAudioStreamController.add(audioBytes);
        }
      } else if (decoded['type'] == 'conversation_initiation_metadata') {
        print(
            "✅ Server confirms settings: ${decoded['conversation_initiation_metadata_event']}");
        if (mounted) {
          setState(() {
            isSessionConfirmed = true;
          });
        }
      } else if (decoded['type'] == 'agent_response') {
        final agentText = decoded['agent_response_event']?['agent_response'];
        if (agentText != null) print("🤖 Agent Response Text: $agentText");
      }
    } catch (e) {
      print("❌ Error processing server JSON: $e\nData: $data");
    }
  }

  void stopRecording() async {
    if (!isRecording) return;
    print("🛑 Stopping session...");

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
        _isPlayerConfigured = false;
      });
    }
  }

  @override
  void dispose() {
    stopRecording();
    playerStateSubscription?.cancel();
    recorder.closeRecorder();
    player.dispose();
    _incomingAudioStreamController.close();
    _recorderAudioStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No changes needed in the build method
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.white),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            ProfileCubit.get(context).profileUser?.image ?? ''),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.3), width: 0.5),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (isRecording)
                            Lottie.asset(
                                'assets/img/Animation - 1748525990399.json'),
                          ElevatedButton.icon(
                            icon: Icon(
                                isRecording ? Icons.call_end : Icons.play_arrow,
                                color: Colors.white),
                            label: Text(
                                isRecording ? 'End the Call' : 'Start Call',
                                style: TextStyles.sarabunSemiBold32White
                                    .copyWith(fontSize: 18)),
                            onPressed:
                                isRecording ? stopRecording : startRecording,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
