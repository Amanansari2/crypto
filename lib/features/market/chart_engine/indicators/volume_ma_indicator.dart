import '../core/models/candle_model.dart';

class VolumeMaIndicator {

  static List<double?> calculate({
    required List<CandleModel> candles,
    required int period,
  }) {

    final result =
    List<double?>.filled(
      candles.length,
      null,
    );

    if (candles.length < period) {
      return result;
    }

    double sum = 0;

    for (int i = 0; i < candles.length; i++) {

      sum += candles[i].volume;

      if (i >= period) {
        sum -= candles[
        i - period
        ].volume;
      }

      if (i >= period - 1) {
        result[i] =
            sum / period;
      }
    }

    return result;
  }
}