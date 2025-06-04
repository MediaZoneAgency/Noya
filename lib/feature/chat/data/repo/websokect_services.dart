// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:just_audio/just_audio.dart'; // مكتبة تشغيل الصوت
// import 'package:speech_to_text/speech_to_text.dart' as stt; // استيراد مكتبة STT
//
// class WebSocketService {
//   final String wsUrl = "ws://real-estate-chatbot-j26jnniwla-uc.a.run.app/ws/voice-chat";
//   WebSocketChannel? _channel;
//   final AudioRecorder _recorder = AudioRecorder();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isRecording = false;
//   List<int> _verificationBuffer = [];
//   Timer? _verificationTimer;
//   Timer? _saveTimer;
//
//   StreamSubscription<Uint8List>? _audioStreamSubscription;
//
//   List<int> _audioBuffer = [];
//
//   final int _bufferThreshold = 200000;
//
//   // Speech-to-Text variables
//   stt.SpeechToText speechToText = stt.SpeechToText();
//   bool _speechEnabled = false;
//   String _recognizedWords = '';
//
//   Future<void> connect() async {
//     try {
//       _channel = IOWebSocketChannel.connect(wsUrl);
//       print("✅ Connected to WebSocket Server");
//
//       // استقبال البيانات الصوتية وتجميعها
//       _channel!.stream.listen((data) {
//         if (data is Uint8List) {
//           _accumulateAudioData(data);
//         }
//       });
//     } catch (e) {
//       print("❌ WebSocket connection error: $e");
//     }
//   }
//
//   // دالة لتجميع البيانات في المخزن وتشغيلها عند وصولها للعتبة المحددة
//   void _accumulateAudioData(Uint8List newData) {
//     _audioBuffer.addAll(newData);
//     // إذا وصل حجم البيانات إلى العتبة، نشغّل الصوت
//     if (_audioBuffer.length >= _bufferThreshold) {
//       playReceivedAudio(Uint8List.fromList(_audioBuffer));
//       _audioBuffer.clear();
//     }
//   }
//
//   // دالة لتفريغ البيانات عند انتهاء التدفق
//   Future<void> flushAudioBuffer() async {
//     if (_audioBuffer.isNotEmpty) {
//       playReceivedAudio(Uint8List.fromList(_audioBuffer));
//       _audioBuffer.clear();
//     }
//   }
//
//   // متغير لتجميع بيانات PCM الخام للتحقق
//   List<int> _pcmVerificationBuffer = [];
//
//   Future<void> startRecording() async {
//     try {
//       if (!await _recorder.hasPermission()) {
//         throw Exception("🚨 No microphone permission!");
//       }
//
//       print("🎤 Recording started...");
//       _isRecording = true;
//
//       Stream<Uint8List> audioStream = await _recorder.startStream(
//         RecordConfig(
//           encoder: AudioEncoder.pcm16bits,
//           sampleRate: 32000, // **هام: استخدام معدل العينة الصحيح**
//           numChannels: 1,
//         ),
//       );
//
//       // ضبط مؤقت لحفظ الصوت كل 5 ثوانٍ
//       _saveTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
//         if (_pcmVerificationBuffer.isNotEmpty) {
//           await _saveAndSendAudio();
//         }
//       });
//
//       _audioStreamSubscription = audioStream.listen((Uint8List buffer) {
//         _pcmVerificationBuffer.addAll(buffer);
//         print("🔊 Received PCM chunk of size: ${buffer.length} bytes");
//       });
//     } catch (e) {
//       print("❌ Error أثناء التسجيل: $e");
//     }
//   }
//
//   Future<void> _saveAndSendAudio() async {
//     if (_pcmVerificationBuffer.isEmpty) return;
//
//     Uint8List aggregatedPCM = Uint8List.fromList(_pcmVerificationBuffer);
//     // **هام: استخدام معدل العينة الصحيح (32000)**
//     Uint8List wavData = await convertPCMToWAVWithPackage(aggregatedPCM, 32000, 1);
//
//     // تحويل الصوت إلى نص
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final filePath = '${appDocDir.path}/temp_audio_$timestamp.wav'; // مسار مؤقت
//     final file = File(filePath);
//     await file.writeAsBytes(wavData); // حفظ البيانات بتنسيق WAV في ملف مؤقت
//     // String recognizedText = await convertAudioToText(filePath);
//     // print("📝 Recognized Text: $recognizedText");
//
//     // إرسال البيانات عبر WebSocket
//     if (_channel != null && _channel!.closeCode == null) {
//       _channel!.sink.add(wavData);
//       print("🔊 Sent audio data to server, size: ${wavData.length} bytes");
//     } else {
//       print("⚠️ WebSocket is not connected, cannot send data.");
//     }
//
//     // حفظ الملف في دليل المستندات
//     final appDocDir2 = await getApplicationDocumentsDirectory();
//     final timestamp2 = DateTime.now().millisecondsSinceEpoch;
//     final filePath2 = '${appDocDir2.path}/verification_$timestamp2.wav';
//     final file2 = File(filePath2);
//     await file2.writeAsBytes(wavData);
//     print('✅ Aggregated audio saved: $filePath2, total size: ${wavData.length} bytes');
//
//     // تفريغ البافر بعد الإرسال
//     _pcmVerificationBuffer.clear();
//   }
//
//   Future<void> _saveChunkForVerification(Uint8List wavData) async {
//     // إضافة الـ chunk الحالي إلى البافر
//     _verificationBuffer.addAll(wavData);
//
//     // إذا كان هناك مؤقت قائم، نقوم بإلغائه لإعادة التعيين
//     _verificationTimer?.cancel();
//
//     // تعيين مؤقت جديد يتم تنفيذه بعد 5 ثوانٍ من عدم استقبال بيانات جديدة
//     _verificationTimer = Timer(Duration(seconds: 5), () async {
//       // طباعة طول البافر للتأكد من وجود بيانات
//       print("Timer expired. Buffer length: ${_verificationBuffer.length} bytes");
//
//       try {
//         final directory = await getTemporaryDirectory();
//         String filePath = "${directory.path}/verification_audio_${DateTime.now().millisecondsSinceEpoch}.wav";
//         final file = File(filePath);
//         await file.writeAsBytes(_verificationBuffer);
//         print("✅ Aggregated audio saved to file: $filePath, length: ${_verificationBuffer.length} bytes");
//       } catch (e) {
//         print("❌ Error saving aggregated audio: $e");
//       }
//       // تفريغ البافر وإعادة تعيين المؤقت
//       _verificationBuffer.clear();
//       _verificationTimer = null;
//     });
//   }
//
//   Future<void> stopRecording() async {
//     if (!_isRecording) return;
//     _isRecording = false;
//     await _recorder.stop();
//     _audioStreamSubscription?.cancel();
//     print("🛑 Recording stopped.");
//   }
//
//   /// دالة تشغيل الصوت المستلم بعد تجميعه
// Future<void> playReceivedAudio(Uint8List audioData) async {
//     try {
//       final tempDir = await getTemporaryDirectory();
//       // حفظ البيانات في ملف (لاحظ أننا نستخدم امتداد mp3 حسب طلبك)
//       final audioFile = File("${tempDir.path}/received_audio.mp3");
//       await audioFile.writeAsBytes(audioData);
//
//       await _audioPlayer.setFilePath(audioFile.path);
//       print('file path: ${audioFile.path}');
//       await _audioPlayer.play();
//
//       print("🎶 Playing received audio...");
//     } catch (e) {
//       print("❌ Error playing audio: $e");
//     }
//   }
//
//    Future<Uint8List> convertPCMToWAVWithPackage(
//     Uint8List pcmData,
//     int sampleRate,
//     int numChannels,
//     ) async {
//   try {
//     final bytesBuilder = BytesBuilder();
//
//     // ChunkSize, WaveFormatEx, and DataChunkSize.
//     final int fileSize = pcmData.length + 36;
//
//     // RIFF identifier.
//     bytesBuilder.add([82, 73, 70, 70]);
//
//     // ChunkSize.
//     final chunkSizeBytes = ByteData(4)..setUint32(0, fileSize, Endian.little);
//     bytesBuilder.add(chunkSizeBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // RIFF type (WAVE identifier).
//     bytesBuilder.add([87, 65, 86, 69]);
//
//     // Format chunk marker.
//     bytesBuilder.add([102, 109, 116, 32]);
//
//     // Length of format data.
//     final formatDataSizeBytes = ByteData(4)..setUint32(0, 16, Endian.little);
//     bytesBuilder.add(formatDataSizeBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Type of format (1 is PCM).
//     final formatTypeBytes = ByteData(2)..setUint16(0, 1, Endian.little);
//     bytesBuilder.add(formatTypeBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Number of channels.
//     final numChannelsBytes = ByteData(2)..setUint16(0, numChannels, Endian.little);
//     bytesBuilder.add(numChannelsBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Sample rate.
//     final sampleRateBytes = ByteData(4)..setUint32(0, sampleRate, Endian.little);
//     bytesBuilder.add(sampleRateBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // (SampleRate * BitsPerSample * Channels) / 8
//     // Note that BitsPerSample is hard-coded as 16-bit.
//     int byteRate = sampleRate * numChannels * 2;
//     final byteRateBytes = ByteData(4)..setUint32(0, byteRate, Endian.little);
//     bytesBuilder.add(byteRateBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // (BitsPerSample * Channels) / 8
//     int blockAlign = numChannels * 2;
//     final blockAlignBytes = ByteData(2)..setUint16(0, blockAlign, Endian.little);
//     bytesBuilder.add(blockAlignBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Bits per sample.
//     final bitsPerSampleBytes = ByteData(2)..setUint16(0, 16, Endian.little);
//     bytesBuilder.add(bitsPerSampleBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Data chunk marker.
//     bytesBuilder.add([100, 97, 116, 97]);
//
//     // Size of the data section.
//     final dataSizeBytes = ByteData(4)..setUint32(0, pcmData.length, Endian.little);
//     bytesBuilder.add(dataSizeBytes.buffer.asUint8List()); // استخراج البايتات بشكل صحيح
//
//     // Actual data.
//     bytesBuilder.add(pcmData);
//
//     // Return the bytes.
//     return bytesBuilder.takeBytes();
//   } catch (e) {
//     print('Error converting to WAV using manual headers: $e');
//     return Uint8List(0);
//   }
// }
//   // Future<void> _initializeSpeech() async {
//   //   _speechEnabled = await speechToText.initialize();
//   //   if (_speechEnabled) {
//   //     print("✅ Speech-to-Text initialized successfully");
//   //   } else {
//   //     print("❌ Failed to initialize Speech-to-Text");
//   //   }
//   // }
//
//   // Future<String> convertAudioToText(String audioFilePath) async {
//   //   if (!_speechEnabled) {
//   //     await _initializeSpeech();
//   //     if (!_speechEnabled) {
//   //       return "Speech-to-Text not available.";
//   //     }
//   //   }
//   //
//   //   try {
//   //     bool available = await speechToText.initialize();
//   //     if (available) {
//   //       print('Speech recognition is available.');
//   //
//   //       // Add a delay before starting to listen
//   //       await Future.delayed(Duration(seconds: 1));
//   //
//   //       // Listen for speech
//   //       await speechToText.listen(
//   //         onResult: (result) {
//   //           _recognizedWords = result.recognizedWords;
//   //           print('Recognized text: $_recognizedWords');
//   //         },
//   //         listenFor: Duration(seconds: 5), // يمكنك تعديل هذه المدة
//   //       );
//   //
//   //       // Wait for the listening to complete (adjust the duration if needed)
//   //       await Future.delayed(Duration(seconds: 6));
//   //
//   //       // Stop listening
//   //       await speechToText.stop();
//   //
//   //       return _recognizedWords;
//   //     } else {
//   //       print("The application is denied access to the microphone.");
//   //       return "Microphone access denied.";
//   //     }
//   //   } catch (e) {
//   //     print("❌ Error during speech recognition: $e");
//   //     return "Error during speech recognition: $e";
//   //   }
//   // }
// }

