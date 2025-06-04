import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'dart:io';
import 'dart:ui';

import 'package:broker/core/theming/styles.dart';
import 'package:broker/feature/profie/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:path_provider/path_provider.dart';

class VoiceChatScreen extends StatefulWidget {
  const VoiceChatScreen({Key? key}) : super(key: key);

  @override
  State<VoiceChatScreen> createState() => _VoiceChatScreenState();
}

class _VoiceChatScreenState extends State<VoiceChatScreen> {
  final recorder = fs.FlutterSoundRecorder();
  final player = ja.AudioPlayer();
  final wsUrl =
      'wss://real-estate-chatbot-4lmcjvi3xq-uc.a.run.app/ws/voice-chat?user_id=46';
  WebSocketChannel? channel;
  StreamSubscription? socketSubscription;
  final _audioStreamController = StreamController<Uint8List>();

  final _audioBuffer = BytesBuilder();
  Timer? silenceTimer;
  Timer? periodicFlushTimer;
  double? ambientNoiseLevel;

  bool isRecording = false;
  bool isSessionConfirmed = false;
  bool pauseSending = false;
  bool isThinking = false;

  final double vadThreshold = 800; // حساسية الصوت
  final Duration silenceDuration = Duration(seconds: 2); // وقت الصمت للتجميع

  @override
  void initState() {
    super.initState();
    initRecorder();

  }

  Future<void> initRecorder() async {
    await Permission.microphone.request();
    await recorder.openRecorder();
  }

  void startRecording() async {
    channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    print("🌐 WebSocket opened");

    socketSubscription = channel!.stream.listen((event) async {
      if (event is Uint8List) {
        pauseSending = true;
        await recorder.pauseRecorder();
        await _playWavFromBytes(event);
        await recorder.resumeRecorder();
        pauseSending = false;
      } else if (event is String) {
        print("📩 Received text: $event");
        if (event.length == 36) {
          isSessionConfirmed = true;
          print("✅ Session confirmed with ID: $event");
        }
      }
    });

    _audioStreamController.stream.listen((buffer) {
      handleAudioChunk(buffer);
    });

    // periodicFlushTimer = Timer.periodic(Duration(seconds: 2), (timer) {
    //   if (_audioBuffer.length >= 4000 && isSessionConfirmed && channel != null) {
    //     print("📤 إرسال تلقائي كل 2 ثانية: ${_audioBuffer.length} bytes");
    //     channel!.sink.add(_audioBuffer.toBytes());
    //     _audioBuffer.clear();
    //   }
    // });
    periodicFlushTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!pauseSending &&
          _audioBuffer.length >= 4000 &&
          isSessionConfirmed &&
          channel != null) {
        print("📤 إرسال تلقائي كل 2 ثانية: ${_audioBuffer.length} bytes");
        channel!.sink.add(_audioBuffer.toBytes());
        _audioBuffer.clear();
      }
    });

    await recorder.startRecorder(
      codec: fs.Codec.pcm16WAV,
      sampleRate: 16000,
      numChannels: 1,
      bitRate: 16000 * 2,
      toStream: _audioStreamController.sink,
    );

    setState(() {
      isRecording = true;
    });
  }

  void handleAudioChunk(Uint8List buffer) {
    double energy = _calculateRMS(buffer);
    print("🔍 Energy: $energy");

    if (energy >= vadThreshold) {
      print("🎙️ صوت واضح - بنجمع الصوت");
      _audioBuffer.add(buffer);

      silenceTimer?.cancel();
      silenceTimer = Timer(silenceDuration, () {
        if (_audioBuffer.length >= 4000) {
          print("📤 إرسال accumulated buffer: ${_audioBuffer.length} bytes");
          if (isSessionConfirmed && channel != null) {
            channel!.sink.add(_audioBuffer.toBytes());
          }

          _saveWavToFile(
              _audioBuffer.toBytes()); // ← دي بتتحفظ دايمًا لو الصوت كافي
        } else {
          print(
              "⚠️ تجاهل الصوت لأنه أقل من 0.1 ثانية (${_audioBuffer.length} bytes)");
        }
        _audioBuffer.clear();
      });
    } else {
      print("🤫 صمت أو دوشة - مش هنبعت");
    }
  }
// void handleAudioChunk(Uint8List buffer) {
//   double energy = _calculateRMS(buffer);
//   print("🔍 Energy: $energy");

//   // 🧠 Step 1: تحديث مستوى الضوضاء البيئي
//   if (ambientNoiseLevel == null) {
//     ambientNoiseLevel = energy;
//   } else {
//     ambientNoiseLevel = (0.9 * ambientNoiseLevel!) + (0.1 * energy);
//   }

