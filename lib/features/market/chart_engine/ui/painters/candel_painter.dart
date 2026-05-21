

import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../../core/utils/price_converter.dart';

class CandlePainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;

  CandlePainter({
    required this.candles,
    required this.viewport,
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

    /// 🔥 FAST min/max calculation
    double maxPrice = double.negativeInfinity;

    double minPrice = double.infinity;

    for (int i = safeStart; i < safeEnd; i++) {
      final candle = candles[i];

      if (candle.high > maxPrice) {
        maxPrice = candle.high;
      }

      if (candle.low < minPrice) {
        minPrice = candle.low;
      }
    }

    final priceRange = (maxPrice - minPrice).abs();

    if (priceRange <= 0) {
      return;
    }


    /// 🔥 DRAW CANDLES
    for (int i = safeStart; i < safeEnd; i++) {

      final candle = candles[i];

      final x =
          (i * viewport.candleWidth) -
              viewport.scrollX;

      /// 🔥 skip offscreen left
      if (x + viewport.candleWidth < 0) {
        continue;
      }

      /// 🔥 stop offscreen right
      if (x > size.width) {
        break;
      }

      double bodyWidth;
      double spacing;

      if (viewport.candleWidth <= 6) {
        /// minimum zoom
        bodyWidth = viewport.candleWidth * 0.72;
        spacing = viewport.candleWidth * 0.48;
      }
      else if (viewport.candleWidth <= 12) {
        /// medium zoom
        bodyWidth = viewport.candleWidth * 0.66;
        spacing = viewport.candleWidth * 0.20;
      }
      else {
        /// max zoom
        bodyWidth = viewport.candleWidth * 0.52;
        spacing = viewport.candleWidth * 0.08;
      }

      /// 🔥 limits
      bodyWidth = bodyWidth.clamp(1.2, 22.0);
      spacing = spacing.clamp(0.8, 6.0);

      /// 🔥 pixel perfect snapping
      final snappedX =
          (x + spacing / 2)
              .floorToDouble() + 0.5;

      final openY = PriceConverter.priceToY(
        price: candle.open,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final closeY = PriceConverter.priceToY(
        price: candle.close,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final highY = PriceConverter.priceToY(
        price: candle.high,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      final lowY = PriceConverter.priceToY(
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
      viewport.candleWidth > 18
          ? 2.0
          : viewport.candleWidth > 10
          ? 1.2
          : 0.8;

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
        old.candles != candles;
  }
}