// import 'dart:async';
// import 'dart:typed_data';
// import 'dart:io';
// import 'package:record/record.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
//
// class WebSocketService {
//   final String wsUrl = "ws://real-estate-chatbot-j26jnniwla-uc.a.run.app/ws/voice-chat";
//   WebSocketChannel? _channel;
//   final AudioRecorder _recorder = AudioRecorder();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isRecording = false;
//   List<int> _audioBuffer = [];
//   final int _bufferThreshold = 200000;
//   stt.SpeechToText speechToText = stt.SpeechToText();
//   bool _speechEnabled = false;
//   String _recognizedWords = '';
//   List<int> _pcmVerificationBuffer = [];
//   List<int> _verificationBuffer = [];
//   Timer? _verificationTimer;
//   Timer? _saveTimer;
//
//   StreamSubscription<Uint8List>? _audioStreamSubscription;
//
//   Future<void> connect() async {
//     try {
//       _channel = IOWebSocketChannel.connect(wsUrl);
//       print("✅ Connected to WebSocket Server");
//       _channel!.stream.listen((data) {
//         if (data is Uint8List) {
//           _accumulateAudioData(data);
//         }
//       });
//     } catch (e) {
//       print("❌ WebSocket connection error: $e");
//     }
//   }
//
//   void _accumulateAudioData(Uint8List newData) async {
//     if (_isRecording) {
//       await stopRecording(); // إيقاف التسجيل عند استقبال رد صوتي
//     }
//     _audioBuffer.addAll(newData);
//     if (_audioBuffer.length >= _bufferThreshold) {
//       playReceivedAudio(Uint8List.fromList(_audioBuffer));
//       _audioBuffer.clear();
//     }
//   }
//
//   Future<void> playReceivedAudio(Uint8List audioData) async {
//     try {
//       final appDocDir = await getApplicationDocumentsDirectory();
//       final audioFile = File("${appDocDir.path}/received_audio.mp3");
//       await audioFile.writeAsBytes(audioData);
//       await _audioPlayer.setFilePath(audioFile.path);
//   // تأخير لمنع التفريغ
//       await _audioPlayer.play();
//       print("🎶 Playing received audio...");
//
//       _audioPlayer.playerStateStream.listen((state) {
//         if (state.processingState == ProcessingState.completed) {
//           startRecording(); // إعادة التسجيل بعد انتهاء تشغيل الصوت
//         }
//       });
//     } catch (e) {
//       print("❌ Error playing audio: $e");
//     }
//   }
//   Future<void> startRecording() async {
//     try {
//       if (!await _recorder.hasPermission()) {
//         throw Exception("🚨 No microphone permission!");
//       }
//
//       print("🎤 Recording started...");
//       _isRecording = true;
//
//       Stream<Uint8List> audioStream = await _recorder.startStream(
//         RecordConfig(
//           encoder: AudioEncoder.pcm16bits,
//           sampleRate: 32000, // **هام: استخدام معدل العينة الصحيح**
//           numChannels: 1,
//         ),
//       );
//
//       // ضبط مؤقت لحفظ الصوت كل 5 ثوانٍ
//       _saveTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
//         if (_pcmVerificationBuffer.isNotEmpty) {
//           await _saveAndSendAudio();
//         }
//       });
//
//       _audioStreamSubscription = audioStream.listen((Uint8List buffer) {
//         _pcmVerificationBuffer.addAll(buffer);
//         print("🔊 Received PCM chunk of size: ${buffer.length} bytes");
//       });
//     } catch (e) {
//       print("❌ Error أثناء التسجيل: $e");
//     }
//   }
//
//   Future<void> stopRecording() async {
//     if (!_isRecording) return;
//     _isRecording = false;
//     await _recorder.stop();
//     print("🛑 Recording stopped.");
//   }
//   Future<void> _saveAndSendAudio() async {
//     if (_pcmVerificationBuffer.isEmpty) return;
//
//     Uint8List aggregatedPCM = Uint8List.fromList(_pcmVerificationBuffer);
//     // **هام: استخدام معدل العينة الصحيح (32000)**
//     Uint8List wavData = await convertPCMToWAVWithPackage(aggregatedPCM, 32000, 1);
//
//     // تحويل الصوت إلى نص
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final timestamp = DateTime.now().millisecondsSinceEpoch;
//     final filePath = '${appDocDir.path}/temp_audio_$timestamp.wav'; // مسار مؤقت
//     final file = File(filePath);
//     await file.writeAsBytes(wavData); // حفظ البيانات بتنسيق WAV في ملف مؤقت
//    // String recognizedText = await convertAudioToText(filePath);
//     //print("📝 Recognized Text: $recognizedText");
//
//     // إرسال البيانات عبر WebSocket
//     if (_channel != null && _channel!.closeCode == null) {
//       _channel!.sink.add(wavData);
//       print("🔊 Sent audio data to server, size: ${wavData.length} bytes");
//     } else {
//       print("⚠️ WebSocket is not connected, cannot send data.");
//     }
//
//     // حفظ الملف في دليل المستندات
//     final appDocDir2 = await getApplicationDocumentsDirectory();
//     final timestamp2 = DateTime.now().millisecondsSinceEpoch;
//     final filePath2 = '${appDocDir2.path}/verification_$timestamp2.wav';
//     final file2 = File(filePath2);
//     await file2.writeAsBytes(wavData);
//     print('✅ Aggregated audio saved: $filePath2, total size: ${wavData.length} bytes');
//
//     // تفريغ البافر بعد الإرسال
//     _pcmVerificationBuffer.clear();
//   }
//
//
//
//
//   Future<void> _saveChunkForVerification(Uint8List wavData) async {
//     // إضافة الـ chunk الحالي إلى البافر
//     _verificationBuffer.addAll(wavData);
//
//     // إذا كان هناك مؤقت قائم، نقوم بإلغائه لإعادة التعيين
//     _verificationTimer?.cancel();
//
//     // تعيين مؤقت جديد يتم تنفيذه بعد 5 ثوانٍ من عدم استقبال بيانات جديدة
//     _verificationTimer = Timer(Duration(seconds: 5), () async {
//       // طباعة طول البافر للتأكد من وجود بيانات
//       print("Timer expired. Buffer length: ${_verificationBuffer.length} bytes");
//
//       try {
//         final directory = await getTemporaryDirectory();
//         String filePath = "${directory.path}/verification_audio_${DateTime.now().millisecondsSinceEpoch}.wav";
//         final file = File(filePath);
//         await file.writeAsBytes(_verificationBuffer);
//         print("✅ Aggregated audio saved to file: $filePath, length: ${_verificationBuffer.length} bytes");
//       } catch (e) {
//         print("❌ Error saving aggregated audio: $e");
//       }
//       // تفريغ البافر وإعادة تعيين المؤقت
//       _verificationBuffer.clear();
//       _verificationTimer = null;
//     });
//   }
//   Future<Uint8List> convertPCMToWAVWithPackage(Uint8List pcmData, int sampleRate, int numChannels) async {
//     try {
//       final bytesBuilder = BytesBuilder();
//       final int fileSize = pcmData.length + 36;
//       bytesBuilder.add([82, 73, 70, 70]); // "RIFF"
//       bytesBuilder.add((ByteData(4)..setUint32(0, fileSize, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add([87, 65, 86, 69]); // "WAVE"
//       bytesBuilder.add([102, 109, 116, 32]); // "fmt "
//       bytesBuilder.add((ByteData(4)..setUint32(0, 16, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add((ByteData(2)..setUint16(0, 1, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add((ByteData(2)..setUint16(0, numChannels, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add((ByteData(4)..setUint32(0, sampleRate, Endian.little)).buffer.asUint8List());
//       int byteRate = sampleRate * numChannels * 2;
//       bytesBuilder.add((ByteData(4)..setUint32(0, byteRate, Endian.little)).buffer.asUint8List());
//       int blockAlign = numChannels * 2;
//       bytesBuilder.add((ByteData(2)..setUint16(0, blockAlign, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add((ByteData(2)..setUint16(0, 16, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add([100, 97, 116, 97]); // "data"
//       bytesBuilder.add((ByteData(4)..setUint32(0, pcmData.length, Endian.little)).buffer.asUint8List());
//       bytesBuilder.add(pcmData);
//       return bytesBuilder.takeBytes();
//     } catch (e) {
//       print('Error converting to WAV: $e');
//       return Uint8List(0);
//     }
//   }
// }
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:permission_handler/permission_handler.dart'; // Optional: for explicit permission checks here
import 'package:path_provider/path_provider.dart';
// --- VAD Package and Settings Import ---
import 'package:vad/vad.dart'; // Replace 'vad' with your actual VAD package import if different
// Ensure this path is correct for your project structure

