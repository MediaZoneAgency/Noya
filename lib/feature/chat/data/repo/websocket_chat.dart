import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<String> _controller = StreamController.broadcast();
  Stream<String> get stream => _controller.stream;

  bool _isConnecting = false;
  bool _connected = false;
  int _reconnectAttempts = 0;
  final int _maxReconnectAttempts = 5;
  Timer? _reconnectTimer;
  Timer? _pingTimer;

  String? _lastMessage;
  String? _sessionId;
String? get sessionId => _sessionId;
 // ✅ لحفظ آخر رسالة
Future<void> connect() async {
  if (_isConnecting || _connected) return;

  _isConnecting = true;

  try {
    final userId = "46";
    final uri = Uri.parse('wss://real-estate-chatbot-4lmcjvi3xq-uc.a.run.app/ws/')
        .replace(queryParameters: {'user_id': userId});

    print("🌐 Connecting to WebSocket: $uri");

    _channel = WebSocketChannel.connect(uri);
    _startPing();

   _channel!.stream.listen(
  (message) {
    print("📩 Received: $message");

    // ✅ نحاول نقرأ session_id من أول رسالة (أو أي رسالة تحتويه)
    // try {
    //   final decoded = jsonDecode(message);
    //   if (decoded is Map && decoded['session_id'] != null) {
    //     _sessionId = decoded['session_id'];
    //     print("🆔 Session ID from backend (assigned): $_sessionId");
    //   } else {
    //     print("🔍 No session_id in message");
    //   }
    // } catch (e) {
    //   print("⚠️ Could not decode JSON or extract session_id: $e");
    // }

    // print("📦 Current session_id state: $_sessionId");

    _handleMessage(message);
  },
  onError: (error) {
    _handleError(error);
  },
  onDone: () {
    _handleDisconnect();
  },
  cancelOnError: true,
);

    _connected = true;
    _isConnecting = false;
    _reconnectAttempts = 0;
  } catch (e, stack) {
    _isConnecting = false;
    print("❌ Connection failed: $e");
    print("📚 StackTrace: $stack");
    _scheduleReconnect();
    rethrow;
  }
}


void _startPing() {
    _pingTimer?.cancel();

    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_connected && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'ping'}));
          print('🏓 Sent ping');
        } catch (e) {
          print('❌ Ping failed: $e');
          _handleError(e);
        }
      }
    });
  }

void _handleMessage(dynamic message) {
  if (message is String) {
    print("📩 Received in _handleMessage: $message");

    if (!_isValidUtf16(message)) {
      print("⚠️ Skipping invalid UTF-16 message");
      return;
    }

    if (message == _lastMessage) {
      print("⚠️ Duplicate message ignored");
      return;
    }

    _lastMessage = message;

    try {
      final json = jsonDecode(message);
      if (json['type'] == 'pong') {
        print('🏓 Received pong');
        return;
      }

      if (json['session_id'] != null) {
        _sessionId = json['session_id'];
        print("✅ session_id inside JSON: $_sessionId");
      }

      _controller.add(message);
    } catch (e) {
      // لو الرسالة مش JSON
      print("❗ Could not decode JSON or extract session_id: $e");
      print("📦 Current session_id state: $_sessionId");

      // لو الرسالة طولها 36 (شكل UUID)
      if (message.length == 36 && _sessionId == null) {
        _sessionId = message;
        print("✅ Session ID detected from raw string: $_sessionId");
      }

      // مهما كان أضف الرسالة للتطبيق
      _controller.add(message);
    }

    print("📦 _sessionId after _handleMessage: $_sessionId");
  }
}

 bool _isValidUtf16(String input) {
    try {
      utf8.decode(utf8.encode(input));
      return true;
    } catch (_) {
      return false;
    }
  }

  void _handleError(dynamic error) {
    print("❌ WebSocket error: $error");
    _connected = false;
    _scheduleReconnect();
  }

  void _handleDisconnect() {
    print("🔌 WebSocket disconnected");
    _connected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) return;

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);

    print("⏳ Scheduling reconnect in ${delay.inSeconds} seconds...");

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (!_connected) {
        connect();
      }
    });
  }

  Future<void> sendMessage(String message) async {
    if (!_connected || _channel == null) {
      print('⚠️ Not connected, attempting to reconnect...');
      await connect();
      await Future.delayed(Duration(milliseconds: 500));
      if (!_connected) {
        throw Exception('Failed to send message - no connection');
      }
    }

    try {
      _channel!.sink.add(message);
      print('➡️ Sent: $message');
    } catch (e) {
      print('❌ Failed to send message: $e');
      _handleError(e);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    try {
      await _channel?.sink.close(status.normalClosure);
    } catch (e) {
      print('⚠️ Error while disconnecting: $e');
    } finally {
      _connected = false;
    }
  }

  void dispose() {
    disconnect();
    _controller.close();
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
  }
}
