import '../core/models/indicators/roc_data_model.dart';

class RocIndicator {

  static RocDataModel calculate({
    required List<double> values,
    required int rocPeriod,
    required int maPeriod,
  }) {

    final roc =
    List<double?>.filled(
      values.length,
      null,
    );

    final maRoc =
    List<double?>.filled(
      values.length,
      null,
    );

    /// ROC
    for (
    int i = rocPeriod;
    i < values.length;
    i++
    ) {

      final previous =
      values[i - rocPeriod];

      if (previous == 0) {
        continue;
      }

      roc[i] =
          ((values[i] - previous) /
              previous) *
              100;
    }

    /// MA ROC
    for (
    int i = 0;
    i < values.length;
    i++
    ) {

      if (
      i <
          rocPeriod +
              maPeriod -
              1
      ) {
        continue;
      }

      double sum = 0;

      int count = 0;

      for (
      int j = i - maPeriod + 1;
      j <= i;
      j++
      ) {

        final value =
        roc[j];

        if (value == null) {
          continue;
        }

        sum += value;

        count++;
      }

      if (count == maPeriod) {

        maRoc[i] =
            sum / maPeriod;
      }
    }

    return RocDataModel(
      roc: roc,
      maRoc: maRoc,
    );
  }
}