import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/indicators/wr_data_model.dart';
import '../../../indicators/wr_indicator.dart';
import '../../candle_provider.dart';
import 'wr_provider.dart';

final wrDataProvider =
Provider<WrDataModel>((ref) {

  final candlesAsync =
  ref.watch(candleProvider);

  final settings =
  ref.watch(wrProvider);

  final candles =
      candlesAsync.value;

  if (
  candles == null ||
      candles.isEmpty
  ) {

    return const WrDataModel(
      values: [],
    );
  }

  return WrIndicator.calculate(
    candles: candles,
    period: settings.period,
  );
});