class WebSocketService {
  final String wsUrl;
  WebSocketChannel? _channel;
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isVadListening = false;
  bool _isPlayingAudio = false; // To prevent VAD start during playback
  final List<int> _serverAudioBuffer = []; // Made final
  final int _serverBufferThreshold = 500000;

  // --- VAD Specific Variables ---
  VadHandlerBase? _vadHandler;
  final VadSettings _vadSettings;
  final List<int> _currentSpeechSegment =
      []; // To accumulate PCM data for the current speech utterance
  Timer?
      _silenceDetectionTimer; // To detect end of speech based on silence duration

  String? _sessionId; // To store session ID from server

  // --- Stream for UI updates ---
  final StreamController<bool> _speakingStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get speakingStatusStream => _speakingStatusController.stream;

  // --- Optional Callbacks for external logging/event handling ---
  final Function(String message)? onDebugMessage;
  final Function(String type, dynamic data)? onVadEvent;

  WebSocketService({
    required int userId,
    VadSettings? vadSettings, // Allow custom VAD settings
    this.onDebugMessage,
    this.onVadEvent,
  })  : wsUrl =
            "R$userId",
        _vadSettings = vadSettings ?? VadSettings() {
    // Use provided settings or default.
    _printDebug(
        "WebSocketService initialized for user: $userId. VAD SR: ${this._vadSettings.sampleRate}, FS: ${this._vadSettings.frameSamples}");
  }

