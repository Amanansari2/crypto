import 'package:flutter/material.dart';

import '../../../core/models/indicators/macd_data_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../settings/models/indicators/macd_setting_model.dart';

class MacdPainter extends CustomPainter {

  final MacdDataModel macdData;

  final ChartViewport viewport;

  final MacdSettingsModel settings;

  MacdPainter({
    required this.macdData,
    required this.viewport,
    required this.settings,
  });


  double _histogramToY(
      double value,
      double min,
      double max,
      double height,
      ) {

    if (max == min) {
      return height / 2;
    }

    return height -
        ((value - min) / (max - min))
            * height;
  }

  void _drawLine(
      Canvas canvas,
      Size size,
      List<double?> values,
      Color color,
      double minValue,
      double maxValue,
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
      _histogramToY(
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



  void _drawMacdLabels(
      Canvas canvas,
      ) {

    double x = 8;

    final macdLast =
    macdData.macd.lastWhere(
          (e) => e != null,
    );

    final signalLast =
    macdData.signal.lastWhere(
          (e) => e != null,
    );

    final histogramLast =
    macdData.histogram.lastWhere(
          (e) => e != null,
    );

    void drawText(
        String text,
        Color color,
        ) {

      final painter =
      TextPainter(
        text: TextSpan(
          text: text,
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

      painter.paint(
        canvas,
        Offset(x, 4),
      );

      x +=
          painter.width + 12;
    }

    drawText(
      'DIF: ${macdLast!.toStringAsFixed(2)}',
      settings.macdColor,
    );

    drawText(
      'DEA: ${signalLast!.toStringAsFixed(2)}',
      settings.signalColor,
    );

    drawText(
      'MACD: ${histogramLast!.toStringAsFixed(2)}',
      histogramLast >= 0
          ? settings
          .positiveHistogramColor
          : settings
          .negativeHistogramColor,
    );
  }


  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

_drawMacdLabels(canvas);

    final histogram =
        macdData.histogram;

    double minValue =
        double.infinity;

    double maxValue =
        double.negativeInfinity;

    void updateRange(
        List<double?> values,
        ) {

      for (final value in values) {

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
    }



    updateRange(
      macdData.histogram,
    );

    updateRange(
      macdData.macd,
    );

    updateRange(
      macdData.signal,
    );

    final zeroY =
    _histogramToY(
      0,
      minValue,
      maxValue,
      size.height,
    );

    canvas.drawLine(
      Offset(0, zeroY),
      Offset(size.width, zeroY),
      Paint()
        ..color =
        Colors.grey.withOpacity(0.3)
        ..strokeWidth = 1,
    );


    for (
    int i = viewport.visibleStartIndex;
    i < viewport.visibleEndIndex
        .clamp(0, histogram.length);
    i++
    ) {

      final value =
      histogram[i];

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
      );

      final y =
      _histogramToY(
        value,
        minValue,
        maxValue,
        size.height,
      );

      canvas.drawRect(
        Rect.fromLTRB(
          x,
          value >= 0
              ? y
              : zeroY,
          x +
              viewport.candleWidth *
                  0.8,
          value >= 0
              ? zeroY
              : y,
        ),
        Paint()
          ..color = value >= 0
              ? settings
              .positiveHistogramColor
              : settings
              .negativeHistogramColor,
      );
    }

if (settings.showMacdLine) {

  _drawLine(
    canvas,
    size,
    macdData.macd,
    settings.macdColor,
    minValue,
    maxValue,
  );
}

if (settings.showSignalLine) {

  _drawLine(
    canvas,
    size,
    macdData.signal,
    settings.signalColor,
    minValue,
    maxValue,
  );
}
  }



  @override
  bool shouldRepaint(
      covariant MacdPainter oldDelegate,
      ) {

    return oldDelegate.macdData != macdData ||
        oldDelegate.viewport != viewport ||
        oldDelegate.settings != settings;
  }
}