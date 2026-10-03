import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../market/data/models/binance_ticker_model.dart';
import '../repositories/home_ticker_repository.dart';

final homeTickerProvider =
StreamNotifierProvider.autoDispose.family<
    HomeTickerNotifier,
    BinanceTickerModel,
    String>(
  HomeTickerNotifier.new,
);

class HomeTickerNotifier extends StreamNotifier<BinanceTickerModel> {
  final String symbol;

  HomeTickerNotifier(this.symbol);

  final HomeTickerRepository _repository =
  HomeTickerRepository();

  @override
  Stream<BinanceTickerModel> build() {
    ref.onDispose(() {
      _repository.unsubscribe(symbol);
    });

    return _repository.ticker(symbol);
  }
}