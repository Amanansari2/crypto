import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';

class TimeAxisPainter extends CustomPainter {
  final List<CandleModel> candles;

  final ChartViewport viewport;
  final Color textColor;

  TimeAxisPainter({required this.candles, required this.viewport, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) {
      return;
    }

    final textStyle =  TextStyle(
      color: textColor,
      fontSize: 8,
      fontWeight: FontWeight.bold,
    );

    /// visible candles
    final startIndex = (viewport.scrollX / viewport.candleWidth).floor().clamp(
      0,
      candles.length - 1,
    );

    final visibleCount = (size.width / viewport.candleWidth).ceil();

    final endIndex = (startIndex + visibleCount).clamp(0, candles.length);

    /// 🔥 only 2 labels like TradingView
    // final visibleCandles = endIndex - startIndex;
    //
    // final step = (visibleCandles / 2).floor().clamp(1, visibleCandles);
    //
    // /// 🔥 only 2 centered labels
    // final positions = [
    //   startIndex + ((endIndex - startIndex) * 0.30).floor(),
    //
    //   startIndex + ((endIndex - startIndex) * 0.62).floor(),
    // ];

    // for (final index in positions) {
    //   if (index < 0 || index >= candles.length) {
    //     continue;
    //   }

    // const int step = 10; // start testing

    int step;

    if (viewport.candleWidth < 5) {
      step = 40;
    } else if (viewport.candleWidth < 8) {
      step = 25;
    } else if (viewport.candleWidth < 12) {
      step = 15;
    } else {
      step = 10;
    }

    final firstLabel = (startIndex ~/ step) * step;
    double lastDrawnRight = -99999;
    for (
    int index = firstLabel;
    index < endIndex;
    index += step
    ) {

      final candle = candles[index];

      final x =
          (index * viewport.candleWidth) -
          viewport.scrollX +
          (viewport.candleWidth / 2);

      final text = DateFormat('MM-dd HH:mm').format(candle.time);

      final textPainter = TextPainter(
        text: TextSpan(text: text, style: textStyle),

        textDirection: ui.TextDirection.ltr,
      );

      textPainter.layout();
      final left =
          x - (textPainter.width / 2);

      if (left < lastDrawnRight + 10) {
        continue;
      }

      lastDrawnRight =
          left + textPainter.width;
      final y = (size.height - textPainter.height) /2;

      textPainter.paint(canvas,
          Offset(
              // x - (textPainter.width / 2), y));
             left, y));
    }
  }

  @override
  bool shouldRepaint(covariant TimeAxisPainter old) {
    return old.viewport != viewport || old.candles != candles;
  }
}
