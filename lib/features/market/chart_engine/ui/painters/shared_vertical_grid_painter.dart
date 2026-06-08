import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/constants/chart_config.dart';

class SharedVerticalGridPainter extends CustomPainter {

  final BuildContext context;
  final double mainChartHeight;

  SharedVerticalGridPainter({
    required this.context,
    required this.mainChartHeight
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    final paint = Paint()
      ..color = AppColors.chartGrid(context).withOpacity(0.10)
      ..strokeWidth = 0.7
      ..isAntiAlias = false;

    const verticalLines =
        ChartConfig.verticalGridCount;

    for (int i = 1; i <= verticalLines; i++) {

      final x =
          (size.width / (verticalLines + 1)) * i;

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, mainChartHeight),
        paint,
      );

      canvas.drawLine(
        Offset(
          x,
          mainChartHeight + ChartConfig.timeAxisHeight,
        ),
        Offset(
          x,
          size.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant CustomPainter oldDelegate,
      ) {
    return false;
  }
}