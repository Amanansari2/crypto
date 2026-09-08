// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as LogHelper;
//
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class TradingBackendSocketService {
//   static final TradingBackendSocketService _instance =
//   TradingBackendSocketService._internal();
//
//   factory TradingBackendSocketService() => _instance;
//
//   TradingBackendSocketService._internal();
//
//   WebSocketChannel? _channel;
//   StreamSubscription? _subscription;
//
//   final StreamController<Map<String, dynamic>> _messageController =
//   StreamController<Map<String, dynamic>>.broadcast();
//
//   Stream<Map<String, dynamic>> get messages =>
//       _messageController.stream;
//
//   bool get isConnected => _channel != null;
//
//   void connect() {
//     if (_channel != null) {
//       return;
//     }
//
//     const url = "ws://192.168.1.72:5001/ws/trading";
//
//     LogHelper.log("🔌 Connecting to backend WebSocket");
//     LogHelper.log("🌐 URL: $url");
//
//     try {
//       final channel =
//       WebSocketChannel.connect(Uri.parse(url));
//
//       _channel = channel;
//
//
//       _subscription = channel.stream.listen(
//             (event) {
//           try {
//             final data =
//             jsonDecode(event as String);
//
//             LogHelper.log(
//               "📥 BACKEND WS: $data",
//             );
//
//             if (data is Map<String, dynamic>) {
//               _messageController.add(data);
//             }
//           } catch (e) {
//             LogHelper.log(
//               "❌ Backend WS JSON error: $e",
//             );
//           }
//         },
//         onError: (error) {
//           LogHelper.log(
//             "❌ Backend WS error: $error",
//           );
//
//           _cleanup();
//         },
//         onDone: () {
//           LogHelper.log(
//             "⚠️ Backend WS disconnected",
//           );
//
//           _cleanup();
//         },
//         cancelOnError: false,
//       );
//     } catch (e) {
//       LogHelper.log(
//         "❌ Backend WS connection failed: $e",
//       );
//
//       _cleanup();
//     }
//   }
//
//   void send(Map<String, dynamic> message) {
//     if (_channel == null) {
//       LogHelper.log(
//         "⚠️ Cannot send. Backend WS not connected.",
//       );
//       return;
//     }
//
//     final encoded = jsonEncode(message);
//
//     LogHelper.log(
//       "📤 BACKEND WS: $encoded",
//     );
//
//     _channel!.sink.add(encoded);
//   }
//
//   void subscribeSymbol(String symbol) {
//     connect();
//
//     send({
//       "type": "SUBSCRIBE_SYMBOL",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void unsubscribeSymbol(String symbol) {
//     send({
//       "type": "UNSUBSCRIBE_SYMBOL",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void subscribeSharedMarketData(String symbol) {
//     connect();
//
//     send({
//       "type": "SUBSCRIBE_SHARED_MARKET_DATA",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void unsubscribeSharedMarketData(String symbol) {
//     send({
//       "type": "UNSUBSCRIBE_SHARED_MARKET_DATA",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void subscribeOrderBook(String symbol) {
//     connect();
//
//     send({
//       "type": "SUBSCRIBE_ORDER_BOOK",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void unsubscribeOrderBook(String symbol) {
//     send({
//       "type": "UNSUBSCRIBE_ORDER_BOOK",
//       "symbol": symbol.toUpperCase(),
//     });
//   }
//
//   void disconnect() {
//     LogHelper.log(
//       "🔌 Disconnecting backend WebSocket",
//     );
//
//     _subscription?.cancel();
//     _subscription = null;
//
//     _channel?.sink.close();
//     _channel = null;
//   }
//
//   void _cleanup() {
//     _subscription?.cancel();
//     _subscription = null;
//     _channel = null;
//   }
//
//   void dispose() {
//     disconnect();
//     _messageController.close();
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class TradingBackendSocketService
    with WidgetsBindingObserver {

  static final TradingBackendSocketService _instance =
  TradingBackendSocketService._internal();

  factory TradingBackendSocketService() => _instance;

  TradingBackendSocketService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  Timer? _reconnectTimer;

  bool _isAppInBackground = false;
  bool _manualDisconnect = false;

  final Set<String> _symbolSubscriptions = {};
  final Set<String> _sharedMarketDataSubscriptions = {};
  final Set<String> _orderBookSubscriptions = {};
  final Set<String> _tradeSubscriptions = {};

  final StreamController<Map<String, dynamic>>
  _messageController =
  StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages =>
      _messageController.stream;

  bool get isConnected => _channel != null;

  // =========================================================
  // CONNECT
  // =========================================================

  void connect() {
    if (_isAppInBackground) {
      return;
    }

    if (_channel != null) {
      return;
    }

    _manualDisconnect = false;

    const url =
        "ws://192.168.1.72:5001/ws/trading";

    LogHelper.log(
      "🔌 Connecting to backend WebSocket",
    );

    LogHelper.log(
      "🌐 URL: $url",
    );

    try {
      final channel =
      WebSocketChannel.connect(
        Uri.parse(url),
      );

      _channel = channel;

      _subscription =
          channel.stream.listen(
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

              _scheduleReconnect();
            },

            onDone: () {
              LogHelper.log(
                "⚠️ Backend WS disconnected",
              );

              _cleanup();

              _scheduleReconnect();
            },

            cancelOnError: false,
          );

      // Restore all subscriptions after reconnect.
      _restoreSubscriptions();

    } catch (e) {
      LogHelper.log(
        "❌ Backend WS connection failed: $e",
      );

      _cleanup();

      _scheduleReconnect();
    }
  }

  // =========================================================
  // SEND
  // =========================================================

  void send(
      Map<String, dynamic> message,
      ) {
    if (_channel == null) {
      LogHelper.log(
        "⚠️ Cannot send. Backend WS not connected.",
      );

      return;
    }

    final encoded =
    jsonEncode(message);

    LogHelper.log(
      "📤 BACKEND WS: $encoded",
    );

    _channel!.sink.add(encoded);
  }

  // =========================================================
  // SYMBOL
  // =========================================================

  void subscribeSymbol(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _symbolSubscriptions.add(
      normalized,
    );

    connect();

    if (_channel != null) {
      send({
        "type": "SUBSCRIBE_SYMBOL",
        "symbol": normalized,
      });
    }
  }

  void unsubscribeSymbol(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _symbolSubscriptions.remove(
      normalized,
    );

    send({
      "type": "UNSUBSCRIBE_SYMBOL",
      "symbol": normalized,
    });
  }

  // =========================================================
  // SHARED MARKET DATA
  // =========================================================

  void subscribeSharedMarketData(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _sharedMarketDataSubscriptions.add(
      normalized,
    );

    connect();

    if (_channel != null) {
      send({
        "type":
        "SUBSCRIBE_SHARED_MARKET_DATA",
        "symbol": normalized,
      });
    }
  }

  void unsubscribeSharedMarketData(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _sharedMarketDataSubscriptions.remove(
      normalized,
    );

    send({
      "type":
      "UNSUBSCRIBE_SHARED_MARKET_DATA",
      "symbol": normalized,
    });
  }

  // =========================================================
  // ORDER BOOK
  // =========================================================

  void subscribeOrderBook(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _orderBookSubscriptions.add(
      normalized,
    );

    connect();

    if (_channel != null) {
      send({
        "type": "SUBSCRIBE_ORDER_BOOK",
        "symbol": normalized,
      });
    }
  }

  void unsubscribeOrderBook(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _orderBookSubscriptions.remove(
      normalized,
    );

    send({
      "type":
      "UNSUBSCRIBE_ORDER_BOOK",
      "symbol": normalized,
    });
  }


  // =========================================================
// TRADES
// =========================================================

  void subscribeTrades(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _tradeSubscriptions.add(
      normalized,
    );

    connect();

    if (_channel != null) {
      send({
        "type": "SUBSCRIBE_TRADES",
        "symbol": normalized,
      });
    }
  }

  void unsubscribeTrades(
      String symbol,
      ) {
    final normalized =
    symbol.toUpperCase();

    _tradeSubscriptions.remove(
      normalized,
    );

    send({
      "type": "UNSUBSCRIBE_TRADES",
      "symbol": normalized,
    });
  }


  // =========================================================
  // RESTORE SUBSCRIPTIONS
  // =========================================================

  void _restoreSubscriptions() {
    if (_channel == null) {
      return;
    }

    LogHelper.log(
      "🔄 Restoring WebSocket subscriptions",
    );

    for (final symbol
    in _symbolSubscriptions) {
      send({
        "type": "SUBSCRIBE_SYMBOL",
        "symbol": symbol,
      });
    }

    for (final symbol
    in _sharedMarketDataSubscriptions) {
      send({
        "type":
        "SUBSCRIBE_SHARED_MARKET_DATA",
        "symbol": symbol,
      });
    }

    for (final symbol
    in _orderBookSubscriptions) {
      send({
        "type": "SUBSCRIBE_ORDER_BOOK",
        "symbol": symbol,
      });
    }

    for (final symbol
    in _tradeSubscriptions) {
      send({
        "type": "SUBSCRIBE_TRADES",
        "symbol": symbol,
      });
    }

  }

  // =========================================================
  // RECONNECT
  // =========================================================

  void _scheduleReconnect() {
    if (_isAppInBackground) {
      return;
    }

    if (_manualDisconnect) {
      return;
    }

    if (_reconnectTimer != null &&
        _reconnectTimer!.isActive) {
      return;
    }

    LogHelper.log(
      "⏳ Backend WS reconnect scheduled",
    );

    _reconnectTimer =
        Timer(
          const Duration(seconds: 2),
              () {
            _reconnectTimer = null;

            if (!_isAppInBackground &&
                !_manualDisconnect &&
                _channel == null) {
              LogHelper.log(
                "🔄 Reconnecting backend WebSocket",
              );

              connect();
            }
          },
        );
  }

  // =========================================================
  // APP LIFECYCLE
  // =========================================================

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state,
      ) {
    LogHelper.log(
      "📱 App lifecycle: $state",
    );

    if (state == AppLifecycleState.resumed) {
      _isAppInBackground = false;

      LogHelper.log(
        "🟢 App resumed",
      );

      if (_channel == null) {
        connect();
      }
    }

    if (state == AppLifecycleState.paused) {
      _isAppInBackground = true;

      LogHelper.log(
        "🔴 App paused",
      );

      _reconnectTimer?.cancel();
      _reconnectTimer = null;

      _cleanup();
    }

    if (state == AppLifecycleState.detached) {
      _isAppInBackground = true;

      _reconnectTimer?.cancel();
      _reconnectTimer = null;

      _cleanup();
    }
  }

  // =========================================================
  // CLEANUP
  // =========================================================

  void _cleanup() {
    _subscription?.cancel();
    _subscription = null;

    _channel = null;
  }

  // =========================================================
  // MANUAL DISCONNECT
  // =========================================================

  void disconnect() {
    LogHelper.log(
      "🔌 Disconnecting backend WebSocket",
    );

    _manualDisconnect = true;

    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _subscription?.cancel();
    _subscription = null;

    _channel?.sink.close();
    _channel = null;
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  void dispose() {
    disconnect();

    WidgetsBinding.instance.removeObserver(
      this,
    );

    _messageController.close();
  }
}