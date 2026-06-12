import 'package:crypto_app/features/market/chart_engine/core/models/indicators/ma_data_model.dart';
import 'package:crypto_app/features/market/chart_engine/indicators/ma_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../candle_provider.dart';
import 'ma_provider.dart';

final maDataProvider = Provider<MaDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(maProvider);

  final candles =
      candlesAsync.value;

  if (candles == null ||
      candles.isEmpty) {

    return const MaDataModel(
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
        MaIndicator.calculate(
          values: closes,
          period: config.period,
        );
  }

  return MaDataModel(
    values: values,
  );
});