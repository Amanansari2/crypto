class ChartViewport {
  final double scrollX;

  final double candleWidth;

  final int visibleStartIndex;

  final int visibleEndIndex;
  final bool isAtLatest;
  const ChartViewport({
    required this.scrollX,

    required this.candleWidth,

    required this.visibleStartIndex,

    required this.visibleEndIndex,
    required this.isAtLatest
  });

  ChartViewport copyWith({
    double? scrollX,

    double? candleWidth,

    int? visibleStartIndex,

    int? visibleEndIndex,
    bool? isAtLatest
  }) {
    return ChartViewport(
      scrollX: scrollX ?? this.scrollX,

      candleWidth: candleWidth ?? this.candleWidth,

      visibleStartIndex: visibleStartIndex ?? this.visibleStartIndex,

      visibleEndIndex: visibleEndIndex ?? this.visibleEndIndex,
      isAtLatest: isAtLatest ?? this.isAtLatest,
    );
  }
}