  void _printDebug(String message) {
    print("🎤 [VADService] $message");
    onDebugMessage?.call("🎤 [VADService] $message");
  }

  Future<void> _initializeVad() async {
    if (_vadHandler != null) {
      // Assuming dispose is synchronous (void). If it's Future, add await.
      _vadHandler!.dispose();
      _printDebug("Previous VAD Handler disposed.");
    }
    try {
      // isDebug could be a param in VadSettings or hardcoded
      _vadHandler = VadHandler.create(isDebug: true);
      _setupVadListeners();
      _printDebug(
          "✅ VAD Initialized. Model: ${_vadSettings.modelString}, AssetPath: ${_vadSettings.baseAssetPath}");
    } catch (e) {
      _printDebug("❌ Error initializing VAD: $e");
      _vadHandler = null;
    }
  }

  void _setupVadListeners() {
    if (_vadHandler == null) return;

    _vadHandler!.onSpeechStart.listen((_) {
      _printDebug("🎤 VAD onSpeechStart: Speech detected by VAD package.");
      _speakingStatusController.add(true);
      onVadEvent?.call("vad_speech_start", null);
      _currentSpeechSegment.clear();
      _resetSilenceTimer();
    });

    // Corrected frame processed listener
    _vadHandler!.onFrameProcessed.listen((event) {
      if (!_isVadListening) return;

      try {
        final frame = event.frame;
        final isSpeech = event.isSpeech;

        // Convert to 16-bit PCM
        final pcmData = _convertToPcm16(frame);
        _currentSpeechSegment.addAll(pcmData);

        if (isSpeech > 0.5) {
          _resetSilenceTimer();
        }
      } catch (e) {
        _printDebug("Error processing frame: $e");
      }
    });

    _vadHandler!.onSpeechEnd.listen((List<double> samples) {
      _printDebug(
          "🎤 VAD onSpeechEnd (from package): ${samples.length} samples. Package auto-segmented.");
      _speakingStatusController
          .add(false); // VAD package detected end of speech
      onVadEvent?.call("vad_speech_end_package", samples.length);
      // This event means the VAD package itself decided an utterance ended.
      // We can choose to send this directly OR rely solely on our silence timer.
      // For more Python-like control, we primarily rely on our silence timer.
      // However, if this fires and we have data, it's a good idea to send it.
      if (samples.isNotEmpty && _currentSpeechSegment.isEmpty) {
        // If our buffer is empty, use this
        final pcm16Samples = Int16List(samples.length);
        for (int i = 0; i < samples.length; i++)
          pcm16Samples[i] = (samples[i] * 32767.0).round().toInt();
        _sendPcmAudioToServer(Uint8List.view(pcm16Samples.buffer));
      } else if (_currentSpeechSegment.isNotEmpty) {
        // If our buffer has data, the silence timer will likely handle it,
        // or stopListening() will. We can also choose to send here.
        // _sendCurrentSpeechSegment(); // Option: send immediately
      }
      _cancelSilenceTimer(); // VAD lib ended segment, cancel our timer
    });

    _vadHandler!.onVADMisfire.listen((_) {
      _printDebug('🎤 VAD Misfire detected.');
      _speakingStatusController.add(false);
      onVadEvent?.call("vad_misfire", null);
    });

    _vadHandler!.onError.listen((String message) {
      _printDebug('❌ VAD Error: $message');
      _speakingStatusController.add(false);
      onVadEvent?.call("vad_error", message);
      // Consider stopping VAD listening on critical errors
    });
  }

