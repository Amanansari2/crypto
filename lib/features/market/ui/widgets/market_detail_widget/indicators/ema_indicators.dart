List<double?> calculateEMA(List candles, int period) {
  final List<double?> ema = [];

  if (candles.isEmpty) {
    return ema;
  }

  final multiplier = 2 / (period + 1);

  double? previousEma;

  for (int i = 0; i < candles.length; i++) {
    final close = candles[i].close.toDouble();

    /// enough data nahi
    if (i < period - 1) {
      ema.add(null);
      continue;
    }

    /// first EMA = SMA
    if (i == period - 1) {
      double sum = 0;

      for (int j = 0; j < period; j++) {
        sum += candles[i - j].close;
      }

      previousEma = sum / period;

      ema.add(previousEma);

      continue;
    }

    /// EMA Formula
    previousEma = ((close - previousEma!) * multiplier) + previousEma;

    ema.add(previousEma);
  }

  return ema;
}
