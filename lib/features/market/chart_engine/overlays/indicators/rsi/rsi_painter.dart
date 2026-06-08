import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:crypto_app/features/market/chart_engine/core/models/viewport_model.dart';
import 'package:crypto_app/features/market/chart_engine/settings/models/indicators/rsi_setting_model.dart';
import 'package:flutter/material.dart';
import '../../../core/models/indicators/rsi_data_model.dart';
import '../../../core/utils/chart_math.dart';

class RsiPainter extends CustomPainter {

  final RsiDataModel rsiData;
  final ChartViewport viewport;
  final List<RsiSettingsModel> settings;

  RsiPainter({
    required this.rsiData,
    required this.viewport,
    required this.settings
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    // RSI drawing next step
    _drawRsiLabels(
      canvas,
      size,
    );

    for (final config in settings) {

      if (!config.enabled) {
        continue;
      }

      final values =
      rsiData.getPeriod(
        config.period,
      );

      if (values == null) {
        continue;
      }

      _drawRsiLine(
        canvas,
        size,
        values,
        config.color,
      );
    }
  }

  double _rsiToY(
      double value,
      double height,
      ) {

    return ChartMath.topPadding +
        ((100 - value) / 100) *
            (height -
                ChartMath.topPadding -
                ChartMath.bottomPadding);
  }

  // void _drawLevel(
  //     Canvas canvas,
  //     Size size,
  //     double level,
  //     ) {
  //
  //   final y =
  //   _rsiToY(
  //     level,
  //     size.height,
  //   );
  //
  //   canvas.drawLine(
  //     Offset(0, y),
  //     Offset(size.width, y),
  //     Paint()
  //       ..color = Colors.grey.withOpacity(0.4)
  //       ..strokeWidth = 0.8,
  //   );
  // }

  void _drawRsiLabels(
      Canvas canvas,
      Size size,
      ) {

    double x = 8;

    for (final config in settings) {

      if (!config.enabled) {
        continue;
      }

      final values =
      rsiData.getPeriod(
        config.period,
      );

      if (values == null ||
          values.isEmpty) {
        continue;
      }

      double? lastValue;

      for (
      int i = values.length - 1;
      i >= 0;
      i--
      ) {

        if (values[i] != null) {
          lastValue = values[i];
          break;
        }
      }

      if (lastValue == null) {
        continue;
      }

      final textPainter =
      TextPainter(
        text: TextSpan(
          text:
          'RSI(${config.period}): ${lastValue.toStringAsFixed(2)}',
          style: TextStyle(
            color: config.color,
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
  }

  void _drawRsiLine(
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
      _rsiToY(
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
      covariant RsiPainter oldDelegate,
      ) {

    return oldDelegate.rsiData != rsiData ||
            oldDelegate.viewport != viewport ||
            oldDelegate.settings != settings ;
  }
}