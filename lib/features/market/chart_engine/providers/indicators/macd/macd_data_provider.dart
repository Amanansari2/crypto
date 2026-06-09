import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/macd_data_model.dart';
import '../../../indicators/macd_indicator.dart';
import '../../candle_provider.dart';
import 'macd_provider.dart';

final macdDataProvider =
Provider<MacdDataModel>(
      (ref) {

    final candlesAsync =
    ref.watch(candleProvider);

    final settings =
    ref.watch(macdProvider);

    final candles =
        candlesAsync.value ?? [];

    final result =
    MacdIndicator.calculate(
      candles: candles,
      fastPeriod:
      settings.fastPeriod,
      slowPeriod:
      settings.slowPeriod,
      signalPeriod:
      settings.signalPeriod,
    );

    return MacdDataModel(
      macd: result.macd,
      signal: result.signal,
      histogram: result.histogram,
    );
  },
);