import 'package:flutter/material.dart';

import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../painters/time_axis_painter.dart';

class TimeAxis extends StatelessWidget {
  final List<CandleModel> candles;

  final ChartViewport viewport;

  const TimeAxis({super.key, required this.candles, required this.viewport});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 14,

      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,

          painter: TimeAxisPainter(candles: candles, viewport: viewport),
        ),
      ),
    );
  }
}
