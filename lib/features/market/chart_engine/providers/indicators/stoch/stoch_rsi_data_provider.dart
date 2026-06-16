import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/stoch_rsi_data_model.dart';
import '../../../indicators/stoch_rsi_indicator.dart';
import '../../candle_provider.dart';
import 'stoch_rsi_provider.dart';

final stochRsiDataProvider =
Provider<StochRsiDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(stochRsiProvider);

  final candles =
      candlesAsync.value;

  if (
  candles == null ||
      candles.isEmpty
  ) {

    return const StochRsiDataModel(
      k: [],
      d: [],
    );
  }

  final closes =
  candles
      .map((e) => e.close)
      .toList();

  return StochRsiIndicator.calculate(
    closes: closes,

    rsiLength:
    settings.rsiLength,

    stochLength:
    settings.stochLength,

    smoothK:
    settings.smoothK,

    smoothD:
    settings.smoothD,
  );
});