  List<int> _convertToPcm16(List<double> audioData) {
    final pcm16 = Int16List(audioData.length);
    for (int i = 0; i < audioData.length; i++) {
      pcm16[i] = (audioData[i] * 32767).clamp(-32768, 32767).toInt();
    }
    return pcm16.buffer.asUint8List().toList();
  }

  void _resetSilenceTimer() {
    _cancelSilenceTimer();
    // Similar to Python's silence_threshold_seconds (e.g., 1.0 second)
    const double silenceThresholdSeconds = 1.0;
    _silenceDetectionTimer = Timer(
        Duration(milliseconds: (silenceThresholdSeconds * 1000).round()), () {
      _printDebug(
          "⏰ Silence threshold of ${silenceThresholdSeconds}s reached. Sending buffered audio.");
      if (_isVadListening) {
        // Only send if still supposed to be listening
        _speakingStatusController.add(false); // Speech has ended due to silence
        _sendCurrentSpeechSegment();
      }
    });
  }

  void _cancelSilenceTimer() {
    _silenceDetectionTimer?.cancel();
    _silenceDetectionTimer = null;
  }

  void _sendCurrentSpeechSegment() {
    _cancelSilenceTimer();

    if (_currentSpeechSegment.isEmpty) {
      return;
    }

    // Min audio length check (e.g., 0.3 seconds)
    // For 16kHz, 16-bit, 0.3s = 16000 * 0.3 * 2 bytes = 9600 bytes
    // For 32kHz, 16-bit, 0.3s = 32000 * 0.3 * 2 bytes = 19200 bytes
    final minAudioLengthBytes = (_vadSettings.sampleRate *
            0.3 *
            (_vadSettings.sampleRate == 16000 ? 2 : 2))
        .round();

    if (_currentSpeechSegment.length < minAudioLengthBytes) {
      _printDebug(
          "🚫 Ignored short audio chunk (${_currentSpeechSegment.length} bytes), less than ${minAudioLengthBytes}B.");
      _currentSpeechSegment.clear();
      return;
    }

    Uint8List dataToSend = Uint8List.fromList(_currentSpeechSegment);
    _currentSpeechSegment.clear(); // Clear after copying

    _sendPcmAudioToServer(dataToSend);
  }

  Future<void> connect() async {
    await _initializeVad();
    if (_vadHandler == null) {
      _printDebug("❌ VAD initialization failed. Cannot connect WebSocket.");
      return;
    }
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(wsUrl));
      _printDebug("🔌 Attempting to connect to WebSocket Server: $wsUrl");
      await _channel!.ready;
      _printDebug("✅ WebSocket Connection Established!");

