import '../core/models/indicators/stoch_rsi_data_model.dart';

class StochRsiIndicator {

  static StochRsiDataModel calculate({
    required List<double> closes,
    required int rsiLength,
    required int stochLength,
    required int smoothK,
    required int smoothD,
  }) {

    final rsi =
    List<double?>.filled(
      closes.length,
      null,
    );

    final k =
    List<double?>.filled(
      closes.length,
      null,
    );

    final d =
    List<double?>.filled(
      closes.length,
      null,
    );

    /// RSI

    double gain = 0;

    double loss = 0;

    for (
    int i = 1;
    i <= rsiLength;
    i++
    ) {

      final diff =
          closes[i] -
              closes[i - 1];

      if (diff > 0) {

        gain += diff;

      } else {

        loss += diff.abs();
      }
    }

    double avgGain =
        gain / rsiLength;

    double avgLoss =
        loss / rsiLength;

    if (avgLoss == 0) {

      rsi[rsiLength] = 100;

    } else {

      final rs =
          avgGain / avgLoss;

      rsi[rsiLength] =
          100 -
              (100 / (1 + rs));
    }

    for (
    int i = rsiLength + 1;
    i < closes.length;
    i++
    ) {

      final diff =
          closes[i] -
              closes[i - 1];

      double currentGain = 0;

      double currentLoss = 0;

      if (diff > 0) {

        currentGain = diff;

      } else {

        currentLoss =
            diff.abs();
      }

      avgGain =
          ((avgGain *
              (rsiLength - 1)) +
              currentGain) /
              rsiLength;

      avgLoss =
          ((avgLoss *
              (rsiLength - 1)) +
              currentLoss) /
              rsiLength;

      if (avgLoss == 0) {

        rsi[i] = 100;

      } else {

        final rs =
            avgGain /
                avgLoss;

        rsi[i] =
            100 -
                (100 /
                    (1 + rs));
      }
    }

    /// STOCH RSI

    final rawK =
    List<double?>.filled(
      closes.length,
      null,
    );

    for (
    int i = rsiLength + stochLength - 1;
    i < closes.length;
    i++
    ) {

      double highest =
          double.negativeInfinity;

      double lowest =
          double.infinity;

      for (
      int j = i - stochLength + 1;
      j <= i;
      j++
      ) {

        final value =
        rsi[j];

        if (value == null) {
          continue;
        }

        if (value > highest) {
          highest = value;
        }

        if (value < lowest) {
          lowest = value;
        }
      }

      final current =
      rsi[i];

      if (
      current == null ||
          highest == lowest
      ) {
        continue;
      }

      rawK[i] =
          ((current - lowest) /
              (highest - lowest)) *
              100;
    }

    /// Smooth K

    for (
    int i = 0;
    i < closes.length;
    i++
    ) {

      if (
      i <
          rsiLength +
              stochLength +
              smoothK -
              2
      ) {
        continue;
      }

      double sum = 0;

      int count = 0;

      for (
      int j = i - smoothK + 1;
      j <= i;
      j++
      ) {

        final value =
        rawK[j];

        if (value == null) {
          continue;
        }

        sum += value;

        count++;
      }

      if (count == smoothK) {

        k[i] =
            sum / smoothK;
      }
    }

    /// Smooth D

    for (
    int i = 0;
    i < closes.length;
    i++
    ) {

      if (
      i <
          rsiLength +
              stochLength +
              smoothK +
              smoothD -
              3
      ) {
        continue;
      }

      double sum = 0;

      int count = 0;

      for (
      int j = i - smoothD + 1;
      j <= i;
      j++
      ) {

        final value =
        k[j];

        if (value == null) {
          continue;
        }

        sum += value;

        count++;
      }

      if (count == smoothD) {

        d[i] =
            sum / smoothD;
      }
    }

    return StochRsiDataModel(
      k: k,
      d: d,
    );
  }
}