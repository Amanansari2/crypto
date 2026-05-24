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

  /// CONNECT
  void connect({

    required String symbol,

    required String interval,
  }) {

    _symbol = symbol;

    _interval = interval;

    disconnect();

    final url =

        'wss://stream.binance.com:9443/ws/'
        '${symbol.toLowerCase()}@kline_$interval';

    _channel =
        WebSocketChannel.connect(
          Uri.parse(url),
        );

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
          DateTime
              .fromMillisecondsSinceEpoch(
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

        _controller.add(candle);
      },

      onError: (_) {
        reconnect();
      },

      onDone: () {
        reconnect();
      },
    );
  }

  /// RECONNECT
  void reconnect() {

    if (_disposed) {
      return;
    }

    if (
    _symbol == null ||
        _interval == null
    ) {

      return;
    }

    Future.delayed(
      const Duration(seconds: 2),

          () {

        if (_disposed) {
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
  void disconnect() {

    _channel?.sink.close();

    _channel = null;
  }

  /// DISPOSE
  void dispose() {

    _disposed = true;

    disconnect();

    _controller.close();
  }
}