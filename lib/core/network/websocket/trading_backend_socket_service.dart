

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as LogHelper;

import 'package:crypto_app/core/utils/constants/api_urls.dart';
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
  final Map<String, Set<String>> _positionPnlSubscriptions = {};
  final Map<String, Set<String>> _sharedMarketDataSubscriptions = {};
  final Map<String, Set<String>> _orderBookSubscriptions = {};
  final Set<String> _tradeSubscriptions = {};
  final Set<String> _klineSubscriptions = {};

  final StreamController<Map<String, dynamic>> _messageController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

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

    const url = ApiUrls.websocketUrl;

    LogHelper.log(
      "🔌 Connecting to backend WebSocket",
    );

    LogHelper.log("🌐 URL: $url",);

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
  // SHARED MARKET DATA
  // =========================================================


  void subscribeSharedMarketData(
      String symbol,
      String owner,
      ) {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedOwner = owner.toUpperCase();

    final owners = _sharedMarketDataSubscriptions.putIfAbsent(normalizedSymbol, () => <String>{},);

    final wasEmpty = owners.isEmpty;

    owners.add(normalizedOwner);

    connect();

    // Send to backend only when the first owner subscribes.
    if (wasEmpty && _channel != null) {
      send({
        "type": "SUBSCRIBE_SHARED_MARKET_DATA",
        "symbol": normalizedSymbol,
      });
    }
  }

  void unsubscribeSharedMarketData(
      String symbol,
      String owner,
      ) {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedOwner = owner.toUpperCase();

    final owners = _sharedMarketDataSubscriptions[normalizedSymbol];

    if (owners == null) {
      return;
    }

    owners.remove(normalizedOwner);

    // Other consumers still need this shared market data.
    if (owners.isNotEmpty) {
      return;
    }

    // No consumers remain.
    _sharedMarketDataSubscriptions.remove(normalizedSymbol);

    send({
      "type": "UNSUBSCRIBE_SHARED_MARKET_DATA",
      "symbol": normalizedSymbol,
    });
  }

  // =========================================================
  // ORDER BOOK
  // =========================================================



  void subscribeOrderBook(
      String symbol,
      String owner,
      ) {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedOwner = owner.toUpperCase();

    final owners = _orderBookSubscriptions.putIfAbsent(
      normalizedSymbol,
          () => <String>{},
    );

    final wasEmpty = owners.isEmpty;

    owners.add(normalizedOwner);

    connect();

    // Send to backend only when the first owner subscribes.
    if (wasEmpty && _channel != null) {
      send({
        "type": "SUBSCRIBE_ORDER_BOOK",
        "symbol": normalizedSymbol,
      });
    }
  }


  void unsubscribeOrderBook(
      String symbol,
      String owner,
      ) {
    final normalizedSymbol = symbol.toUpperCase();
    final normalizedOwner = owner.toUpperCase();

    final owners =
    _orderBookSubscriptions[normalizedSymbol];

    if (owners == null) {
      return;
    }

    owners.remove(normalizedOwner);

    // Other consumers still need this order book.
    if (owners.isNotEmpty) {
      return;
    }

    // No consumers remain.
    _orderBookSubscriptions.remove(normalizedSymbol);

    send({
      "type": "UNSUBSCRIBE_ORDER_BOOK",
      "symbol": normalizedSymbol,
    });
  }

  // =========================================================
// POSITION LIVE PNL
// =========================================================

  void subscribePositionPnl(String accountId , String owner) {
    final normalizedAccountId = accountId.trim();
    final normalizedOwner = owner.toUpperCase();

    if (normalizedAccountId.isEmpty || normalizedOwner.isEmpty) {
      return;
    }

    final owners = _positionPnlSubscriptions.putIfAbsent(normalizedAccountId, () => <String>{});

final wasEmpty = owners.isEmpty;
owners.add(normalizedOwner);
    connect();

    if (wasEmpty && _channel != null) {
      send({
        "type": "SUBSCRIBE_POSITION_PNL",
        "accountId": normalizedAccountId,
      });
    }
  }

  void unsubscribePositionPnl(String accountId, String owner) {
    final normalizedAccountId = accountId.trim();
    final normalizedOwner = owner.toUpperCase();

    if (normalizedAccountId.isEmpty || normalizedOwner.isEmpty) {
      return;
    }

final owners = _positionPnlSubscriptions[normalizedAccountId];
if(owners == null){
  return;
}
owners.remove(normalizedOwner);

if(owners.isNotEmpty){
  return;
}

_positionPnlSubscriptions.remove(normalizedAccountId);

    send({
      "type": "UNSUBSCRIBE_POSITION_PNL",
      "accountId": normalizedAccountId,
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
  // KLINES
  // =========================================================

  void subscribeKlines(
      String symbol,
      String interval,
      ) {
    final normalizedSymbol =
    symbol.toUpperCase();

    final normalizedInterval =
    interval.trim();

    final subscriptionKey =
        "$normalizedSymbol:$normalizedInterval";

    _klineSubscriptions.add(
      subscriptionKey,
    );

    connect();

    if (_channel != null) {
      send({
        "type": "SUBSCRIBE_KLINES",
        "symbol": normalizedSymbol,
        "interval": normalizedInterval,
      });
    }
  }

  void unsubscribeKlines(
      String symbol,
      String interval,
      ) {
    final normalizedSymbol =
    symbol.toUpperCase();

    final normalizedInterval =
    interval.trim();

    final subscriptionKey =
        "$normalizedSymbol:$normalizedInterval";

    _klineSubscriptions.remove(
      subscriptionKey,
    );

    send({
      "type": "UNSUBSCRIBE_KLINES",
      "symbol": normalizedSymbol,
      "interval": normalizedInterval,
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
    in _sharedMarketDataSubscriptions.keys) {
      send({
        "type":
        "SUBSCRIBE_SHARED_MARKET_DATA",
        "symbol": symbol,
      });
    }



    for (final symbol
    in _orderBookSubscriptions.keys) {
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

    for (final accountId in _positionPnlSubscriptions.keys) {
      send({
        "type": "SUBSCRIBE_POSITION_PNL",
        "accountId": accountId,
      });
    }

    for (final subscriptionKey
    in _klineSubscriptions) {

      final parts =
      subscriptionKey.split(":");

      if (parts.length != 2) {
        continue;
      }

      final symbol = parts[0];
      final interval = parts[1];

      send({
        "type": "SUBSCRIBE_KLINES",
        "symbol": symbol,
        "interval": interval,
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