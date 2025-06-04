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

  Future<void> connect() async {
    if (_isConnecting || _connected) return;
    
    _isConnecting = true;
    
    try {
      final uri = Uri.parse('wss://real-estate-chatbot-4lmcjvi3xq-uc.a.run.app/ws/')
          .replace(queryParameters: {'user_id': '46'});

      print("🌐 Connecting to WebSocket: $uri");

      _channel = WebSocketChannel.connect(uri);

      // Start ping mechanism
      _startPing();

      _channel!.stream.listen(
        (message) => _handleMessage(message),
        onError: (error) => _handleError(error),
        onDone: () => _handleDisconnect(),
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
    // Cancel any existing ping timer
    _pingTimer?.cancel();
    
    // Send ping every 30 seconds to keep connection alive
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
      print("📩 Received: $message");
      
      try {
        final json = jsonDecode(message);
        // Handle ping response
        if (json['type'] == 'pong') {
          print('🏓 Received pong');
          return;
        }
        _controller.add(message);
      } catch (e) {
        // Handle non-JSON messages (like session ID)
        if (message.length == 36) {
          print("✅ Session confirmed: $message");
        } else {
          _controller.add(message);
        }
      }
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
      
      // Wait a bit for connection to establish
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