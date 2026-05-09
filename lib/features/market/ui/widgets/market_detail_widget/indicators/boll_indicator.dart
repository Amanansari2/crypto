import 'dart:math';

Map<String, List<double?>> calculateBollingerBands(List candles) {
  const period = 20;

  const multiplier = 2.0;

  List<double?> upper = [];

  List<double?> middle = [];

  List<double?> lower = [];

  for (int i = 0; i < candles.length; i++) {
    if (i < period - 1) {
      upper.add(null);

      middle.add(null);

      lower.add(null);

      continue;
    }

    List<double> closes = [];

    for (int j = i - period + 1; j <= i; j++) {
      closes.add(candles[j].close.toDouble());
    }

    double sma = closes.reduce((a, b) => a + b) / period;

    double variance =
        closes.map((e) => pow(e - sma, 2)).reduce((a, b) => a + b) / period;

    double stdDev = sqrt(variance);

    middle.add(sma);

    upper.add(sma + (stdDev * multiplier));

    lower.add(sma - (stdDev * multiplier));
  }

  return {'upper': upper, 'middle': middle, 'lower': lower};
}
