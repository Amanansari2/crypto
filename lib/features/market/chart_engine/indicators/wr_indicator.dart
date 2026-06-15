import '../core/models/candle_model.dart';
import '../core/models/indicators/wr_data_model.dart';

class WrIndicator {

  static WrDataModel calculate({
    required List<CandleModel> candles,
    required int period,
  }) {

    final values =
    List<double?>.filled(
      candles.length,
      null,
    );

    if (candles.length < period) {
      return WrDataModel(
        values: values,
      );
    }

    for (
    int i = period - 1;
    i < candles.length;
    i++
    ) {

      double highestHigh =
          candles[i].high;

      double lowestLow =
          candles[i].low;

      for (
      int j = i - period + 1;
      j <= i;
      j++
      ) {

        if (
        candles[j].high >
            highestHigh
        ) {
          highestHigh =
              candles[j].high;
        }

        if (
        candles[j].low <
            lowestLow
        ) {
          lowestLow =
              candles[j].low;
        }
      }

      final range =
          highestHigh -
              lowestLow;

      if (range == 0) {
        continue;
      }

      values[i] =
          ((highestHigh -
              candles[i].close) /
              range) *
              -100;
    }

    return WrDataModel(
      values: values,
    );
  }
}