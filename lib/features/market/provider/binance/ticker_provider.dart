import 'dart:async';
import 'dart:developer' as LogHelper;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/socket/binance_socket_service.dart';
import '../../data/models/binance/binance_ticker_model.dart';

final tickerProvider =
StreamNotifierProvider.family<TickerNotifier, BinanceTickerModel, String>(
      TickerNotifier.new,
    );

class TickerNotifier extends StreamNotifier<BinanceTickerModel> {
  final String symbol;

  TickerNotifier(this.symbol);

  late BinanceSocketService _socket;

  @override
  Stream<BinanceTickerModel> build() {
    _socket = BinanceSocketService();

    final controller = StreamController<BinanceTickerModel>();

    LogHelper.log("🚀 TICKER STREAM STARTED");

    _socket.connect(
      stream: "${symbol.toLowerCase()}@ticker",
      onData: (data) {
        LogHelper.log("🔥 TICKER DATA: $data");

        final model = BinanceTickerModel.fromJson(data);

        controller.add(model);
      },
    );

    ref.onDispose(() {
      LogHelper.log("❌ TICKER DISPOSE");
      _socket.disconnect("${symbol.toLowerCase()}@ticker");
      controller.close();
    });

    return controller.stream;
  }
}

