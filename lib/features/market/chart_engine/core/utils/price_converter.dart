class PriceConverter {
  static const double topPadding = 8;

  static const double bottomPadding = 8;

  static double priceToY({
    required double price,

    required double minPrice,

    required double maxPrice,

    required double height,
  }) {
    final drawableHeight = height - topPadding - bottomPadding;

    return topPadding +
        ((maxPrice - price) / (maxPrice - minPrice)) * drawableHeight;
  }

  static double yToPrice({
    required double y,

    required double minPrice,

    required double maxPrice,

    required double height,
  }) {
    final drawableHeight = height - topPadding - bottomPadding;

    final normalizedY = ((y - topPadding) / drawableHeight).clamp(0.0, 1.0);

    return maxPrice - (normalizedY * (maxPrice - minPrice));
  }
}
