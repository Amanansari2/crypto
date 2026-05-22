class ChartMath {
  ChartMath._();

  /// 🔥 TOP/BOTTOM SAFE PADDING
  static const double topPadding = 8;

  static const double bottomPadding = 8;

  /// 🔥 PRICE -> Y
  static double priceToY({
    required double price,

    required double minPrice,

    required double maxPrice,

    required double height,
  }) {
    final range = maxPrice - minPrice;

    if (range <= 0) {
      return topPadding;
    }

    final drawableHeight = height - topPadding - bottomPadding;

    return topPadding + ((maxPrice - price) / range) * drawableHeight;
  }

  /// 🔥 Y -> PRICE
  static double yToPrice({
    required double y,

    required double minPrice,

    required double maxPrice,

    required double height,
  }) {
    final range = maxPrice - minPrice;

    if (range <= 0) {
      return minPrice;
    }

    final drawableHeight = height - topPadding - bottomPadding;

    final normalizedY = ((y - topPadding) / drawableHeight).clamp(0.0, 1.0);

    return maxPrice - (normalizedY * range);
  }

  /// 🔥 INDEX -> X
  static double indexToX({
    required int index,

    required double candleWidth,

    required double scrollX,
  }) {
    return (index * candleWidth) - scrollX;
  }

  /// 🔥 X -> INDEX
  static int xToIndex({
    required double x,

    required double candleWidth,

    required double scrollX,

    required int candleCount,
  }) {
    return ((x + scrollX) / candleWidth).floor().clamp(0, candleCount - 1);
  }

  /// 🔥 CLAMP SCROLL
  static double clampScroll({
    required double scrollX,

    required double candleWidth,

    required int candleCount,

    required double screenWidth,
  }) {
    final maxScroll = (candleCount * candleWidth) - screenWidth;

    return scrollX.clamp(0, maxScroll < 0 ? 0 : maxScroll).toDouble();
  }

  /// 🔥 VISIBLE CANDLE COUNT
  static int visibleCount({
    required double screenWidth,

    required double candleWidth,
  }) {
    return (screenWidth / candleWidth).ceil();
  }

  /// 🔥 CANDLE BODY WIDTH
  static double candleBodyWidth({required double candleWidth}) {
    double bodyWidth;

    if (candleWidth <= 6) {
      bodyWidth = candleWidth * 0.72;
    } else if (candleWidth <= 12) {
      bodyWidth = candleWidth * 0.66;
    } else {
      bodyWidth = candleWidth * 0.52;
    }

    return bodyWidth;
  }

  /// 🔥 CANDLE SPACING
  static double candleSpacing({required double candleWidth}) {
    double spacing;

    if (candleWidth <= 6) {
      spacing = candleWidth * 0.48;
    } else if (candleWidth <= 12) {
      spacing = candleWidth * 0.20;
    } else {
      spacing = candleWidth * 0.08;
    }

    return spacing;
  }

  /// 🔥 PIXEL PERFECT SNAP
  static double snappedX({required double x, required double spacing}) {
    return (x + spacing / 2).floorToDouble() + 0.5;
  }

  /// 🔥 WICK PADDING
  static double wickPadding({required double candleWidth}) {
    if (candleWidth > 18) {
      return 2.0;
    }

    if (candleWidth > 10) {
      return 1.2;
    }

    return 0.8;
  }
}