      _channel!.stream.listen(
        (data) {
          if (data is String) {
            _sessionId = data;
            _printDebug("🆔 Received session_id: $_sessionId");
            onVadEvent?.call("session_id_received", _sessionId);
          } else if (data is Uint8List) {
            _accumulateServerAudio(data);
          } else {
            _printDebug(
                "❓ Received unknown data type from WebSocket: ${data.runtimeType}");
          }
        },
        onError: (error) {
          _printDebug("❌ WebSocket stream error: $error");
          _channel = null;
          _isVadListening = false; // Stop VAD if connection drops
          _speakingStatusController.add(false);
        },
        onDone: () {
          _printDebug("🚪 WebSocket stream closed by server.");
          _channel = null;
          if (_isVadListening) {
            // Call the full stopListening to ensure cleanup and final send
            stopListening();
          }
        },
        cancelOnError: true,
      );
    } catch (e) {
      _printDebug("❌ WebSocket connection error: $e");
      _channel = null;
    }
  }

  void _accumulateServerAudio(Uint8List newData) async {
    _serverAudioBuffer.addAll(newData);
    if (_serverAudioBuffer.length >= _serverBufferThreshold) {
      _printDebug("Buffer threshold for server audio reached, playing...");
      await _playReceivedAudio(Uint8List.fromList(_serverAudioBuffer));
      _serverAudioBuffer.clear();
    }
  }

  Future<void> _playReceivedAudio(Uint8List audioData) async {
    if (audioData.isEmpty) {
      _printDebug("🎧 No server audio data to play.");
      return;
    }
    _isPlayingAudio = true;
    _speakingStatusController.add(false); // Not speaking while playing

    bool wasListening = _isVadListening; // Store current VAD state

    try {
      if (wasListening) {
        _printDebug("🔇 Temporarily stopping VAD for server audio playback...");
        // We don't want to call the full stopListening() which might send a premature segment.
        // Just stop the VAD handler.
        _cancelSilenceTimer();
        if (_vadHandler != null) {
          // Assuming stopListening is synchronous, if not, use await
          _vadHandler!.stopListening();
        }
        _isVadListening = false; // Manually update our flag
        _printDebug("🛑 VAD handler stopped for playback.");
      }

      final appDocDir = await getApplicationDocumentsDirectory();
      final tempAudioFile = File(
          "${appDocDir.path}/server_audio_${DateTime.now().millisecondsSinceEpoch}.wav");
      await tempAudioFile.writeAsBytes(audioData);
      _printDebug(
          "🎧 Server audio saved temporarily to: ${tempAudioFile.path}");

      await _audioPlayer.setFilePath(tempAudioFile.path);

      _audioPlayer.playerStateStream
          .firstWhere(
              (state) => state.processingState == ProcessingState.completed)
          .then((_) async {
        _printDebug("🎶 Server audio playback completed.");
        _isPlayingAudio = false;
        try {
          await tempAudioFile.delete();
          _printDebug("🗑️ Deleted temporary server audio file.");
        } catch (e) {
          _printDebug("⚠️ Error deleting temp server audio file: $e");
        }
        // Only restart VAD if it was listening before and user hasn't manually stopped it.
        if (wasListening && !_isVadListening) {
          _printDebug("🎤 Restarting VAD listening after playback.");
          await startListening();
        }
      }).catchError((e) {
        // Catch errors from the future/stream
        _printDebug("❌ Error during audio playback stream: $e");
        _isPlayingAudio = false;
        if (wasListening && !_isVadListening) {
          startListening(); // Attempt to restart VAD
        }
      });

      _printDebug("🎶 Playing received server audio (WAV)...");
      await _audioPlayer.play();
    } catch (e) {
      _printDebug("❌ Error playing server audio: $e");
      _isPlayingAudio = false;
      if (wasListening && !_isVadListening) {
        _printDebug(
            "🎤 Attempting to restart VAD listening after playback error.");
        await startListening();
      }
    }
  }

  Future<void> startListening() async {
    if (_isVadListening) {
      _printDebug("🎤 VAD is already listening.");
      return;
    }
    if (_isPlayingAudio) {
      _printDebug("🎤 Cannot start VAD listening: Audio is currently playing.");
      return;
    }
    if (_vadHandler == null) {
      _printDebug("🚦 VAD not initialized. Attempting to initialize...");
      await _initializeVad();
      if (_vadHandler == null) {
        _printDebug("❌ VAD initialization failed. Aborting startListening.");
        return;
      }
    }
    if (_channel == null || _channel!.closeCode != null) {
      _printDebug("🔌 WebSocket not connected. Cannot start VAD listening.");
      // Optionally, try to connect:
      // await connect();
      // if (_channel == null || _channel!.closeCode != null) return;
      return;
    }

    // Permission check should ideally be done in UI before calling this
    // final micPermission = await Permission.microphone.request();
    // if (!micPermission.isGranted) {
    //   _printDebug("🚨 Microphone permission denied by user!");
    //   return;
    // }

    try {
      _printDebug("🎤 Attempting to start VAD listening...");
      _vadHandler!.startListening(
        frameSamples: _vadSettings.frameSamples,
        minSpeechFrames: _vadSettings.minSpeechFrames,
        preSpeechPadFrames: _vadSettings.preSpeechPadFrames,
        redemptionFrames: _vadSettings.redemptionFrames,
        positiveSpeechThreshold: _vadSettings.positiveSpeechThreshold,
        negativeSpeechThreshold: _vadSettings.negativeSpeechThreshold,
        submitUserSpeechOnPause: _vadSettings.submitUserSpeechOnPause,
        model: _vadSettings.modelString,
        baseAssetPath: _vadSettings.baseAssetPath,
        onnxWASMBasePath: _vadSettings.onnxWASMBasePath,
        // sampleRate: _vadSettings.sampleRate, // Pass if your VAD package needs it here
      );

      _isVadListening = true;
      _currentSpeechSegment.clear();
      // _resetSilenceTimer(); // onSpeechStart from VAD will trigger this
      _printDebug("✅ VAD listening started.");
      onVadEvent?.call("listening_started", null);
      // _speakingStatusController.add(true); // onSpeechStart will handle this
    } catch (e) {
      _printDebug("❌ Error starting VAD listening: $e");
      _isVadListening = false;
      _speakingStatusController.add(false);
      onVadEvent?.call("listening_error", e.toString());
    }
  }

  Future<void> stopListening() async {
    if (!_isVadListening) {
      // Check our internal flag
      _printDebug("🛑 VAD listening is already stopped or not active.");
      return;
    }

    _printDebug("🛑 Attempting to stop VAD listening...");
    _isVadListening = false; // Set our flag immediately
    _speakingStatusController.add(false);
    _cancelSilenceTimer();

    if (_vadHandler !=
        null /* && _vadHandler!.isListening - Rely on our flag */) {
      try {
        // Assuming _vadHandler.stopListening() is synchronous (void).
        // If it returns a Future, add 'await'.
        _vadHandler!.stopListening();
        _printDebug("✅ VAD handler stop command issued.");
      } catch (e) {
        _printDebug("⚠️ Error issuing stop to VAD handler: $e");
      }
    }

    _sendCurrentSpeechSegment(); // Send any remaining buffered audio
    onVadEvent?.call("listening_stopped", null);
  }
