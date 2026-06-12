import 'package:flutter/material.dart';

import '../../../core/models/candle_model.dart';
import '../../../core/models/indicators/ma_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../core/utils/price_converter.dart';
import '../../../settings/models/indicators/ma_setting_model.dart';

class MaPainter extends CustomPainter {
  final List<CandleModel> candles;

  final MaDataModel maData;

  final ChartViewport viewport;

  final List<MaSettingsModel> settings;

  final double minPrice;

  final double maxPrice;

  MaPainter({
    required this.candles,
    required this.maData,
    required this.viewport,
    required this.settings,
    required this.minPrice,
    required this.maxPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawLabels(canvas, size);

    for (final config in settings) {
      if (!config.enabled) {
        continue;
      }

      final values = maData.getPeriod(config.period);

      if (values == null) {
        continue;
      }

      _drawLine(canvas, size, values, config.color);
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    double x = 8;
    double y = 4;
    const spacing = 12;
    const rowHeight = 18;

    for (final config in settings) {
      if (!config.enabled) {
        continue;
      }

      final values = maData.getPeriod(config.period);

      if (values == null || values.isEmpty) {
        continue;
      }
      final labelIndex =
      (viewport.visibleEndIndex - 1)
          .clamp(
        0,
        values.length - 1,
      );
      double? lastValue;

      for (int i = labelIndex; i >= 0; i--) {
        if (values[i] != null) {
          lastValue = values[i];

          break;
        }
      }

      if (lastValue == null) {
        continue;
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text:
          'MA(${config.period}): '
              '${lastValue.toStringAsFixed(2)}',
          style: TextStyle(
            color: config.color,
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      if (
      x + textPainter.width >
          size.width - 8
      ) {
        x = 8;
        y += rowHeight;
      }

      textPainter.paint(canvas, Offset(x, y));

      x += textPainter.width + spacing;
    }
  }

  void _drawLine(Canvas canvas, Size size, List<double?> values, Color color) {
    final path = Path();

    bool started = false;

    final startIndex = viewport.visibleStartIndex;

    final endIndex = viewport.visibleEndIndex.clamp(0, values.length);

    for (int i = startIndex; i < endIndex; i++) {
      final value = values[i];

      if (value == null) {
        continue;
      }

      final x =
          ChartMath.indexToX(
            index: i,
            candleWidth: viewport.candleWidth,
            scrollX: viewport.scrollX,
          ) +
              viewport.candleWidth / 2;

      final y = PriceConverter.priceToY(
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
  bool shouldRepaint(covariant MaPainter oldDelegate) {
    return oldDelegate.maData != maData ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings ||
        oldDelegate.minPrice != minPrice ||
        oldDelegate.maxPrice != maxPrice;
  }
}
