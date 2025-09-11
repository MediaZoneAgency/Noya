// lib/feature/chat/data/repo/websocket_chat.dart

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:broker/core/helpers/cash_helper.dart'; // تأكد من صحة هذا المسار
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _controller =
      StreamController.broadcast();
  Stream<Map<String, dynamic>> get stream =>
      _controller.stream; // ✅ والـ stream أيضاً

  final StringBuffer _buffer = StringBuffer(); // لتجميع البيانات المستلمة
  bool _isConnecting = false;
  bool _connected = false;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  // دالة الاتصال الرئيسية
  Future<void> connect() async {
    if (_isConnecting || _connected) return;
    _isConnecting = true;
    _buffer.clear(); // نظف المخزن المؤقت عند كل محاولة اتصال

    try {
      final userId = await CashHelper.getStringSecured(key: Keys.id);
      // **الإصلاح رقم 1: التحقق من وجود user_id**
      if (userId == null) {
        throw Exception("User ID is null. Cannot connect to WebSocket.");
      }

      final uri =
          Uri.parse('wss://real-estate-chatbot-4lmcjvi3xq-ww.a.run.app/ws/')
              .replace(queryParameters: {'user_id': userId});

      print("🌐 Connecting to WebSocket: $uri");
      _channel = WebSocketChannel.connect(uri);

      _connected = true; // افترض الاتصال لمنع محاولات متعددة
      _isConnecting = false;
      _reconnectAttempts = 0;
      // _startPing();

      _channel!.stream.listen(
        (data) {
          // =============================================================
          // ✅✅✅ الإصلاح النهائي المستوحى من ملاحظتك
          // =============================================================
          Uint8List bytes;

          // الخطوة 1: ضمان أننا نتعامل مع بايتات خام (Uint8List)
          if (data is String) {
            // إذا وصلت كـ String، فهذا يعني أنها غالباً ASCII.
            // الطريقة الآمنة هي تحويلها إلى بايتات UTF-8.
            bytes = utf8.encode(data);
          } else if (data is Uint8List) {
            // إذا كانت بالفعل بايتات، استخدمها مباشرة.
            bytes = data;
          } else if (data is List<int>) {
            // حالة احتياطية إذا كانت List<int> وليست Uint8List
            bytes = Uint8List.fromList(data);
          } else {
            // إذا كان نوعاً غير متوقع، تجاهله
            print("⚠️ Received unexpected data type: ${data.runtimeType}");
            return;
          }

          // الخطوة 2: فك ترميز البايتات دائماً باستخدام utf8.decode
          try {
            final decodedString = utf8.decode(bytes);
            _buffer.write(decodedString);
            _processBufferedMessages();
          } catch (e) {
            // هذا الخطأ قد يحدث إذا كانت البايتات غير مكتملة (جزء من حرف)
            print(
                "🔥 UTF-8 decoding error, likely due to incomplete data chunk: $e");
          }
          // =============================================================
        },
        onError: _handleError,
        onDone: _handleDisconnect,
        cancelOnError: true,
      );
    } catch (e) {
      _isConnecting = false;
      print("❌ WebSocket connection failed: $e");
      _handleError(e); // استخدم المعالج الموحد للأخطاء
    }
  }

  // دالة فصل الرسائل المدمجة
  void _processBufferedMessages() {
    String data = _buffer.toString();
    int braceCounter = 0;
    int startIndex = -1;

    for (int i = 0; i < data.length; i++) {
      if (data[i] == '{') {
        if (braceCounter == 0) {
          startIndex = i; // حدد بداية كائن JSON جديد
        }
        braceCounter++;
      } else if (data[i] == '}') {
        if (braceCounter > 0) {
          braceCounter--;
          if (braceCounter == 0 && startIndex != -1) {
            // وجدنا كائن JSON مكتمل من البداية للنهاية
            final jsonMessage = data.substring(startIndex, i + 1);
            _handleSingleMessage(jsonMessage);

            // أعد تعيين الحالة للبحث عن الكائن التالي
            startIndex = -1;
          }
        }
      }
    }

    // بعد انتهاء الحلقة، احتفظ بما تبقى في المخزن المؤقت
    if (startIndex != -1) {
      // إذا كان هناك بداية ولم تكتمل، احتفظ بها
      _buffer.clear();
      _buffer.write(data.substring(startIndex));
    } else {
      // إذا تم تحليل كل شيء، نظف المخزن
      _buffer.clear();
    }
  }

  // دالة التعامل مع رسالة JSON واحدة
  void _handleSingleMessage(String jsonString) {
    try {
      // الخطوة 1: فك ترميز الـ String إلى Map
      final Map<String, dynamic> dataMap = jsonDecode(jsonString);

      // الخطوة 2: استخراج الرسالة النصية المفهومة للطباعة
      final readableMessage = dataMap['message'];
      print(
          "📩 Handling DECODED message: $readableMessage"); // <<< الآن ستطبع النص العربي

      // الخطوة 3: أضف الـ Map الكامل إلى الـ stream
      _controller.add(dataMap);
    } catch (e) {
      print("⚠️ Discarding invalid JSON fragment: $jsonString. Error: $e");
    }
  }

  // إرسال رسالة (يجب أن تكون نصاً)
  Future<void> sendMessage(String message) async {
    if (!_connected || _channel == null) {
      print('⚠️ Not connected, attempting to send message failed.');
      throw Exception('WebSocket not connected.');
    }
    // إذا كنت تريد إرسال JSON، قم بالترميز هنا
    // final payload = jsonEncode({'message': message});
    _channel!.sink.add(message);
    print(message);
  }

  // --- دوال إدارة الاتصال وإعادة الاتصال ---

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_connected && _channel != null) {
        sendMessage(jsonEncode({'type': 'ping'}));
        print("fuck");
      }
    });
  }

  void _handleError(dynamic error) {
    if (!_connected) return; // تجنب معالجة أخطاء متعددة
    print("❌ WebSocket Error: $error");
    _connected = false;
    _pingTimer?.cancel();
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    if (!_connected) return;
    print("🔌 WebSocket Disconnected.");
    _connected = false;
    _pingTimer?.cancel();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= 5) {
      print("⛔ Max reconnect attempts reached. Stopping.");
      return;
    }
    _reconnectAttempts++;
    final delay = Duration(seconds: 2 * _reconnectAttempts);
    print(
        "🔄 Reconnecting in ${delay.inSeconds} seconds... (Attempt $_reconnectAttempts)");
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  // --- التنظيف ---

  void dispose() {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
    _controller.close();
    print(" WebSocketService disposed.");
  }
}
