// import 'package:flutter/material.dart';
//
// import '../../providers/crosshair_provider.dart';
//
// class CrosshairPainter extends CustomPainter {
//   final CrosshairState crosshair;
//
//   CrosshairPainter({required this.crosshair});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     if (!crosshair.visible || crosshair.position == null) {
//       return;
//     }
//
//     final pos = crosshair.position!;
//
//     final crossPaint = Paint()
//       ..color = Colors.white54
//       ..strokeWidth = 0.5
//       ..isAntiAlias = false;
//
//     /// 🔥 vertical
//     canvas.drawLine(Offset(pos.dx, 0), Offset(pos.dx, size.height), crossPaint);
//
//     /// 🔥 horizontal
//     canvas.drawLine(Offset(0, pos.dy), Offset(size.width, pos.dy), crossPaint);
//
//     /// 🔥 outer ring
//     canvas.drawCircle(
//       pos,
//       5,
//       Paint()
//         ..color = Colors.white54
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 1
//         ..isAntiAlias = true,
//     );
//
//     /// 🔥 inner dot
//     canvas.drawCircle(
//       pos,
//       2,
//       Paint()
//         ..color = Colors.white
//         ..style = PaintingStyle.fill
//         ..isAntiAlias = true,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CrosshairPainter old) {
//     return old.crosshair != crosshair;
//   }
// }


import 'dart:math';

import 'package:flutter/material.dart';

import '../../providers/crosshair_provider.dart';

class CrosshairPainter extends CustomPainter {
  final CrosshairState crosshair;

  CrosshairPainter({required this.crosshair});

  @override
  void paint(Canvas canvas, Size size) {
    if (!crosshair.visible || crosshair.position == null) {
      return;
    }

    final pos = crosshair.position!;

    final crossPaint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 1
      ..isAntiAlias = false;

    /// 🔥 vertical dashed
    drawDashedLine(
      canvas: canvas,
      start: Offset(pos.dx, 0),
      end: Offset(pos.dx, size.height),
      paint: crossPaint,
    );

    /// 🔥 horizontal dashed
    drawDashedLine(
      canvas: canvas,
      start: Offset(0, pos.dy),
      end: Offset(size.width, pos.dy),
      paint: crossPaint,
    );

    /// 🔥 outer ring
    canvas.drawCircle(
      pos,
      5,
      Paint()
        ..color = Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..isAntiAlias = true,
    );

    /// 🔥 inner dot
    canvas.drawCircle(
      pos,
      2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  void drawDashedLine({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required Paint paint,
    double dashWidth = 8,
    double dashSpace = 4,
  }) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;

    final distance = sqrt(dx * dx + dy * dy);

    final dashCount =
    (distance / (dashWidth + dashSpace)).floor();

    final stepX = dx / distance;
    final stepY = dy / distance;

    for (int i = 0; i < dashCount; i++) {
      final x1 =
          start.dx + (i * (dashWidth + dashSpace)) * stepX;

      final y1 =
          start.dy + (i * (dashWidth + dashSpace)) * stepY;

      final x2 = x1 + dashWidth * stepX;
      final y2 = y1 + dashWidth * stepY;

      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CrosshairPainter old) {
    return old.crosshair != crosshair;
  }
}