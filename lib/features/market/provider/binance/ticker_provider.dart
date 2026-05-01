import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/socket/binance_socket_service.dart';
import '../../data/models/binance/binance_ticker_model.dart';

final tickerProvider =
    AsyncNotifierProvider.family<TickerNotifier, BinanceTickerModel, String>(
      TickerNotifier.new,
    );

class TickerNotifier extends AsyncNotifier<BinanceTickerModel> {
  late final BinanceSocketService _socket;

  final String symbol;

  TickerNotifier(this.symbol);

  @override
  FutureOr<BinanceTickerModel> build() async {
    _socket = BinanceSocketService();

    final completer = Completer<BinanceTickerModel>();

    Future.delayed(const Duration(seconds: 5), () {
      if (!completer.isCompleted) {
        completer.completeError("Ticker load timeout");
      }
    });

    DateTime? lastUpdate;

    _socket.connect(
      stream: "${symbol.toLowerCase()}@ticker",
      onData: (data) {
        final now = DateTime.now();

        if (lastUpdate != null &&
            now.difference(lastUpdate) < const Duration(milliseconds: 400)) {
          return;
        }
        final model = BinanceTickerModel.fromJson(data);

        if (!completer.isCompleted) {
          completer.complete(model);
        }

        state = AsyncData(model);
      },
    );

    ref.onDispose(() {
      _socket.disconnect();
    });

    return completer.future;
  }
}
