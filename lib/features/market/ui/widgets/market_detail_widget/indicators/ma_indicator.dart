List<double?> calculateMA(List candles, int period) {
  final List<double?> ma = [];

  for (int i = 0; i < candles.length; i++) {
    if (i < period - 1) {
      ma.add(null);
      continue;
    }

    double sum = 0;

    for (int j = 0; j < period; j++) {
      sum += candles[i - j].close;
    }

    ma.add(sum / period);
  }

  return ma;
}
