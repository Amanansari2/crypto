import '../core/models/candle_model.dart';

class RsiIndicator {
  static List<double?> calculate({
    required List<CandleModel> candles,
    required int period,
  }) {
    if (candles.length <= period) {
      return List.filled(candles.length, null,);
    }

    final rsi =
    List<double?>.filled(candles.length, null,);

    double gain = 0;
    double loss = 0;

    /// first average gain/loss
    for (int i = 1; i <= period; i++) {

      final change =
          candles[i].close - candles[i - 1].close;

      if (change > 0) {
        gain += change;
      } else {
        loss += change.abs();
      }
    }

    double avgGain = gain / period;

    double avgLoss = loss / period;

    if (avgLoss == 0) {
      rsi[period] = 100;
    } else {
      final rs = avgGain / avgLoss;
      rsi[period] = 100 - (100 / (1 + rs));
    }

    /// smoothed RSI
    for (
    int i = period + 1;
    i < candles.length;
    i++
    ) {

      final change =
          candles[i].close - candles[i - 1].close;

      final currentGain =
      change > 0
          ? change
          : 0;

      final currentLoss =
      change < 0
          ? change.abs()
          : 0;

      avgGain =
          ((avgGain * (period - 1))
              + currentGain)
              / period;

      avgLoss =
          ((avgLoss * (period - 1))
              + currentLoss)
              / period;

      if (avgLoss == 0) {

        rsi[i] = 100;

      } else {

        final rs =
            avgGain / avgLoss;

        rsi[i] =
            100 -
                (100 / (1 + rs));
      }
    }

    return rsi;
  }
}