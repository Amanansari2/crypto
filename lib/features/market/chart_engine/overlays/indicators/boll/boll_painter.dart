import 'package:flutter/material.dart';

import '../../../core/models/candle_model.dart';
import '../../../core/models/indicators/boll_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../core/utils/price_converter.dart';
import '../../../settings/models/indicators/boll_setting_model.dart';

class BollPainter extends CustomPainter {

  final List<CandleModel> candles;

  final BollDataModel bollData;

  final ChartViewport viewport;

  final BollSettingsModel settings;

  final double minPrice;

  final double maxPrice;

  BollPainter({
    required this.candles,
    required this.bollData,
    required this.viewport,
    required this.settings,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    _drawLabels(
      canvas,
      size,
    );

    if (settings.showUpper) {
      _drawLine(
        canvas,
        size,
        bollData.upper,
        settings.upperColor,
      );
    }

    if (settings.showMiddle) {
      _drawLine(
        canvas,
        size,
        bollData.middle,
        settings.middleColor,
      );
    }

    if (settings.showLower) {
      _drawLine(
        canvas,
        size,
        bollData.lower,
        settings.lowerColor,
      );
    }
  }

  void _drawLabels(
      Canvas canvas,
      Size size,
      ) {

    final labelIndex =
    (viewport.visibleEndIndex - 1)
        .clamp(
      0,
      candles.length - 1,
    );

    double x = 8;

    final bandWidthText =
    settings.bandwidth % 1 == 0
        ? settings.bandwidth.toInt().toString()
        : settings.bandwidth.toString();

    final titlePainter =
    TextPainter(
      text: TextSpan(
        text:
        'BOLL(${settings.period},$bandWidthText)',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight:
          FontWeight.w600,
        ),
      ),
      textDirection:
      TextDirection.ltr,
    )..layout();

    titlePainter.paint(
      canvas,
      Offset(x, 4),
    );

    x += titlePainter.width + 16;

    void drawValue({
      required String label,
      required List<double?> values,
      required Color color,
    }) {

      double? value;

      for (
      int i = labelIndex;
      i >= 0;
      i--
      ) {

        if (values[i] != null) {

          value = values[i];

          break;
        }
      }

      if (value == null) {
        return;
      }

      final textPainter =
      TextPainter(
        text: TextSpan(
          text:
          '$label:${value.toStringAsFixed(1)}',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight:
            FontWeight.w600,
          ),
        ),
        textDirection:
        TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x, 4),
      );

      x += textPainter.width + 12;
    }

    if (settings.showUpper) {
      drawValue(
        label: 'UP',
        values: bollData.upper,
        color: settings.upperColor,
      );
    }

    if (settings.showMiddle) {
      drawValue(
        label: 'MB',
        values: bollData.middle,
        color: settings.middleColor,
      );
    }

    if (settings.showLower) {
      drawValue(
        label: 'DN',
        values: bollData.lower,
        color: settings.lowerColor,
      );
    }
  }

  void _drawLine(
      Canvas canvas,
      Size size,
      List<double?> values,
      Color color,
      ) {

    final path = Path();

    bool started = false;

    final startIndex =
        viewport.visibleStartIndex;

    final endIndex =
    viewport.visibleEndIndex
        .clamp(
      0,
      values.length,
    );

    for (
    int i = startIndex;
    i < endIndex;
    i++
    ) {

      final value =
      values[i];

      if (value == null) {
        continue;
      }

      final x =
          ChartMath.indexToX(
            index: i,
            candleWidth:
            viewport.candleWidth,
            scrollX:
            viewport.scrollX,
          ) +
              viewport.candleWidth / 2;

      final y =
      PriceConverter.priceToY(
        price: value,
        minPrice: minPrice,
        maxPrice: maxPrice,
        height: size.height,
      );

      if (!started) {

        path.moveTo(x, y);

        started = true;

      } else {

        path.lineTo(x, y);
      }
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(
      covariant BollPainter oldDelegate,
      ) {

    return oldDelegate.bollData != bollData ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings ||
        oldDelegate.minPrice != minPrice ||
        oldDelegate.maxPrice != maxPrice;
  }
}