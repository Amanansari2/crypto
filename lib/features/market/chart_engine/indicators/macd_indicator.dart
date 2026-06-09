import 'ema_indicator.dart';
import '../core/models/candle_model.dart';

class MacdResult {

  final List<double?> macd;

  final List<double?> signal;

  final List<double?> histogram;

  const MacdResult({
    required this.macd,
    required this.signal,
    required this.histogram,
  });
}

class MacdIndicator {

  static MacdResult calculate({
    required List<CandleModel> candles,
    required int fastPeriod,
    required int slowPeriod,
    required int signalPeriod,
  }) {

    if (candles.isEmpty) {

      return const MacdResult(
        macd: [],
        signal: [],
        histogram: [],
      );
    }

    final closes =
    candles
        .map((e) => e.close)
        .toList();

    final fastEma =
    EmaIndicator.calculate(
      values: closes,
      period: fastPeriod,
    );

    final slowEma =
    EmaIndicator.calculate(
      values: closes,
      period: slowPeriod,
    );

    final macd =
    List<double?>.filled(
      closes.length,
      null,
    );

    for (
    int i = 0;
    i < closes.length;
    i++
    ) {

      if (
      fastEma[i] == null ||
          slowEma[i] == null
      ) {
        continue;
      }

      macd[i] =
          fastEma[i]! -
              slowEma[i]!;
    }

    final macdValues =
    macd
        .map(
          (e) => e ?? 0,
    )
        .toList();

    final signal =
    EmaIndicator.calculate(
      values: macdValues,
      period: signalPeriod,
    );

    final histogram =
    List<double?>.filled(
      closes.length,
      null,
    );

    for (
    int i = 0;
    i < closes.length;
    i++
    ) {

      if (
      macd[i] == null ||
          signal[i] == null
      ) {
        continue;
      }

      histogram[i] =
          macd[i]! -
              signal[i]!;
    }

    return MacdResult(
      macd: macd,
      signal: signal,
      histogram: histogram,
    );
  }
}