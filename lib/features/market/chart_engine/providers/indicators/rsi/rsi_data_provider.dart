import 'package:crypto_app/features/market/chart_engine/providers/indicators/rsi/rsi_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/rsi_data_model.dart';
import '../../../indicators/rsi_indicator.dart';
import '../../candle_provider.dart';
final rsiDataProvider =
Provider<RsiDataModel>(
      (ref) {

    final candlesAsync =
    ref.watch(candleProvider);

    final settings =
    ref.watch(rsiProvider);

    final candles =
        candlesAsync.value ?? [];

    final values =
    <int, List<double?>>{};

    for (final config in settings) {

      if (!config.enabled) {
        continue;
      }

      values[config.period] =
          RsiIndicator.calculate(
            candles: candles,
            period: config.period,
          );
    }

    return RsiDataModel(
      values: values,
    );
  },
);