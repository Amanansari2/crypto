class VisibleCandleResult {
  final int startIndex;

  final int endIndex;

  final int visibleCount;

  const VisibleCandleResult({
    required this.startIndex,

    required this.endIndex,

    required this.visibleCount,
  });
}

class VisibleCandleHelper {
  static VisibleCandleResult calculate({
    required double scrollX,

    required double candleWidth,

    required double screenWidth,

    required int candleCount,
  }) {
    final startIndex = (scrollX / candleWidth).floor().clamp(0, candleCount);

    final visibleCount = (screenWidth / candleWidth).ceil();

    final endIndex = (startIndex + visibleCount).clamp(0, candleCount);

    return VisibleCandleResult(
      startIndex: startIndex,

      endIndex: endIndex,

      visibleCount: visibleCount,
    );
  }
}
