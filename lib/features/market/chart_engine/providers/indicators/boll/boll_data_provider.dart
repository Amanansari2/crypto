import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/boll_data_model.dart';
import '../../../indicators/boll_indicator.dart';
import '../../candle_provider.dart';
import 'boll_provider.dart';

final bollDataProvider =
Provider<BollDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(bollProvider);

  final candles =
      candlesAsync.value;

  if (candles == null ||
      candles.isEmpty) {

    return const BollDataModel(
      upper: [],
      middle: [],
      lower: [],
    );
  }

  final closes = candles
      .map((e) => e.close)
      .toList();

  return BollIndicator.calculate(
    values: closes,
    period: settings.period,
    bandwidth: settings.bandwidth,
  );
});