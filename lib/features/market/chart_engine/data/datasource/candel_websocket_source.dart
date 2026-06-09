import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../core/models/candle_model.dart';

class CandleWebsocketSource {

  WebSocketChannel? _channel;

  final _controller =
  StreamController<CandleModel>
      .broadcast();

  Stream<CandleModel>
  get stream =>
      _controller.stream;

  bool _disposed = false;

  String? _symbol;

  String? _interval;
  bool _reconnecting = false;

  StreamSubscription? _subscription;

  Timer? _reconnectTimer;

  bool _manuallyDisconnected = false;

  /// CONNECT
  void connect({
    required String symbol,
    required String interval,
  }) {

    _symbol = symbol;
    _interval = interval;

    /// reconnect ke time allow karo
    _manuallyDisconnected = false;

    /// old connection cleanup
    _reconnectTimer?.cancel();

    _subscription?.cancel();

    _channel?.sink.close();

    _subscription = null;
    _channel = null;

    if (_disposed) {
      return;
    }

    try {

      final url =
          'wss://stream.binance.com:9443/ws/'
          '${symbol.toLowerCase()}@kline_$interval';

      _channel = WebSocketChannel.connect(
        Uri.parse(url),
      );

      _subscription =
          _channel!.stream.listen(

                (event) {

              if (_disposed) {
                return;
              }

              final data =
              jsonDecode(event);

              final k =
              data['k'];

              final candle =
              CandleModel(

                time:
                DateTime.fromMillisecondsSinceEpoch(
                  k['t'],
                ),

                open:
                double.parse(k['o']),

                high:
                double.parse(k['h']),

                low:
                double.parse(k['l']),

                close:
                double.parse(k['c']),

                volume:
                double.parse(k['v']),
              );

              if (!_controller.isClosed) {
                _controller.add(
                  candle,
                );
              }
            },

            onError: (error) {

              if (_disposed ||
                  _manuallyDisconnected) {
                return;
              }

              reconnect();
            },

            onDone: () {

              if (_disposed ||
                  _manuallyDisconnected) {
                return;
              }

              reconnect();
            },

            cancelOnError: true,
          );

    } catch (_) {

      if (_disposed ||
          _manuallyDisconnected) {
        return;
      }

      reconnect();
    }
  }

  /// RECONNECT
  void reconnect() {

    if (_disposed) {
      return;
    }

    if (_manuallyDisconnected) {
      return;
    }

    if (_reconnecting) {
      return;
    }

    if (_symbol == null ||
        _interval == null) {
      return;
    }

    _reconnecting = true;

    _reconnectTimer?.cancel();

    _reconnectTimer = Timer(
      const Duration(seconds: 2),
          () {

        _reconnecting = false;

        if (_disposed ||
            _manuallyDisconnected) {
          return;
        }

        connect(
          symbol: _symbol!,
          interval: _interval!,
        );
      },
    );
  }

  /// DISCONNECT
  void disconnect(
  {  bool manual = true,}
      ) {

    _manuallyDisconnected = manual;
    _reconnecting = false;

    _reconnectTimer?.cancel();

    _subscription?.cancel();

    _channel?.sink.close();

    _subscription = null;

    _channel = null;
  }
  /// DISPOSE
  void dispose() {

    _disposed = true;
    _reconnecting = false;

    _reconnectTimer?.cancel();

    _subscription?.cancel();

    _channel?.sink.close();

    _controller.close();
    _subscription = null;
    _channel = null;
  }
}