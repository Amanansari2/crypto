class EmaIndicator {

  static List<double?> calculate({
    required List<double> values,
    required int period,
  }) {

    if (values.length < period) {
      return List.filled(
        values.length,
        null,
      );
    }

    final ema =
    List<double?>.filled(
      values.length,
      null,
    );

    double sma = 0;

    for (
    int i = 0;
    i < period;
    i++
    ) {
      sma += values[i];
    }

    sma /= period;

    ema[period - 1] = sma;

    final multiplier =
        2 / (period + 1);

    for (
    int i = period;
    i < values.length;
    i++
    ) {

      ema[i] =
          ((values[i] -
              ema[i - 1]!)
              * multiplier) +
              ema[i - 1]!;
    }

    return ema;
  }
}