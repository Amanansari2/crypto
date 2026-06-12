class MaIndicator {

  static List<double?> calculate({
    required List<double> values,
    required int period,
  }) {

    final result =
    List<double?>.filled(
      values.length,
      null,
    );

    if (values.length < period) {
      return result;
    }

    for (
    int i = period - 1;
    i < values.length;
    i++
    ) {

      double sum = 0;

      for (
      int j = i - period + 1;
      j <= i;
      j++
      ) {
        sum += values[j];
      }

      result[i] =
          sum / period;
    }

    return result;
  }
}