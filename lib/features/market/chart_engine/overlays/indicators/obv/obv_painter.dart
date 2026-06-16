import 'package:flutter/material.dart';

import '../../../core/models/indicators/obv_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../settings/models/indicators/obv_setting_model.dart';

class ObvPainter extends CustomPainter {

  final ObvDataModel obvData;

  final ChartViewport viewport;

  final ObvSettingsModel settings;

  ObvPainter({
    required this.obvData,
    required this.viewport,
    required this.settings,
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

    if (settings.showObv) {

      _drawLine(
        canvas,
        size,
        obvData.obv,
        settings.obvColor,
      );
    }

    if (settings.showMaObv) {

      _drawLine(
        canvas,
        size,
        obvData.maObv,
        settings.maObvColor,
      );
    }
  }

  double _valueToY(
      double value,
      double min,
      double max,
      double height,
      ) {

    if (max == min) {
      return height / 2;
    }

    return ChartMath.topPadding +
        ((max - value) /
            (max - min)) *
            (height -
                ChartMath.topPadding -
                ChartMath.bottomPadding);
  }

  void _drawLabels(
      Canvas canvas,
      Size size,
      ) {

    double x = 8;

    final labelIndex =
    (viewport.visibleEndIndex - 1)
        .clamp(
      0,
      obvData.obv.length - 1,
    );

    void drawLabel({
      required String name,
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
          '$name: ${value.toStringAsFixed(4)}',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight:
            FontWeight.w500,
          ),
        ),
        textDirection:
        TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(x, 4),
      );

      x +=
          textPainter.width + 12;
    }

    if (settings.showObv) {

      drawLabel(
        name: 'OBV',
        values: obvData.obv,
        color: settings.obvColor,
      );
    }

    if (settings.showMaObv) {

      drawLabel(
        name:
        'MAOBV(${settings.maPeriod})',
        values: obvData.maObv,
        color: settings.maObvColor,
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

    double minValue =
        double.infinity;

    double maxValue =
        double.negativeInfinity;

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

      if (value < minValue) {
        minValue = value;
      }

      if (value > maxValue) {
        maxValue = value;
      }
    }

    if (
    minValue ==
        double.infinity
    ) {
      return;
    }

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
      _valueToY(
        value,
        minValue,
        maxValue,
        size.height,
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
      covariant ObvPainter oldDelegate,
      ) {

    return oldDelegate.obvData != obvData ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings;
  }
}