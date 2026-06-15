import 'package:flutter/material.dart';

import '../../../core/models/indicators/wr_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../settings/models/indicators/wr_setting_model.dart';

class WrPainter extends CustomPainter {

  final WrDataModel wrData;

  final ChartViewport viewport;

  final WrSettingsModel settings;

  WrPainter({
    required this.wrData,
    required this.viewport,
    required this.settings,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    _drawLabel(
      canvas,
      size,
    );

    _drawLine(
      canvas,
      size,
    );
  }

  double _wrToY(
      double value,
      double height,
      ) {

    return ChartMath.topPadding +
        ((0 - value) / 100) *
            (height -
                ChartMath.topPadding -
                ChartMath.bottomPadding);
  }

  void _drawLabel(
      Canvas canvas,
      Size size,
      ) {

    if (wrData.values.isEmpty) {
      return;
    }

    final labelIndex =
    (viewport.visibleEndIndex - 1)
        .clamp(
      0,
      wrData.values.length - 1,
    );

    double? value;

    for (
    int i = labelIndex;
    i >= 0;
    i--
    ) {

      if (
      wrData.values[i] != null
      ) {

        value =
        wrData.values[i];

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
        'Wm %R(${settings.period}): ${value.toStringAsFixed(2)}',
        style: TextStyle(
          color: settings.color,
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
      const Offset(8, 4),
    );
  }

  void _drawLine(
      Canvas canvas,
      Size size,
      ) {

    final path = Path();

    bool started = false;

    final startIndex =
        viewport.visibleStartIndex;

    final endIndex =
    viewport.visibleEndIndex
        .clamp(
      0,
      wrData.values.length,
    );

    for (
    int i = startIndex;
    i < endIndex;
    i++
    ) {

      final value =
      wrData.values[i];

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
      _wrToY(
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
        ..color =
            settings.color
        ..strokeWidth = 1.5
        ..style =
            PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(
      covariant WrPainter oldDelegate,
      ) {

    return oldDelegate.wrData != wrData ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings;
  }
}