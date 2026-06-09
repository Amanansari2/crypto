import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:web_socket_channel/web_socket_channel.dart';

class BinanceSocketService {
  /// 🔥 Multiple sockets support
  final Map<String, WebSocketChannel> _channels = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final Set<String> _reconnectingStreams = {};
  final Map<String, Timer> _reconnectTimers = {};
  final Set<String> _manuallyDisconnected = {};

  /// 🔌 CONNECT
  void connect({
    required String stream,
    required Function(Map<String, dynamic>) onData,
    bool isFutures = false
  }) {

    _manuallyDisconnected.remove(stream);
    _reconnectingStreams.remove(stream);

    /// already connected
    if (_channels[stream] != null) return;
    final baseUrl = isFutures
        ? "wss://fstream.binance.com/ws/"
        : "wss://stream.binance.com:9443/ws/";

    final url = "$baseUrl$stream";

    LogHelper.log(
      "STREAM => [$stream]",
    );

    LogHelper.log(
      "BASE URL => [$baseUrl]",
    );

    LogHelper.log(
      "FINAL URL => [$url]",
    );


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
          LogHelper.log(
            "❌ SOCKET ERROR: $e",
          );

          LogHelper.log(
            "❌ STREAM: [$stream]",
          );
          LogHelper.log("❌ Socket error ($stream): $e");
          _reconnect(stream, onData, isFutures);
        },
        cancelOnError: true,

        onDone: () {
          LogHelper.log("⚠️ Socket closed ($stream)");
          _reconnect(stream, onData, isFutures);
        },
      );
    } catch (e) {
      LogHelper.log("❌ Connection failed ($stream): $e");
    }
  }

  void _reconnect(
      String stream,
      Function(Map<String, dynamic>) onData,
      bool isFutures,
      ) {

    if (_manuallyDisconnected.contains(stream)) {
      return;
    }

    if (_reconnectingStreams.contains(stream)) {
      return;
    }

    _reconnectingStreams.add(stream);

    _cleanup(stream);

    _reconnectTimers[stream]?.cancel();

    _reconnectTimers[stream] = Timer(
      const Duration(seconds: 2),
          () {

        _reconnectingStreams.remove(stream);

        if (
        _manuallyDisconnected.contains(stream)
        ) {
          return;
        }

        LogHelper.log(
          "🔄 Reconnecting $stream...",
        );

        connect(
          stream: stream,
          onData: onData,
          isFutures: isFutures,
        );
      },
    );
  }

  /// ❌ DISCONNECT (single stream)
  void disconnect(String stream) {
    _manuallyDisconnected.add(stream);
    _reconnectTimers[stream]?.cancel();
    _cleanup(stream);
    LogHelper.log("🔌 Disconnected $stream");
  }

  /// 🔥 CLEANUP helper
  void _cleanup(String stream) {

    _subscriptions[stream]?.cancel();

    _channels[stream]?.sink.close();

    _subscriptions.remove(stream);

    _channels.remove(stream);

    _reconnectingStreams.remove(stream);
    _reconnectTimers[stream]?.cancel();
    _reconnectTimers.remove(stream);
  }

  /// ❌ optional: disconnect all
  void disconnectAll() {
    for (final stream in _channels.keys.toList()) {
      _manuallyDisconnected.add(stream);

      _reconnectTimers[stream]?.cancel();
      _cleanup(stream);
    }
    LogHelper.log("🔌 Disconnected all streams");
  }
}