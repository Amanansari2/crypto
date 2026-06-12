import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
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
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: ChartConfig.timeAxisHeight,

      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,

          painter: TimeAxisPainter(candles: candles, viewport: viewport, textColor: dark ? AppColors.white : Colors.black54),
        ),
      ),
    );
  }
}
