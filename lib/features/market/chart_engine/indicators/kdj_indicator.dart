import '../core/models/candle_model.dart';
import '../core/models/indicators/kdj_data_model.dart';

class KdjIndicator {

  static KdjDataModel calculate({
    required List<CandleModel> candles,
    required int period,
    required int ma1,
    required int ma2,
  }) {

    final k =
    List<double?>.filled(
      candles.length,
      null,
    );

    final d =
    List<double?>.filled(
      candles.length,
      null,
    );

    final j =
    List<double?>.filled(
      candles.length,
      null,
    );

    double prevK = 50;

    double prevD = 50;

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
      int x = i - period + 1;
      x <= i;
      x++
      ) {

        if (
        candles[x].high >
            highestHigh
        ) {

          highestHigh =
              candles[x].high;
        }

        if (
        candles[x].low <
            lowestLow
        ) {

          lowestLow =
              candles[x].low;
        }
      }

      final range =
          highestHigh -
              lowestLow;

      double rsv = 0;

      if (range != 0) {

        rsv =
            ((candles[i].close -
                lowestLow) /
                range) *
                100;
      }

      final currentK =
          ((ma1 - 1) *
              prevK +
              rsv) /
              ma1;

      final currentD =
          ((ma2 - 1) *
              prevD +
              currentK) /
              ma2;

      final currentJ =
          (3 * currentK) -
              (2 * currentD);

      k[i] = currentK;

      d[i] = currentD;

      j[i] = currentJ;

      prevK = currentK;

      prevD = currentD;
    }

    return KdjDataModel(
      k: k,
      d: d,
      j: j,
    );
  }
}