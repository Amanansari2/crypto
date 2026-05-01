import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  bool _isConnected = false;
  String? _currentStream;

  StreamSubscription? _subscription;

  void connect({
    required String stream,
    required Function(Map<String, dynamic>) onData,
  }) {
    if (_isConnected && _currentStream == stream && _channel != null) return;
    _currentStream = stream;
    _connectInternal(onData);
  }

  void _connectInternal(Function(Map<String, dynamic>) onData) {
    if (_currentStream == null) return;
    _subscription?.cancel();
    _channel?.sink.close();

    final url = "wss://stream.binance.com:9443/ws/$_currentStream";

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _isConnected = true;

      LogHelper.log("✅ Connected to $_currentStream");

      _subscription = _channel!.stream.listen(
        (event) {
          try {
            final data = jsonDecode(event);
            onData(data);
          } catch (e) {
            LogHelper.log("⚠️ JSON parse error: $e");
          }
        },

        onError: (e) {
          _isConnected = false;
          LogHelper.log("❌ Socket error: $e");
          _handleReconnect(onData);
        },

        onDone: () {
          _isConnected = false;
          LogHelper.log("⚠️ Socket closed");
          _handleReconnect(onData);
        },
      );
    } catch (e) {
      _isConnected = false;
      LogHelper.log("❌ Connection failed: $e");
      _handleReconnect(onData);
    }
  }

  void _handleReconnect(Function(Map<String, dynamic>) onData) {
    if (_reconnectTimer != null || _currentStream == null) return;

    _reconnectTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      LogHelper.log("🔄 Reconnecting...");
      _connectInternal(onData);

      if (_isConnected) {
        timer.cancel();
        _reconnectTimer = null;
      }
    });
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close();
    _channel = null;

    _isConnected = false;

    LogHelper.log("🔌 Disconnected");
  }
}
