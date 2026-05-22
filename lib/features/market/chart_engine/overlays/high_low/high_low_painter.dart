import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:flutter/material.dart';

import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../../core/utils/chart_math.dart';

class HighLowPainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;

  final double minPrice;

  final double maxPrice;

  HighLowPainter({
    required this.candles,

    required this.viewport,

    required this.minPrice,

    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) {
      return;
    }

    final startIndex = (viewport.scrollX / viewport.candleWidth).floor();

    final visibleCount = (size.width / viewport.candleWidth).ceil();

    final endIndex = startIndex + visibleCount + 2;

    final safeStart = startIndex.clamp(0, candles.length);

    final safeEnd = endIndex.clamp(0, candles.length);

    if (safeStart >= safeEnd) {
      return;
    }

    CandleModel? highest;

    CandleModel? lowest;

    int highestIndex = safeStart;

    int lowestIndex = safeStart;

    for (int i = safeStart; i < safeEnd; i++) {
      final candle = candles[i];

      if (highest == null || candle.high > highest.high) {
        highest = candle;

        highestIndex = i;
      }

      if (lowest == null || candle.low < lowest.low) {
        lowest = candle;

        lowestIndex = i;
      }
    }

    if (highest == null || lowest == null) {
      return;
    }

    final highBaseX = ChartMath.indexToX(
      index: highestIndex,
      candleWidth: viewport.candleWidth,
      scrollX: viewport.scrollX,
    );

    final highSpacing = ChartMath.candleSpacing(
      candleWidth: viewport.candleWidth,
    );

    final highBodyWidth = ChartMath.candleBodyWidth(
      candleWidth: viewport.candleWidth,
    );

    final highSnappedX = ChartMath.snappedX(x: highBaseX, spacing: highSpacing);

    final highX = highSnappedX + highBodyWidth / 2;

    final lowBaseX = ChartMath.indexToX(
      index: lowestIndex,

      candleWidth: viewport.candleWidth,

      scrollX: viewport.scrollX,
    );

    final lowSpacing = ChartMath.candleSpacing(
      candleWidth: viewport.candleWidth,
    );

    final lowBodyWidth = ChartMath.candleBodyWidth(
      candleWidth: viewport.candleWidth,
    );

    final lowSnappedX = ChartMath.snappedX(x: lowBaseX, spacing: lowSpacing);

    final lowX = lowSnappedX + lowBodyWidth / 2;

    final highY = ChartMath.priceToY(
      price: highest.high,

      minPrice: minPrice,

      maxPrice: maxPrice,

      height: size.height,
    );

    final lowY = ChartMath.priceToY(
      price: lowest.low,

      minPrice: minPrice,

      maxPrice: maxPrice,

      height: size.height,
    );

    final linePaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 0.8;

    final textStyle = const TextStyle(color: Colors.grey, fontSize: 10);
    const markerWidth = ChartConfig.markerWidth;

    /// HIGH
    canvas.drawLine(Offset(highX, highY), Offset(highX, highY), linePaint);

    canvas.drawLine(
      Offset(highX, highY),

      Offset(highX + markerWidth, highY),

      linePaint,
    );

    final highText = TextPainter(
      text: TextSpan(text: highest.high.toStringAsFixed(2), style: textStyle),

      textDirection: TextDirection.ltr,
    );

    highText.layout();

    highText.paint(canvas, Offset(highX + markerWidth + 4, highY - 6));

    /// LOW
    canvas.drawLine(Offset(lowX, lowY), Offset(lowX + 30, lowY), linePaint);

    final lowText = TextPainter(
      text: TextSpan(text: lowest.low.toStringAsFixed(2), style: textStyle),

      textDirection: TextDirection.ltr,
    );

    lowText.layout();

    lowText.paint(canvas, Offset(lowX + 32, lowY - 6));
  }

  @override
  bool shouldRepaint(covariant HighLowPainter oldDelegate) {
    return oldDelegate.candles != candles ||
        oldDelegate.viewport != viewport ||
        oldDelegate.minPrice != minPrice ||
        oldDelegate.maxPrice != maxPrice;
  }
}
