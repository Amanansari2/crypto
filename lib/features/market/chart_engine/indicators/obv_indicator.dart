import '../core/models/candle_model.dart';
import '../core/models/indicators/obv_data_model.dart';

class ObvIndicator {

  static ObvDataModel calculate({
    required List<CandleModel> candles,
    required int maPeriod,
  }) {

    final obv =
    List<double?>.filled(
      candles.length,
      null,
    );

    final maObv =
    List<double?>.filled(
      candles.length,
      null,
    );

    if (candles.isEmpty) {

      return ObvDataModel(
        obv: obv,
        maObv: maObv,
      );
    }

    double currentObv = 0;

    obv[0] = currentObv;

    for (
    int i = 1;
    i < candles.length;
    i++
    ) {

      final current =
      candles[i];

      final previous =
      candles[i - 1];

      if (
      current.close >
          previous.close
      ) {

        currentObv +=
            current.volume;

      } else if (
      current.close <
          previous.close
      ) {

        currentObv -=
            current.volume;
      }

      obv[i] =
          currentObv;
    }

    /// MAOBV

    for (
    int i = maPeriod - 1;
    i < candles.length;
    i++
    ) {

      double sum = 0;

      for (
      int j = i - maPeriod + 1;
      j <= i;
      j++
      ) {

        final value =
        obv[j];

        if (value == null) {
          continue;
        }

        sum += value;
      }

      maObv[i] =
          sum / maPeriod;
    }

    return ObvDataModel(
      obv: obv,
      maObv: maObv,
    );
  }
}