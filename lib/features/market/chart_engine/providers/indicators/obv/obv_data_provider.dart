import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/obv_data_model.dart';
import '../../../indicators/obv_indicator.dart';
import '../../candle_provider.dart';
import 'obv_provider.dart';

final obvDataProvider =
Provider<ObvDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(obvProvider);

  final candles =
      candlesAsync.value;

  if (
  candles == null ||
      candles.isEmpty
  ) {

    return const ObvDataModel(
      obv: [],
      maObv: [],
    );
  }

  return ObvIndicator.calculate(
    candles: candles,

    maPeriod:
    settings.maPeriod,
  );
});