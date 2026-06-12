import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../../core/models/candle_model.dart';
import '../../core/models/viewport_model.dart';
import '../painters/axis_painter.dart';

class ChartAxis extends StatelessWidget {
  final List<CandleModel> candles;

  final ChartViewport viewport;
  final double chartWidth;

  const ChartAxis({
    super.key,
    required this.chartWidth,
    required this.candles,
    required this.viewport,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 40,
      height: double.infinity,

      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,
          painter: AxisPainter(
            chartWidth: chartWidth,
            candles: candles,
            viewport: viewport,
            textColor: dark ? AppColors.white : Colors.black54
          ),
        ),
      ),
    );
  }
}