//   double adaptiveThreshold = ambientNoiseLevel! * 1.8;
//   print("📊 Adaptive Threshold: $adaptiveThreshold");

//   // 🧠 Step 2: المقارنة باستخدام threshold المتغير
//   if (energy >= adaptiveThreshold) {
//     print("🎙️ صوت واضح - بنجمع الصوت");
//     _audioBuffer.add(buffer);

//     silenceTimer?.cancel();
//     silenceTimer = Timer(silenceDuration, () {
//       if (_audioBuffer.length >= 4000) {
//         print("📤 إرسال accumulated buffer: ${_audioBuffer.length} bytes");
//         if (isSessionConfirmed && channel != null) {
//           channel!.sink.add(_audioBuffer.toBytes());
//           _saveWavToFile(_audioBuffer.toBytes());
//         }
//       } else {
//         print("⚠️ تجاهل الصوت لأنه أقل من 0.1 ثانية (${_audioBuffer.length} bytes)");
//       }
//       _audioBuffer.clear();
//     });
//   } else {
//     print("🤫 صمت أو دوشة - مش هنبعت");
//   }
// }

  double _calculateRMS(Uint8List data) {
    final buffer = Int16List.view(data.buffer);
    double sumSquares = 0;
    for (var sample in buffer) {
      sumSquares += sample * sample;
    }
    return sqrt(sumSquares / buffer.length);
  }

  Future<void> _playWavFromBytes(Uint8List bytes) async {
    final base64Data = base64Encode(bytes);
    final dataUri = Uri.parse('data:audio/wav;base64,$base64Data');

    try {
      await player.setAudioSource(ja.AudioSource.uri(dataUri));
      await player.play();
    } catch (e) {
      print('❌ Error playing audio: $e');
    }
  }

  // Future<void> _playWavFromBytes(Uint8List bytes) async {
  //   final dir = await getTemporaryDirectory();
  //   final file = File('${dir.path}/response.wav');
  //   await file.writeAsBytes(bytes);
  //   await player.setFilePath(file.path);
  //   await player.play();
  // }
  void _saveWavToFile(Uint8List audioData) async {
    final dir = await getExternalStorageDirectory(); // Android فقط
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir!.path}/recorded_$timestamp.wav');

    // WAV header parameters
    final int sampleRate = 16000;
    final int numChannels = 1;
    final int byteRate = sampleRate * 2;
    final int blockAlign = numChannels * 2;
    final int bitsPerSample = 16;
    final int dataLength = audioData.length;

    final header = BytesBuilder();
    header.add(ascii.encode('RIFF'));
    header.add(_intToBytes(36 + dataLength, 4));
    header.add(ascii.encode('WAVEfmt '));
    header.add(_intToBytes(16, 4)); // Subchunk1Size for PCM
    header.add(_intToBytes(1, 2)); // Audio format = PCM
    header.add(_intToBytes(numChannels, 2));
    header.add(_intToBytes(sampleRate, 4));
    header.add(_intToBytes(byteRate, 4));
    header.add(_intToBytes(blockAlign, 2));
    header.add(_intToBytes(bitsPerSample, 2));
    header.add(ascii.encode('data'));
    header.add(_intToBytes(dataLength, 4));
    header.add(audioData);

    await file.writeAsBytes(header.toBytes());
    print('💾 Audio saved: ${file.path}');
  }

  Uint8List _intToBytes(int value, int byteCount) {
    final bytes = ByteData(byteCount);
    switch (byteCount) {
      case 2:
        bytes.setInt16(0, value, Endian.little);
        break;
      case 4:
        bytes.setInt32(0, value, Endian.little);
        break;
    }
    return bytes.buffer.asUint8List();
  }

  void stopRecording() async {
    await recorder.stopRecorder();
    silenceTimer?.cancel();
    periodicFlushTimer?.cancel();
    await channel?.sink.close();
    await player.dispose();
    socketSubscription?.cancel();
    await _audioStreamController.close();

    print(
        "❌ WebSocket closed: ${channel?.closeCode} | ${channel?.closeReason}");

    setState(() {
      isRecording = false;
    });
  }

  @override
  void dispose() {
    stopRecording();
    recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top row: menu + avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.menu, color: Colors.white),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          ProfileCubit.get(context).profileUser?.image ?? '',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
Spacer(),
                  // Call button
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // ✅ موجة متحركة
                       Lottie.asset('assets/img/Animation - 1748525990399.json'),
                    
                          // ✅ الزرار نفسه (Icon + Text)
                          ElevatedButton.icon(
                            icon: Icon(
                              isRecording ? Icons.call_end : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            label: Text(
                              isRecording ? 'End the Call' : 'Start Call',
                              style: TextStyles.sarabunSemiBold32White.copyWith(fontSize: 18),
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