Future<void> _sendPcmAudioToServer(Uint8List pcmData) async {
  if (pcmData.isEmpty || _channel == null) return;

  try {
    Uint8List wavData = await _convertPCMToWAV(pcmData, 16000, 1);

    _channel!.sink.add(wavData);
    _printDebug("Sent ${wavData.length} bytes (WAV) to server");
  } catch (e) {
    _printDebug("Error sending audio: $e");
  }
}

  Future<void> _saveAudioLocallyForVerification(
      Uint8List pcmData, String prefix) async {
    if (pcmData.isEmpty) return;
    //   try {
    //     // Using getExternalFilesDir for app-specific external storage
    //     final Directory? appExternalDir = await getExternalFilesDir(null);
    //     if (appExternalDir == null) {
    //       _printDebug("❌ Could not get app external directory to save $prefix file.");
    //       return;
    //     }
    //     final String recordingsPath = '${appExternalDir.path}/VerificationRecordings';
    //     final Directory recordingsDir = Directory(recordingsPath);
    //     if (!await recordingsDir.exists()) {
    //       await recordingsDir.create(recursive: true);
    //     }

    //     final timestamp = DateTime.now().millisecondsSinceEpoch;
    //     // Convert PCM to WAV for easy playback during verification
    //     Uint8List wavData = await _convertPCMToWAV(pcmData, _vadSettings.sampleRate, 1);
    //     final String filePath = '${recordingsDir.path}/${prefix}_$timestamp.wav';
    //     final File file = File(filePath);
    //     await file.writeAsBytes(wavData);
    //     _printDebug('✅ $prefix audio saved locally: $filePath, WAV size: ${wavData.length} bytes (PCM: ${pcmData.length})');
    //   } catch (e) {
    //     _printDebug("❌ Error saving $prefix audio locally: $e");
    //   }
    // }

Future<Uint8List>
    _convertPCMToWAV(
        Uint8List pcmData, int sampleRate, int numChannels) async {
      if (pcmData.isEmpty) return Uint8List(0);
      try {
        final bytesBuilder = BytesBuilder();
        // WAV Header (Standard 44-byte header for PCM)
        bytesBuilder.add("RIFF".codeUnits); // ChunkID
        int fileSize = pcmData.length + 36; // ChunkSize = 36 + SubChunk2Size
        bytesBuilder.add((ByteData(4)..setUint32(0, fileSize, Endian.little))
            .buffer
            .asUint8List());
        bytesBuilder.add("WAVE".codeUnits); // Format
        bytesBuilder.add("fmt ".codeUnits); // Subchunk1ID
        bytesBuilder.add((ByteData(4)..setUint32(0, 16, Endian.little))
            .buffer
            .asUint8List()); // Subchunk1Size (16 for PCM)
        bytesBuilder.add((ByteData(2)..setUint16(0, 1, Endian.little))
            .buffer
            .asUint8List()); // AudioFormat (1 for PCM)
        bytesBuilder.add((ByteData(2)..setUint16(0, numChannels, Endian.little))
            .buffer
            .asUint8List()); // NumChannels
        bytesBuilder.add((ByteData(4)..setUint32(0, sampleRate, Endian.little))
            .buffer
            .asUint8List()); // SampleRate
        int byteRate = sampleRate *
            numChannels *
            (16 ~/ 8); // ByteRate (SampleRate * NumChannels * BitsPerSample/8)
        bytesBuilder.add((ByteData(4)..setUint32(0, byteRate, Endian.little))
            .buffer
            .asUint8List());
        int blockAlign = numChannels *
            (16 ~/ 8); // BlockAlign (NumChannels * BitsPerSample/8)
        bytesBuilder.add((ByteData(2)..setUint16(0, blockAlign, Endian.little))
            .buffer
            .asUint8List());
        bytesBuilder.add((ByteData(2)..setUint16(0, 16, Endian.little))
            .buffer
            .asUint8List()); // BitsPerSample (16-bit)
        bytesBuilder.add("data".codeUnits); // Subchunk2ID
        bytesBuilder.add((ByteData(4)
              ..setUint32(0, pcmData.length, Endian.little))
            .buffer
            .asUint8List()); // Subchunk2Size (pcmData.length)
        bytesBuilder.add(pcmData); // Actual sound data
        return bytesBuilder.toBytes();
      } catch (e) {
        _printDebug('Error converting PCM to WAV: $e');
        return Uint8List(0);
      }
    }

    Future<void> dispose() async {
      _printDebug("Disposing WebSocketService with VAD...");
      await stopListening(); // This will also cancel the silence timer
      _channel?.sink.close();
      _channel = null;
      // Assuming _vadHandler.dispose() is synchronous (void)
      _vadHandler?.dispose();
      _vadHandler = null;
      await _audioPlayer.dispose();
      _speakingStatusController.close();
      _printDebug("WebSocketService with VAD disposed.");
    }
  }
  
  _convertPCMToWAV(Uint8List pcmData,
   int  sampleRate
   ,
  
   int numChannels
)
 {
      if (pcmData.isEmpty) return Uint8List(0);
      try {
        final bytesBuilder = BytesBuilder();
        // WAV Header (Standard 44-byte header for PCM)
        bytesBuilder.add("RIFF".codeUnits); // ChunkID
        int fileSize = pcmData.length + 36; // ChunkSize = 36 + SubChunk2Size
        bytesBuilder.add((ByteData(4)..setUint32(0, fileSize, Endian.little))
            .buffer
            .asUint8List());
        bytesBuilder.add("WAVE".codeUnits); // Format
        bytesBuilder.add("fmt ".codeUnits); // Subchunk1ID
        bytesBuilder.add((ByteData(4)..setUint32(0, 16, Endian.little))
            .buffer
            .asUint8List()); // Subchunk1Size (16 for PCM)
        bytesBuilder.add((ByteData(2)..setUint16(0, 1, Endian.little))
            .buffer
            .asUint8List()); // AudioFormat (1 for PCM)
        bytesBuilder.add((ByteData(2)..setUint16(0, numChannels, Endian.little))
            .buffer
            .asUint8List()); // NumChannels
        bytesBuilder.add((ByteData(4)..setUint32(0, sampleRate, Endian.little))
            .buffer
            .asUint8List()); // SampleRate
        int byteRate = sampleRate *
            numChannels *
            (16 ~/ 8); // ByteRate (SampleRate * NumChannels * BitsPerSample/8)
        bytesBuilder.add((ByteData(4)..setUint32(0, byteRate, Endian.little))
            .buffer
            .asUint8List());
        int blockAlign = numChannels *
            (16 ~/ 8); // BlockAlign (NumChannels * BitsPerSample/8)
        bytesBuilder.add((ByteData(2)..setUint16(0, blockAlign, Endian.little))
            .buffer
            .asUint8List());
        bytesBuilder.add((ByteData(2)..setUint16(0, 16, Endian.little))
            .buffer
            .asUint8List()); // BitsPerSample (16-bit)
        bytesBuilder.add("data".codeUnits); // Subchunk2ID
        bytesBuilder.add((ByteData(4)
              ..setUint32(0, pcmData.length, Endian.little))
            .buffer
            .asUint8List()); // Subchunk2Size (pcmData.length)
        bytesBuilder.add(pcmData); // Actual sound data
        return bytesBuilder.toBytes();
      } catch (e) {
        _printDebug('Error converting PCM to WAV: $e');
        return Uint8List(0);
      }
  }
}

