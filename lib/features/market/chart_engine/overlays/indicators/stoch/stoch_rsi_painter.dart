import 'package:flutter/material.dart';

import '../../../core/models/indicators/stoch_rsi_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../settings/models/indicators/stoch_rsi_setting_model.dart';

class StochRsiPainter extends CustomPainter {

  final StochRsiDataModel data;

  final ChartViewport viewport;

  final StochRsiSettingsModel settings;

  StochRsiPainter({
    required this.data,
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

    if (settings.showK) {

      _drawLine(
        canvas,
        size,
        data.k,
        settings.kColor,
      );
    }

    if (settings.showD) {

      _drawLine(
        canvas,
        size,
        data.d,
        settings.dColor,
      );
    }
  }

  double _valueToY(
      double value,
      double height,
      ) {

    return ChartMath.topPadding +
        ((100 - value) / 100) *
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
      data.k.length - 1,
    );

    void drawLabel({
      required String title,
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
          '$title: ${value.toStringAsFixed(2)}',
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

    if (settings.showK) {

      drawLabel(
        title: 'STOCHRSI',
        values: data.k,
        color: settings.kColor,
      );
    }

    if (settings.showD) {

      drawLabel(
        title: 'MASTOCHRSI',
        values: data.d,
        color: settings.dColor,
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
      _valueToY(
        value,
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
      covariant StochRsiPainter oldDelegate,
      ) {

    return oldDelegate.data != data ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings;
  }
}