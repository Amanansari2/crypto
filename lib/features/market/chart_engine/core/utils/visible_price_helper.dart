import '../models/candle_model.dart';

class VisiblePriceResult {
  final double minPrice;

  final double maxPrice;

  const VisiblePriceResult({required this.minPrice, required this.maxPrice});
}

class VisiblePriceHelper {
  VisiblePriceHelper._();

  static VisiblePriceResult calculate({
    required List<CandleModel> candles,

    required int startIndex,

    required int endIndex,
  }) {
    double maxPrice = double.negativeInfinity;

    double minPrice = double.infinity;

    for (int i = startIndex; i < endIndex; i++) {
      final candle = candles[i];

      if (candle.high > maxPrice) {
        maxPrice = candle.high;
      }

      if (candle.low < minPrice) {
        minPrice = candle.low;
      }
    }

    return VisiblePriceResult(minPrice: minPrice, maxPrice: maxPrice);
  }
}
