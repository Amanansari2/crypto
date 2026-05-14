List<double?> calculateRSI(List candles, int period) {
  if (candles.length < period + 1) {
    return List.filled(candles.length, null);
  }

  final rsi = List<double?>.filled(candles.length, null);

  double gain = 0;
  double loss = 0;

  for (int i = 1; i <= period; i++) {
    final diff = candles[i].close - candles[i - 1].close;

    if (diff >= 0) {
      gain += diff;
    } else {
      loss += diff.abs();
    }
  }

  double avgGain = gain / period;
  double avgLoss = loss / period;

  rsi[period] = 100 - (100 / (1 + (avgGain / avgLoss)));

  for (int i = period + 1; i < candles.length; i++) {
    final diff = candles[i].close - candles[i - 1].close;

    double currentGain = 0;
    double currentLoss = 0;

    if (diff >= 0) {
      currentGain = diff;
    } else {
      currentLoss = diff.abs();
    }

    avgGain = ((avgGain * (period - 1)) + currentGain) / period;

    avgLoss = ((avgLoss * (period - 1)) + currentLoss) / period;

    if (avgLoss == 0) {
      rsi[i] = 100;
    } else {
      final rs = avgGain / avgLoss;

      rsi[i] = 100 - (100 / (1 + rs));
    }
  }

  return rsi;
}
