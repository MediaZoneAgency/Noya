import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broker/feature/chat/data/model/chat_history_model.dart';
import 'package:broker/feature/chat/data/model/sessions_id_model.dart';
import 'package:broker/feature/chat/data/model/start_session_response.dart';
import 'package:dio/dio.dart';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:retry/retry.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../../core/error/error_model.dart';
import '../../../../core/helpers/cash_helper.dart';
import '../../../../core/network/network_constant.dart';
import '../model/chat_model.dart';
import '../model/feedback_model.dart';

import 'dart:io';
import 'package:just_audio/just_audio.dart';

class ChatService {
  Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 220),
      receiveTimeout: const Duration(seconds: 220),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  WebSocketChannel? _channel;
  StreamSubscription<Uint8List>? _audioStreamSubscription;
  bool _isRecording = false;
  Uint8List? _audioBuffer;

  String? _sessionId;
  //final FlutterSoundPlayer _flutterSoundPlayer = FlutterSoundPlayer();

  ChatService(this._dio);
/*************  ✨ Windsurf Command ⭐  *************/
  /// Sends a POST request to the server with the given [chatModel]'s message
  /// and returns a [StreamResponse] containing the response stream and headers.
  ///
  /// The request includes the user's ID in the headers, which is retrieved
  /// securely using [CashHelper].
  ///
  /// The response stream is converted from a byte stream to a string stream
  /// using [utf8.decode].
  ///
  /// If the request fails due to a connection timeout, it is retried up to
  /// 3 times using [retry].
  ///
  /// If any other error occurs, it is caught and re-thrown as an [ApiErrorModel]
  /// with a generic error message.
  ///
  Future<StartSessionResponse> startSession(String userId) async {
    try {
      print(NetworkConstant.startChat);
      final response = await _dio.post(
        NetworkConstant.startChat, // URL بتاع /start-session/
        options: Options(
          headers: {
            'user-id': userId, // الهيدر الصحيح
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        print('RESPONSEEE${response.data["messages"][0]["content"]}');
        // String msg =
        //     response.data; // مش محتاج jsonDecode هنا
         final sessionValue = data["session_id"]; // ✅ استخرج قيمة الـ session_id

      // ✅ خزّنها في المتغير المحلي و في التخزين الآمن
      _sessionId = sessionValue;
      await CashHelper.setStringSecured(
        key: Keys.session_id,
        value: sessionValue,
      );

      print('🆔 Session ID saved: $sessionValue');
        return StartSessionResponse.fromJson(response.data);
        // {
        //   "session_id": data["session_id"],
        //   "welcome_message": data["messages"][0]["content"],
        // };
     } else {
  print("❌ Failed to start session: ${response.statusCode} - ${response.data}");
  throw Exception("Start session failed");
}
} catch (e) {
print("❌ Dio error in startSession: $e");
throw Exception("Failed to start session: $e");
}
}

  Future<StreamResponse> sendMessageStreamWithHeaders(
      ChatModel chatModel) async {
    try {
      final String userId = await CashHelper.getStringSecured(key: Keys.id);
      print("Sending request with User ID: $userId");
      // ✅ تحميل session-id من الكاش إذا مش موجود محليًا
      // if (_sessionId == '' ) {
      //   _sessionId = await CashHelper.getStringSecured(key: Keys.session_id);
      //   print("📥 Retrieved session-id from cache: $_sessionId");
      // }

      final r = RetryOptions(maxAttempts: 3);

      final response = await r.retry(
        () async {
          final headers = {
            'user-id': userId,
            // نرسلها لو موجودة
          };
// final quary={}
          print("➡️ Request Headers: $headers");

          return await _dio.post(
            NetworkConstant.chat,
            queryParameters: {
              "session_id": _sessionId,
            },
            data: {'message': chatModel.message},
            options: Options(
              responseType: ResponseType.stream,
              receiveTimeout: const Duration(seconds: 220),
              headers: headers,
            ),
          );
        },
        retryIf: (e) =>
            e is DioException && e.type == DioExceptionType.connectionTimeout,
        onRetry: (e) => print("🔁 Retrying after connection error: $e"),
      );

      // 🧠 استخراج الهيدرز
      final headers = response.headers.map;

      // ✅ أول مرة فقط خزّن الـ session-id في المتغير المحلي
//     if (_sessionId == null && headers['session-id']?.isNotEmpty == true) {
//   _sessionId = headers['session-id']!.first;
//   await CashHelper.setStringSecured(key: Keys.session_id, value: _sessionId!);
//   print("🆔 Session ID stored: $_sessionId");
// }

      // 🖨️ طباعة كل الهيدرز المستلمة
      print("📬 Headers from server:");
      headers.forEach((key, value) async {
        if (key == 'x-session-id') {
          final sessionValue = value.join(', ');
          _sessionId = sessionValue; // ✅ خزّنها هنا كمان
          await CashHelper.setStringSecured(
            key: Keys.session_id,
            value: sessionValue,
          );
          print("✅ Stored x-session-id: $_sessionId");
        } else {
          print("🔹 $key: ${value.join(', ')}");
        }
      });

//   if (_sessionId == null && headers['session-id']?.isNotEmpty == true) {
//   _sessionId = headers['session-id']!.first;
//   await CashHelper.setStringSecured(key: Keys.session_id, value: _sessionId!);
//   print("🆔 Session ID stored: $_sessionId");
// }
      final stream = response.data as ResponseBody;
      final streamController = StreamController<String>();

      stream.stream.listen(
        (List<int> chunk) {
          final chunkString = utf8.decode(chunk);
          streamController.add(chunkString);
        },
        onDone: () => streamController.close(),
        onError: (e) => streamController.addError(e),
        cancelOnError: true,
      );

      return StreamResponse(
        stream: streamController.stream,
        headers: headers.map((key, value) => MapEntry(key, value.join(', '))),
      );
    } on DioException catch (dioError) {
      print("Dio Error: ${dioError.message}");
      throw ApiErrorModel(
          message: "حدث خطأ أثناء الاتصال بالخادم: ${dioError.message}");
    } catch (e) {
      print("Generic Error: $e");
      throw ApiErrorModel(message: "حدث خطأ غير متوقع: $e");
    }
  }

  Future<ChatHistoryResponseModel> getChatHistory(String userId) async {
    // Construct the specific URL for the user
    // IMPORTANT: Ensure NetworkConstant.chatHistoryBaseUrl is defined correctly
    // Example: final String historyUrl = "${NetworkConstant.chatHistoryBaseUrl}/$userId";
    // Or directly use the full URL if NetworkConstant doesn't split it:
    final String historyUrl =
        "https://dashboardadmin.mediazoneag.com/api/chat/history/$userId";
    print("Fetching chat history from: $historyUrl");

    try {
      final response = await _dio.get(
        historyUrl,
        options: Options(
          headers: {
            // Add any necessary headers here, like Authorization if required by the API
            // 'Authorization': 'Bearer YOUR_TOKEN',
            // 'Accept': 'application/json', // Good practice
          },
          // Set response type if Dio doesn't automatically handle JSON well
          // responseType: ResponseType.json,
        ),
      );

      // Check for successful status code (e.g., 200 OK)
      if (response.statusCode == 200 && response.data != null) {
        // Parse the JSON response using the model's factory constructor
        // Dio often parses JSON automatically, otherwise use jsonDecode:
        // Map<String, dynamic> jsonMap = jsonDecode(response.data as String);
        return ChatHistoryResponseModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        // Handle non-200 status codes or null data
        print(
            "Error fetching history: Status code ${response.statusCode}, Data: ${response.data}");
        throw ApiErrorModel(
            message:
                "Failed to load chat history (Status: ${response.statusCode})");
      }
    } on DioException catch (dioError) {
      // Handle Dio-specific errors (network, timeout, etc.)
      print("Dio Error fetching history: ${dioError.message}");
      print("Dio Error Response: ${dioError.response?.data}");
      // You might want to parse the error response from the server if available
      String serverErrorMessage = dioError.response?.data?['message'] ??
          dioError.message ??
          "Unknown Dio error";
      throw ApiErrorModel(
          message: "Network error fetching history: $serverErrorMessage");
    } catch (e) {
      // Handle other potential errors (parsing, etc.)
      print("Generic Error fetching history: $e");
      throw ApiErrorModel(
          message: "An unexpected error occurred while fetching chat history.");
    }
  }

  // ... other service methods like sendMessageStreamWithHeaders, sendFeedback etc.
  Future<SessionHistoryModel> fetchSessionHistory(
      {required String userId}) async {
    try {
      final response = await _dio.get(
          'https://dashboardadmin.mediazoneag.com/api/user/$userId/sessions');
      return SessionHistoryModel.fromMap(response.data);
    } catch (e) {
      print("❌ Error fetching session history: $e");
      rethrow;
    }
  }

  Future<void> sendFeedback(FeedbackModel feedback) async {
    try {
      await _dio.post(
        NetworkConstant.chat,
        data: feedback.toMap(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } catch (e) {
      throw ApiErrorModel(message: e.toString());
    }
  }

  Future<dynamic> recordAndSendAudio() async {
    try {
      print("🎤 بدء التسجيل بصيغة WAV...");

      final tempDir = await getTemporaryDirectory();
      final wavFilePath = "${tempDir.path}/recorded_audio.wav";

      // 🔹 **Check and Request Microphone Permission**
      if (!await _recorder.hasPermission()) {
        throw Exception("🚨 لا توجد صلاحية للوصول إلى الميكروفون!");
      }

      // 🔹 **Start Recording in WAV Format**
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: wavFilePath,
      );

      await Future.delayed(Duration(seconds: 5)); // Duration of recording

      final recordedPath = await _recorder.stop();
      if (recordedPath == null) {
        throw Exception("🚨 فشل التسجيل!");
      }

      print("✅ تم تسجيل الصوت بنجاح: $recordedPath");

      final file = File(recordedPath);
      if (!await file.exists()) {
        throw Exception("🚨 ملف الصوت غير موجود!");
      }

      print("✅ الملف الصوتي موجود وسيتم إرساله.");
      print("📄 التحقق من FormData قبل الإرسال...");

      // ✅ **Create FormData**
      final formData = FormData.fromMap({
        "interaction_mode": "voice",
        "message": "",
        "voice_file": await MultipartFile.fromFile(
          file.absolute.path,
          filename: "audio.wav",
        ),
        "language": "ar-AR"
      });

      print("📩 البيانات المُرسلة:");
      formData.fields
          .forEach((field) => print("🔹 ${field.key}: ${field.value}"));
      print(
          "🔍 ملف الصوت: ${file.absolute.path} | الحجم: ${await file.length()} bytes");

      // ✅ **Send Initial Request**
      final response = await _dio.post(
        "http://real-estate-chatbot-j26jnniwla-uc.a.run.app/chat/stream",
        data: formData,
        options: Options(
          responseType: ResponseType.stream,
          receiveTimeout: const Duration(seconds: 200),
          sendTimeout: const Duration(seconds: 200),
          followRedirects: false, // ❌ Disable automatic redirects
          validateStatus: (status) => status != null && status < 500,
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'audio/mpeg',
          },
        ),
      );

      // ✅ **Handle 307 Redirect Manually**
      if (response.statusCode == 307) {
        final redirectUrl = response.headers['location']?.first;
        if (redirectUrl != null) {
          print("🔄 إعادة التوجيه إلى: $redirectUrl");

          // ✅ **Create a New FormData for Redirected Request**
          final newFormData = FormData.fromMap({
            "interaction_mode": "voice",
            "message": "",
            "voice_file": await MultipartFile.fromFile(
              file.absolute.path,
              filename: "audio.wav",
            ),
            "language": "ar-AR"
          });

          final redirectedResponse = await _dio.post(
            redirectUrl,
            data: newFormData,
            options: Options(
              responseType: ResponseType.stream,
              receiveTimeout: const Duration(seconds: 200),
              sendTimeout: const Duration(seconds: 200),
              headers: {
                'Content-Type': 'multipart/form-data',
                'Accept': 'audio/mpeg',
              },
            ),
          );

          Uint8List audioData = await handleAudioStream(redirectedResponse);
          await playAudioFromBytes(audioData);
          return;
        } else {
          throw Exception("🚨 لا يوجد عنوان إعادة توجيه في `Location` header!");
        }
      }

      Uint8List audioData = await handleAudioStream(response);
      await playAudioFromBytes(audioData);
    } catch (e) {
      print("❌ خطأ أثناء إرسال الصوت: $e");
      throw ApiErrorModel(message: "Failed to send audio: $e");
    }
  }

// ✅ **Function to Process the Response**
// ✅ **Function to Extract Audio Data (Uint8List)**
  Future<Uint8List> handleAudioStream(Response response) async {
    if (response.statusCode == 200) {
      print("✅ استلام الرد الصوتي بنجاح.");

      ResponseBody? stream;
      if (response.data is ResponseBody) {
        stream = response.data as ResponseBody;
      } else {
        print(
            "🚨 Response body is not a ResponseBody, cannot process audio stream");
        throw ApiErrorModel(message: "Unexpected response body type");
      }

      List<int> audioBuffer = [];
      await for (var chunk in stream.stream) {
        print("🔹 استقبال جزء جديد من الصوت (${chunk.length} bytes)...");
        audioBuffer.addAll(chunk);
      }

      Uint8List fullAudioData = Uint8List.fromList(audioBuffer);
      print("✅ تم استقبال الصوت بالكامل (${fullAudioData.length} bytes)");

      return fullAudioData;
    } else {
      print(
          "⚠️ استجابة غير متوقعة من الخادم: ${response.statusCode} - ${response.statusMessage}");
      throw ApiErrorModel(
          message: "Unexpected status code: ${response.statusCode}");
    }
  }

  Future<void> playAudioFromBytes(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/response.mp3");
    await file.writeAsBytes(bytes);

    print("🎵 تشغيل الملف الصوتي بالكامل الآن...");
    await _player.setFilePath(file.path);
    await _player.play();
  }
}

class StreamResponse {
  final Stream<String> stream;
  final Map<String, String> headers;

  StreamResponse({required this.stream, required this.headers});
}

class StreamResponse2 {
  final Stream<Uint8List> stream; // ✅ استخدم Uint8List بدلاً من String
  final Map<String, String> headers;

  StreamResponse2({required this.stream, required this.headers});
}

class ByteArrayAudioSource extends StreamAudioSource {
  final Uint8List _audioBytes;

  ByteArrayAudioSource(this._audioBytes) : super(tag: 'MyAudioSource');

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    // Optionally provide chunk information
    start = start ?? 0;
    end = end ?? _audioBytes.length;
    return StreamAudioResponse(
      sourceLength: _audioBytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_audioBytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
