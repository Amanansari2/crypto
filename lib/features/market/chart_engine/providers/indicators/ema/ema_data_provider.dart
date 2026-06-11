import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/ema_data_model.dart';
import '../../../indicators/ema_indicator.dart';
import '../../candle_provider.dart';
import 'ema_provider.dart';

final emaDataProvider = Provider<EmaDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(emaProvider);

  final candles =
      candlesAsync.value;

  if (candles == null ||
      candles.isEmpty) {

    return const EmaDataModel(
      values: {},
    );
  }

  final closes =
  candles
      .map((e) => e.close)
      .toList();

  final Map<int, List<double?>>
  values = {};

  for (final config in settings) {

    if (!config.enabled) {
      continue;
    }

    values[config.period] =
        EmaIndicator.calculate(
          values: closes,
          period: config.period,
        );
  }

  return EmaDataModel(
    values: values,
  );
});