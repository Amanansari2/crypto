//
// class CrosshairResult {
//
//   final int candleIndex;
//
//   final double snappedX;
//
//   const CrosshairResult({
//
//     required this.candleIndex,
//
//     required this.snappedX,
//   });
// }
//
// class CrosshairEngine {
//
//   /// 🔥 snap crosshair to nearest candle
//   static CrosshairResult snapToCandle({
//
//     required double localDx,
//
//     required double scrollX,
//
//     required double candleWidth,
//
//     required int candleCount,
//
//   }) {
//
//     /// 🔥 nearest candle
//     final candleIndex =
//     ((localDx + scrollX) /
//         candleWidth)
//         .floor()
//         .clamp(
//       0,
//       candleCount - 1,
//     );
//
//     /// 🔥 snapped center
//     final snappedX =
//         (candleIndex * candleWidth) -
//             scrollX +
//             (candleWidth / 2);
//
//     return CrosshairResult(
//
//       candleIndex: candleIndex,
//
//       snappedX: snappedX,
//     );
//   }
// }

class CrosshairResult {
  final int candleIndex;

  final double snappedX;

  const CrosshairResult({required this.candleIndex, required this.snappedX});
}

class CrosshairEngine {
  static CrosshairResult snapToCandle({
    required double localDx,

    required double scrollX,

    required double candleWidth,

    required int candleCount,
  }) {
    final candleIndex = ((localDx + scrollX) / candleWidth).round().clamp(
      0,
      candleCount - 1,
    );

    /// SAME LOGIC AS CandlePainter
    double bodyWidth;
    double spacing;

    if (candleWidth <= 6) {
      bodyWidth = candleWidth * 0.72;
      spacing = candleWidth * 0.48;
    } else if (candleWidth <= 12) {
      bodyWidth = candleWidth * 0.66;
      spacing = candleWidth * 0.20;
    } else {
      bodyWidth = candleWidth * 0.52;
      spacing = candleWidth * 0.08;
    }

    bodyWidth = bodyWidth.clamp(1.2, 22.0);
    spacing = spacing.clamp(0.8, 6.0);

    final candleX = (candleIndex * candleWidth) - scrollX;

    /// EXACT same snappedX as painter
    final snappedBodyX = (candleX + spacing / 2).floorToDouble() + 0.5;

    /// EXACT wick center
    final snappedX = snappedBodyX + (bodyWidth / 2);

    return CrosshairResult(candleIndex: candleIndex, snappedX: snappedX);
  }
}
