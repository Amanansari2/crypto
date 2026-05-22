import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/constants/chart_config.dart';
import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../../core/utils/chart_math.dart';
import '../../core/utils/visible_price_helper.dart';

class AxisPainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;
  final double chartWidth;

  AxisPainter({
    required this.chartWidth,
    required this.candles,
    required this.viewport,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) {
      return;
    }

    final textStyle = const TextStyle(
      color: AppColors.white,
      fontSize: 8,
      fontWeight: FontWeight.bold,
    );

    /// 🔥 visible candles
    // final startIndex = (viewport.scrollX / viewport.candleWidth).floor().clamp(
    //   0,
    //   candles.length,
    // );
    //
    // final visibleCount = (chartWidth / viewport.candleWidth).ceil();
    //
    // final endIndex = (startIndex + visibleCount).clamp(0, candles.length);
    //
    // if (startIndex >= endIndex) {
    //   return;
    // }

    final startIndex =
    (
        viewport.scrollX /
            viewport.candleWidth
    )
        .floor()
        .clamp(
      0,
      candles.length,
    );

    final visibleCount =
    ChartMath.visibleCount(

      screenWidth:
      chartWidth,

      candleWidth:
      viewport.candleWidth,
    );

    final endIndex =
    (startIndex + visibleCount + ChartConfig.extraVisibleCandles)
        .clamp(
      0,
      candles.length,
    );

    if (startIndex >= endIndex) {
      return;
    }

    /// 🔥 visible range
    // double maxPrice = double.negativeInfinity;
    //
    // double minPrice = double.infinity;
    //
    // for (int i = startIndex; i < endIndex; i++) {
    //   final candle = candles[i];
    //
    //   if (candle.high > maxPrice) {
    //     maxPrice = candle.high;
    //   }
    //
    //   if (candle.low < minPrice) {
    //     minPrice = candle.low;
    //   }
    // }
    //
    // double range = maxPrice - minPrice;
    // if (range <= 0) {
    //   return;
    // }
    //
    // final padding = range * 0.08;
    //
    // maxPrice += padding;
    // minPrice -= padding;

    // range = maxPrice - minPrice;

    final visiblePrice =
    VisiblePriceHelper.calculate(

      candles: candles,

      startIndex: startIndex,

      endIndex: endIndex,
    );

    double maxPrice =
        visiblePrice.maxPrice;

    double minPrice =
        visiblePrice.minPrice;

    double range =
        maxPrice - minPrice;

    if (range <= 0) {
      return;
    }

    // final padding =
    //     range * 0.08;
    //
    // maxPrice += padding;
    //
    // minPrice -= padding;
    //
    // range =
    //     maxPrice - minPrice;

    /// 🔥 adaptive formatter
    String formatPrice(double price, double range) {
      if (range < 1) {
        return price.toStringAsFixed(4);
      }

      if (range < 10) {
        return price.toStringAsFixed(3);
      }

      if (range < 100) {
        return price.toStringAsFixed(2);
      }

      return price.toStringAsFixed(2);
    }

    /// 🔥 grid synced labels

    // final labels = [
    //   (
    //     price: maxPrice,
    //
    //     y: ChartMath.priceToY(
    //       price: maxPrice,
    //       minPrice: minPrice,
    //       maxPrice: maxPrice,
    //       height: size.height,
    //     ),
    //   ),
    //
    //   (
    //     price: maxPrice - (range * 0.33),
    //
    //     y: ChartMath.priceToY(
    //       price: maxPrice - (range * 0.33),
    //
    //       minPrice: minPrice,
    //       maxPrice: maxPrice,
    //       height: size.height,
    //     ),
    //   ),
    //
    //   (
    //     price: maxPrice - (range * 0.66),
    //
    //     y: ChartMath.priceToY(
    //       price: maxPrice - (range * 0.66),
    //
    //       minPrice: minPrice,
    //       maxPrice: maxPrice,
    //       height: size.height,
    //     ),
    //   ),
    //
    //   (
    //     price: minPrice,
    //
    //     y: ChartMath.priceToY(
    //       price: minPrice,
    //       minPrice: minPrice,
    //       maxPrice: maxPrice,
    //       height: size.height,
    //     ),
    //   ),
    // ];

    final labels = List.generate(

      ChartConfig.horizontalGridCount + 2,

          (index) {
        final ratio =
            index /
                (
                    ChartConfig
                        .horizontalGridCount + 1
                );

        final price =
            maxPrice -
                (range * ratio);

        return (

        price: price,

        y: ChartMath.priceToY(

          price: price,

          minPrice: minPrice,

          maxPrice: maxPrice,

          height: size.height,
        ),
        );
      },
    );

    String? lastText;

    for (final item in labels) {
      final text = formatPrice(item.price, range);

      /// 🔥 skip duplicates
      if (text == lastText) {
        continue;
      }

      lastText = text;


      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),

        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      double y = item.y - (textPainter.height / 2);

      /// 🔥 safe top
      if (y < 2) {
        y = 2;
      }

      /// 🔥 safe bottom
      if (y + textPainter.height > size.height) {
        y = size.height - textPainter.height - 2;
      }

      textPainter.paint(canvas, Offset(size.width - textPainter.width - 2, y));
    }
  }

  @override
  bool shouldRepaint(covariant AxisPainter old) {
    return old.viewport != viewport ||
        old.candles != candles ||
        old.chartWidth != chartWidth;
  }
}
