import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:web_socket_channel/web_socket_channel.dart';

class TradingBackendSocketService {
  static final TradingBackendSocketService _instance =
  TradingBackendSocketService._internal();

  factory TradingBackendSocketService() => _instance;

  TradingBackendSocketService._internal();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  final StreamController<Map<String, dynamic>> _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages =>
      _messageController.stream;

  bool get isConnected => _channel != null;

  void connect() {
    if (_channel != null) {
      return;
    }

    const url = "ws://192.168.1.72:5001/ws/trading";

    LogHelper.log("🔌 Connecting to backend WebSocket");
    LogHelper.log("🌐 URL: $url");

    try {
      final channel =
      WebSocketChannel.connect(Uri.parse(url));

      _channel = channel;


      _subscription = channel.stream.listen(
            (event) {
          try {
            final data =
            jsonDecode(event as String);

            LogHelper.log(
              "📥 BACKEND WS: $data",
            );

            if (data is Map<String, dynamic>) {
              _messageController.add(data);
            }
          } catch (e) {
            LogHelper.log(
              "❌ Backend WS JSON error: $e",
            );
          }
        },
        onError: (error) {
          LogHelper.log(
            "❌ Backend WS error: $error",
          );

          _cleanup();
        },
        onDone: () {
          LogHelper.log(
            "⚠️ Backend WS disconnected",
          );

          _cleanup();
        },
        cancelOnError: false,
      );
    } catch (e) {
      LogHelper.log(
        "❌ Backend WS connection failed: $e",
      );

      _cleanup();
    }
  }

  void send(Map<String, dynamic> message) {
    if (_channel == null) {
      LogHelper.log(
        "⚠️ Cannot send. Backend WS not connected.",
      );
      return;
    }

    final encoded = jsonEncode(message);

    LogHelper.log(
      "📤 BACKEND WS: $encoded",
    );

    _channel!.sink.add(encoded);
  }

  void subscribeSymbol(String symbol) {
    connect();

    send({
      "type": "SUBSCRIBE_SYMBOL",
      "symbol": symbol.toUpperCase(),
    });
  }

  void unsubscribeSymbol(String symbol) {
    send({
      "type": "UNSUBSCRIBE_SYMBOL",
      "symbol": symbol.toUpperCase(),
    });
  }

  void subscribeSharedMarketData(String symbol) {
    connect();

    send({
      "type": "SUBSCRIBE_SHARED_MARKET_DATA",
      "symbol": symbol.toUpperCase(),
    });
  }

  void unsubscribeSharedMarketData(String symbol) {
    send({
      "type": "UNSUBSCRIBE_SHARED_MARKET_DATA",
      "symbol": symbol.toUpperCase(),
    });
  }

  void subscribeOrderBook(String symbol) {
    connect();

    send({
      "type": "SUBSCRIBE_ORDER_BOOK",
      "symbol": symbol.toUpperCase(),
    });
  }

  void unsubscribeOrderBook(String symbol) {
    send({
      "type": "UNSUBSCRIBE_ORDER_BOOK",
      "symbol": symbol.toUpperCase(),
    });
  }

  void disconnect() {
    LogHelper.log(
      "🔌 Disconnecting backend WebSocket",
    );

    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close();
    _channel = null;
  }

  void _cleanup() {
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}