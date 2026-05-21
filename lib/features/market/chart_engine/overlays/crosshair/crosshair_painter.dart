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
      ..strokeWidth = 0.5
      ..isAntiAlias = false;

    /// 🔥 vertical
    canvas.drawLine(Offset(pos.dx, 0), Offset(pos.dx, size.height), crossPaint);

    /// 🔥 horizontal
    canvas.drawLine(Offset(0, pos.dy), Offset(size.width, pos.dy), crossPaint);

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

  @override
  bool shouldRepaint(covariant CrosshairPainter old) {
    return old.crosshair != crosshair;
  }
}