class VadSettings {
  // lib/vad_settings.dart

  int sampleRate;
  int frameSamples;
  int minSpeechFrames;
  int preSpeechPadFrames;
  int redemptionFrames;
  double positiveSpeechThreshold;
  double negativeSpeechThreshold;
  bool submitUserSpeechOnPause;
  String modelString;
  String baseAssetPath;
  String onnxWASMBasePath;

  VadSettings({
    this.sampleRate = 16000, // CHOOSE: 16000 or 32000. Must match server STT.
    // Python example used 16000Hz.
    // Calculate frameSamples based on sampleRate and desired frame duration (e.g., 30ms)
    // For 30ms: sampleRate * 0.030
    this.frameSamples =
        8000, // e.g., 480 for 16kHz, 30ms. Adjust if sampleRate changes.
    this.minSpeechFrames = 5, // Min speech frames to trigger 'speech start'
    this.preSpeechPadFrames = 10, // Silence frames to add before speech
    this.redemptionFrames =
        25, // Speech frames after short silence to continue segment
    this.positiveSpeechThreshold = 0.6,
    this.negativeSpeechThreshold = 0.2,
    this.submitUserSpeechOnPause =
        true, // If VAD lib should auto-submit on its detected pause
    this.modelString =
        "silero_vad.onnx", // CHECK YOUR VAD PACKAGE FOR THE CORRECT MODEL NAME

    // **VERY IMPORTANT: Adjust these paths based on your VAD package and asset location**
    // Scenario 1: VAD package bundles assets (replace 'vad' with actual package name if different)
    this.baseAssetPath = "packages/vad/assets/",
    this.onnxWASMBasePath = "packages/vad/assets/",
    // Scenario 2: You manually placed assets in 'assets/my_vad_models/'
    // this.baseAssetPath = "assets/my_vad_models/",
    // this.onnxWASMBasePath = "assets/my_vad_models/",
  });

  @override
  String toString() {
    return 'VadSettings(sampleRate: $sampleRate, frameSamples: $frameSamples, model: $modelString, basePath: $baseAssetPath)';
  }
}

// lib/vad_settings.dart
class FrameData {
  final List<double> frame; // Float PCM samples normalized between -1.0 and 1.0
  final bool isSpeech;

  FrameData({required this.frame, required this.isSpeech});
}
