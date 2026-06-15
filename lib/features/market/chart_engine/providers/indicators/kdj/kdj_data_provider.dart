import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/kdj_data_model.dart';
import '../../../indicators/kdj_indicator.dart';
import '../../candle_provider.dart';
import 'kdj_provider.dart';

final kdjDataProvider =
Provider<KdjDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(kdjProvider);

  final candles =
      candlesAsync.value;

  if (
  candles == null ||
      candles.isEmpty
  ) {

    return const KdjDataModel(
      k: [],
      d: [],
      j: [],
    );
  }

  return KdjIndicator.calculate(
    candles: candles,

    period:
    settings.period,

    ma1:
    settings.ma1,

    ma2:
    settings.ma2,
  );
});