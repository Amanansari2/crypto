import 'dart:math' as math;
import '../core/models/indicators/boll_data_model.dart';

class BollIndicator {

  static BollDataModel calculate({
    required List<double> values,
    required int period,
    required double bandwidth,
  }) {

    final upper =
    List<double?>.filled(
      values.length,
      null,
    );

    final middle =
    List<double?>.filled(
      values.length,
      null,
    );

    final lower =
    List<double?>.filled(
      values.length,
      null,
    );

    if (values.length < period) {
      return BollDataModel(
        upper: upper,
        middle: middle,
        lower: lower,
      );
    }

    for (
    int i = period - 1;
    i < values.length;
    i++
    ) {

      final window =
      values.sublist(
        i - period + 1,
        i + 1,
      );

      final sma =
          window.reduce(
                (a, b) => a + b,
          ) /
              period;

      double variance = 0;

      for (final value in window) {
        variance +=
            (value - sma) *
                (value - sma);
      }

      variance /= period;

      final stdDev =
      math.sqrt(variance);

      middle[i] = sma;

      upper[i] =
          sma +
              (stdDev * bandwidth);

      lower[i] =
          sma -
              (stdDev * bandwidth);
    }

    return BollDataModel(
      upper: upper,
      middle: middle,
      lower: lower,
    );
  }
}