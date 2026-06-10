import 'package:flutter/cupertino.dart';

import '../../../core/models/candle_model.dart';
import '../../../core/models/viewport_model.dart';
import '../../../core/utils/chart_math.dart';
import '../../../core/utils/price_converter.dart';
import '../../../indicators/volume_ma_indicator.dart';
import '../../../settings/models/indicators/volume_setting_model.dart';

class VolumePainter extends CustomPainter {

  final List<CandleModel> candles;

  final ChartViewport viewport;

  final VolumeSettingsModel settings;

  VolumePainter({
    required this.candles,
    required this.viewport,
    required this.settings,
  });



  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    double maxVolume = 0;

    final ma1Values =
    VolumeMaIndicator.calculate(
      candles: candles,
      period: settings.ma1Period,
    );

    final ma2Values =
    VolumeMaIndicator.calculate(
      candles: candles,
      period: settings.ma2Period,
    );

    _drawVolumeLabels(
      canvas,
      size,
      ma1Values,
      ma2Values,
    );

    for (
    int i = viewport.visibleStartIndex;
    i < viewport.visibleEndIndex.clamp(
      0,
      candles.length,
    );
    i++
    ) {

      if (
      candles[i].volume >
          maxVolume
      ) {
        maxVolume =
            candles[i].volume;
      }
    }

    for (
    int i = viewport.visibleStartIndex;
    i < viewport.visibleEndIndex.clamp(
      0,
      ma1Values.length,
    );
    i++
    ) {
      final value = ma1Values[i];

      if (value != null &&
          value > maxVolume) {
        maxVolume = value;
      }
    }

    for (
    int i = viewport.visibleStartIndex;
    i < viewport.visibleEndIndex.clamp(
      0,
      ma2Values.length,
    );
    i++
    ) {
      final value = ma2Values[i];

      if (value != null &&
          value > maxVolume) {
        maxVolume = value;
      }
    }

    if (maxVolume <= 0) {
      return;
    }

    for (
    int i = viewport.visibleStartIndex;
    i < viewport.visibleEndIndex.clamp(
      0,
      candles.length,
    );
    i++
    ) {

      final candle =
      candles[i];

      final x =
      ChartMath.indexToX(
        index: i,
        candleWidth:
        viewport.candleWidth,
        scrollX:
        viewport.scrollX,
      );

      final topY =
      ValueConverter.valueToY(
        value: candle.volume,
        minValue: 0,
        maxValue: maxVolume,
        height: size.height,
      );


      Color color =
          settings.upColor;

      if (i > 0) {

        color =
        candle.close >=
            candles[i - 1].close
            ? settings.upColor
            : settings.downColor;
      }

      canvas.drawRect(
        Rect.fromLTRB(
          x,
          topY,
          x +
              viewport.candleWidth *
                  0.8,
          size.height -
              ValueConverter.bottomPadding,
        ),
        Paint()
          ..color = color,
      );
    }
    if (settings.showMa1) {

      _drawLine(
        canvas,
        size,
        ma1Values,
        settings.ma1Color,
        maxVolume,
      );
    }

    if (settings.showMa2) {

      _drawLine(
        canvas,
        size,
        ma2Values,
        settings.ma2Color,
        maxVolume,
      );
    }
  }

  void _drawVolumeLabels(
      Canvas canvas,
      Size size,
      List<double?> ma1Values,
      List<double?> ma2Values,
      ) {

    double x = 8;

    final lastIndex =
    (viewport.visibleEndIndex - 1)
        .clamp(
      0,
      candles.length - 1,
    );

    final lastVolume =
        candles[lastIndex].volume;

    final ma1 =
    ma1Values[lastIndex];

    final ma2 =
    ma2Values[lastIndex];

    final labels = [

      (
      'VOL: ${lastVolume.toStringAsFixed(4)}',
      settings.upColor,
      ),

      (
      'MA(${settings.ma1Period}): '
          '${ma1?.toStringAsFixed(4) ?? '--'}',
      settings.ma1Color,
      ),

      (
      'MA(${settings.ma2Period}): '
          '${ma2?.toStringAsFixed(4) ?? '--'}',
      settings.ma2Color,
      ),
    ];

    for (final item in labels) {

      final textPainter =
      TextPainter(
        text: TextSpan(
          text: item.$1,
          style: TextStyle(
            color: item.$2,
            fontSize: 11,
            fontWeight: FontWeight.w500,
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

  void _drawLine(
      Canvas canvas,
      Size size,
      List<double?> values,
      Color color,
      double maxVolume,
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
      ValueConverter.valueToY(
        value: value,
        minValue: 0,
        maxValue: maxVolume,
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
      covariant VolumePainter oldDelegate,
      ) {

    return oldDelegate.candles !=
        candles ||
        oldDelegate.viewport !=
            viewport ||
        oldDelegate.settings !=
            settings;
  }
}