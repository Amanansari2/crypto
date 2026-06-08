import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../../core/utils/chart_math.dart';

class CandlePainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;
  final double minPrice;
  final double maxPrice;

  CandlePainter({
    required this.candles,
    required this.viewport,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final bullPaint = Paint()
      ..isAntiAlias = false
      ..color = AppColors.green
      ..strokeWidth = 1;

    final bearPaint = Paint()
      ..isAntiAlias = false
      ..color = AppColors.red
      ..strokeWidth = 1;



    final startIndex = (viewport.scrollX / viewport.candleWidth).floor();

    final visibleCount = (size.width / viewport.candleWidth).ceil();

    final endIndex = startIndex + visibleCount + 2;

    final safeStart = startIndex.clamp(0, candles.length);

    final safeEnd = endIndex.clamp(0, candles.length);

    if (safeStart >= safeEnd) {
      return;
    }



    final priceRange = (maxPrice - minPrice).abs();

    if (priceRange <= 0) {
      return;
    }


    /// 🔥 DRAW CANDLES
    for (int i = safeStart; i < safeEnd; i++) {

      final candle = candles[i];



      final x =
      ChartMath.indexToX(

        index: i,

        candleWidth:
        viewport.candleWidth,

        scrollX:
        viewport.scrollX,
      );

      /// 🔥 skip offscreen left
      if (x + viewport.candleWidth < 0) {
        continue;
      }

      /// 🔥 stop offscreen right
      if (x > size.width) {
        break;
      }



      double bodyWidth =
      ChartMath.candleBodyWidth(

        candleWidth:
        viewport.candleWidth,
      );

      double spacing =
      ChartMath.candleSpacing(

        candleWidth:
        viewport.candleWidth,
      );

      /// 🔥 limits
      bodyWidth =
          bodyWidth.clamp(ChartConfig.candleMinBody, ChartConfig.candleMaxBody);
      spacing = spacing.clamp(ChartConfig.minSpacing, ChartConfig.maxSpacing);


      final snappedX =
      ChartMath.snappedX(
        x: x, spacing: spacing,
      );

      final openY = ChartMath.priceToY(
        price: candle.open,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final closeY = ChartMath.priceToY(
        price: candle.close,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final highY = ChartMath.priceToY(
        price: candle.high,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final lowY = ChartMath.priceToY(
        price: candle.low,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final isBull =
          candle.close >= candle.open;

      final paint =
      isBull
          ? bullPaint
          : bearPaint;


      /// 🔥 centered wick
      final wickX =
          snappedX + bodyWidth / 2;


      final wickPadding =
      ChartMath.wickPadding(
        candleWidth:
        viewport.candleWidth,
      );

      canvas.drawLine(
        Offset(wickX, highY - wickPadding),
        Offset(wickX, lowY + wickPadding),
        paint,
      );

      /// 🔥 safe candle body
      final top =
      openY < closeY
          ? openY
          : closeY;

      final bottom =
      openY > closeY
          ? openY
          : closeY;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
        Rect.fromLTRB(
          snappedX,
          top,
          snappedX + bodyWidth,
          bottom == top
              ? bottom + 1
              : bottom,
        ),
          Radius.circular(
            bodyWidth > 8 ? 1.2 : 0.8,
          ),
        ),
        paint,
      );
    }


  }

  @override
  bool shouldRepaint(covariant CandlePainter old) {
    return old.viewport != viewport ||
        old.candles != candles ||
        old.minPrice != minPrice ||
        old.maxPrice != maxPrice;
  }
}
