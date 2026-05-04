import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceSocketService {
  /// 🔥 Multiple sockets support
  final Map<String, WebSocketChannel> _channels = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final Set<String> _reconnectingStreams = {};

  /// 🔌 CONNECT
  void connect({
    required String stream,
    required Function(Map<String, dynamic>) onData,
    bool isFutures = false
  }) {
    /// already connected
    if (_channels[stream] != null) return;
    final baseUrl = isFutures
        ? "wss://fstream.binance.com/ws/"
        : "wss://stream.binance.com:9443/ws/";

    final url = "$baseUrl$stream";

    try {
      final channel = WebSocketChannel.connect(Uri.parse(url));

      _channels[stream] = channel;

      LogHelper.log("✅ Connected to $stream");

      LogHelper.log("🌐 URL: $baseUrl$stream");


      _subscriptions[stream] = channel.stream.listen(
            (event) {
          LogHelper.log("Raw Event: $event ");
          try {
            final data = jsonDecode(event);
            LogHelper.log("Parsed $data");
            onData(data);
          } catch (e) {
            LogHelper.log("⚠️ JSON parse error: $e");
          }
        },

        onError: (e) {
          LogHelper.log("❌ Socket error ($stream): $e");
          _reconnect(stream, onData, isFutures);
        },

        onDone: () {
          LogHelper.log("⚠️ Socket closed ($stream)");
          _reconnect(stream, onData, isFutures);
        },
      );
    } catch (e) {
      LogHelper.log("❌ Connection failed ($stream): $e");
    }
  }

  void _reconnect(String stream, Function(Map<String, dynamic>) onData,
      bool isFutures) {
    if (_reconnectingStreams.contains(stream)) return;

    _reconnectingStreams.add(stream);

    _cleanup(stream);

    Future.delayed(const Duration(seconds: 2), () {
      LogHelper.log("🔄 Reconnecting $stream...");
      _reconnectingStreams.remove(stream);
      connect(stream: stream, onData: onData, isFutures: isFutures);
    });
  }

  /// ❌ DISCONNECT (single stream)
  void disconnect(String stream) {
    _cleanup(stream);
    LogHelper.log("🔌 Disconnected $stream");
  }

  /// 🔥 CLEANUP helper
  void _cleanup(String stream) {
    _subscriptions[stream]?.cancel();
    _channels[stream]?.sink.close();

    _subscriptions.remove(stream);
    _channels.remove(stream);
  }

  /// ❌ optional: disconnect all
  void disconnectAll() {
    for (final stream in _channels.keys.toList()) {
      _cleanup(stream);
    }
    LogHelper.log("🔌 Disconnected all streams");
  }
}