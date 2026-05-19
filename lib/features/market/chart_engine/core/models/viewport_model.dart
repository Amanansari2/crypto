class ChartViewport {
  final double scrollX;

  final double candleWidth;

  final int visibleStartIndex;

  final int visibleEndIndex;

  const ChartViewport({
    required this.scrollX,

    required this.candleWidth,

    required this.visibleStartIndex,

    required this.visibleEndIndex,
  });

  ChartViewport copyWith({
    double? scrollX,

    double? candleWidth,

    int? visibleStartIndex,

    int? visibleEndIndex,
  }) {
    return ChartViewport(
      scrollX: scrollX ?? this.scrollX,

      candleWidth: candleWidth ?? this.candleWidth,

      visibleStartIndex: visibleStartIndex ?? this.visibleStartIndex,

      visibleEndIndex: visibleEndIndex ?? this.visibleEndIndex,
    );
  }
}
