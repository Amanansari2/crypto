import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/roc_data_model.dart';
import '../../../indicators/roc_indicator.dart';
import '../../candle_provider.dart';
import 'roc_provider.dart';

final rocDataProvider =
Provider<RocDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(rocProvider);

  final candles =
      candlesAsync.value;

  if (
  candles == null ||
      candles.isEmpty
  ) {

    return const RocDataModel(
      roc: [],
      maRoc: [],
    );
  }

  final closes =
  candles
      .map((e) => e.close)
      .toList();

  return RocIndicator.calculate(
    values: closes,

    rocPeriod:
    settings.rocPeriod,

    maPeriod:
    settings.maPeriod,
  );
});