import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import 'amount_distribution_chart.dart';

class DistributionGraph extends StatelessWidget {
  final DistributionType type;
  final bool isRatio;

  const DistributionGraph({
    super.key,
    required this.type,
    this.isRatio = false
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: CustomPaint(
        painter: DistributionPainter(
            type,
        isRatio : isRatio
        ),
      ),
    );
  }
}

class DistributionPainter extends CustomPainter {
  final DistributionType type;
  final bool isRatio;

  DistributionPainter(this.type, {this.isRatio = false});

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 28.0;
    const topPadding = 12.0;
    const bottomPadding = 22.0;
    const rightPadding = 12.0;

    final axisPaint = Paint()
      ..color = Colors.grey.shade500
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color =  AppColors.blue
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color =  Colors.blue;

    final chartWidth =
        size.width - leftPadding - rightPadding;

    final chartHeight =
        size.height - topPadding - bottomPadding;

    final x1 = leftPadding + chartWidth * 0.05;
    final x2 = leftPadding + chartWidth * 0.30;
    final x3 = leftPadding + chartWidth * 0.55;
    final x4 = leftPadding + chartWidth * 0.80;
    final x5 = leftPadding + chartWidth * 0.98;

    final yTop = topPadding + chartHeight * 0.15;
    final yMid = topPadding + chartHeight * 0.50;
    final yLow = topPadding + chartHeight * 0.85;

    // Axis
    canvas.drawLine(
      Offset(leftPadding, topPadding),
      Offset(leftPadding, size.height - bottomPadding),
      axisPaint,
    );

    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width - rightPadding,
          size.height - bottomPadding),
      axisPaint,
    );

    // X axis arrow
    canvas.drawLine(
      Offset(
        size.width - rightPadding - 6,
        size.height - bottomPadding - 4,
      ),
      Offset(
        size.width - rightPadding,
        size.height - bottomPadding,
      ),
      axisPaint,
    );

    canvas.drawLine(
      Offset(
        size.width - rightPadding - 6,
        size.height - bottomPadding + 4,
      ),
      Offset(
        size.width - rightPadding,
        size.height - bottomPadding,
      ),
      axisPaint,
    );

    // Y axis arrow
    canvas.drawLine(
      Offset(leftPadding - 4, topPadding + 6),
      Offset(leftPadding, topPadding),
      axisPaint,
    );

    canvas.drawLine(
      Offset(leftPadding + 4, topPadding + 6),
      Offset(leftPadding, topPadding),
      axisPaint,
    );

    List<Offset> points = [];

    switch (type) {
      case DistributionType.equal:
        points = [
          Offset(x1, yMid),
          Offset(x2, yMid),
          Offset(x3, yMid),
          Offset(x4, yMid),
          Offset(x5, yMid),
        ];
        break;

      case DistributionType.increasing:
        if (isRatio) {
          points = [
            Offset(x1, yLow),
            Offset(x2, yLow - 5),
            Offset(x3, yMid + 10),
            Offset(x4, yMid - 15),
            Offset(x5, yTop),
          ];
        } else {
          points = [
            Offset(x1, yLow),
            Offset(x2, yLow - 12),
            Offset(x3, yLow - 24),
            Offset(x4, yLow - 36),
            Offset(x5, yLow - 48),
          ];
        }
        break;

      case DistributionType.decreasing:
        if (isRatio) {
          points = [
            Offset(x1, yTop),
            Offset(x2, yMid - 10),
            Offset(x3, yMid + 8),
            Offset(x4, yLow - 2),
            Offset(x5, yLow),
          ];
        } else {
          points = [
            Offset(x1, yTop),
            Offset(x2, yTop + 12),
            Offset(x3, yTop + 24),
            Offset(x4, yTop + 36),
            Offset(x5, yTop + 48),
          ];
        }
        break;

      case DistributionType.random:
        points = [
          Offset(x1, yLow),
          Offset(x2, yTop + 15),
          Offset(x3, yMid + 10),
          Offset(x4, yTop),
          Offset(x5, yMid + 5),
        ];
        break;
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];

      final controlX =
          (prev.dx + current.dx) / 2;

      path.quadraticBezierTo(
        controlX,
        prev.dy,
        current.dx,
        current.dy,
      );
    }


    _drawDashedPath(
      canvas,
      path,
      linePaint,
    );



    final greyPaint = Paint()
      ..color = Colors.blue;


    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(
        points[i],
        2.5,
       greyPaint,
      );
    }

    _drawText(
      canvas,
      'Amount',
      const Offset(2, 0),
    );

    _drawText(
      canvas,
      'Price',
      Offset(
        size.width - 35,
        size.height - 16,
      ),
    );
  }

  void _drawDashedPath(
      Canvas canvas,
      Path source,
      Paint paint,
      ) {
    for (final metric in source.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            distance + 4,
          ),
          paint,
        );

        distance += 8;
      }
    }
  }

  void _drawText(
      Canvas canvas,
      String text,
      Offset offset,
      ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}