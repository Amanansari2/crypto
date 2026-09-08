import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/binance/binance_ticker_model.dart';
import '../../data/repositories/ticker_repository.dart';

final tickerProvider =
StreamNotifierProvider.autoDispose.family<TickerNotifier, BinanceTickerModel, String>(
  TickerNotifier.new,
);

class TickerNotifier extends StreamNotifier<BinanceTickerModel> {
  final String symbol;

  TickerNotifier(this.symbol);

  final TickerRepository _repository = TickerRepository();

  @override
  Stream<BinanceTickerModel> build() {
    ref.onDispose(() {
      _repository.unsubscribe(symbol);
    });

    return _repository.ticker(symbol);
  }
}