import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final BuildContext context;

  GridPainter({required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.chartGrid(context).withOpacity(0.10)
      ..strokeWidth = 0.7
      ..isAntiAlias = false;

    /// 🔥 3 inner horizontal lines
    const horizontalLines = ChartConfig.horizontalGridCount;

    for (int i = 1; i <= horizontalLines; i++) {
      final y = (size.height / (horizontalLines + 1)) * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    /// 🔥 3 inner vertical lines
    const verticalLines = ChartConfig.verticalGridCount;

    for (int i = 1; i <= verticalLines; i++) {
      final x = (size.width / (verticalLines + 1)) * i;

      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
