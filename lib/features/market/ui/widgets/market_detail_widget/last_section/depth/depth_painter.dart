import 'dart:math';
import 'package:flutter/material.dart';

import 'depth_point.dart';

class DepthPainter extends CustomPainter {
  final List<DepthPoint> bids;
  final List<DepthPoint> asks;

  DepthPainter({
    required this.bids,
    required this.asks,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (bids.isEmpty || asks.isEmpty) return;

    final maxBidVolume = bids.last.volume;
    final maxAskVolume = asks.last.volume;

    if (maxBidVolume <= 0 || maxAskVolume <= 0) {
      return;
    }

    final centerX = size.width / 2;

    final bidCurve = <Offset>[];
    final askCurve = <Offset>[];

    // =========================
    // BIDS — LEFT SIDE
    // =========================

    for (int i = 0; i < bids.length; i++) {
      final p = bids[i];

      final bestBidPrice = bids.first.price;
      final lowestBidPrice = bids.last.price;

      final priceRange =
          bestBidPrice - lowestBidPrice;

      final progress = priceRange <= 0
          ? 0.0
          : ((bestBidPrice - p.price) / priceRange)
          .clamp(0.0, 1.0);

      final visualProgress = sqrt(progress);

      final x =
          centerX - (centerX * visualProgress);

      final normalizedVolume =
      (p.volume / maxBidVolume)
          .clamp(0.0, 1.0);

      // Center ko bottom se thoda upar rakha hai.
      const centerLift = 66.0;

      final y =
          (size.height - centerLift) -
              (normalizedVolume *
                  (size.height - centerLift));

      bidCurve.add(
        Offset(
          x,
          y.clamp(0.0, size.height),
        ),
      );
    }

    // =========================
    // ASKS — RIGHT SIDE
    // =========================

    for (int i = 0; i < asks.length; i++) {
      final p = asks[i];

      final bestAskPrice = asks.first.price;
      final highestAskPrice = asks.last.price;

      final priceRange =
          highestAskPrice - bestAskPrice;

      final progress = priceRange <= 0
          ? 0.0
          : ((p.price - bestAskPrice) / priceRange)
          .clamp(0.0, 1.0);

      final visualProgress = sqrt(progress);

      final x =
          centerX + (centerX * visualProgress);

      final normalizedVolume =
      (p.volume / maxAskVolume)
          .clamp(0.0, 1.0);

      // Same center height as bids.
      const centerLift = 66.0;

      final y =
          (size.height - centerLift) -
              (normalizedVolume *
                  (size.height - centerLift));

      askCurve.add(
        Offset(
          x,
          y.clamp(0.0, size.height),
        ),
      );
    }

    // =========================
    // SMOOTH CURVES
    // =========================

    final bidPath =
    _smoothPath(
      bidCurve,
      centerAtEnd: true,
    );

    final askPath =
    _smoothPath(
      askCurve,
      centerAtEnd: false,
    );

    // =========================
    // FILLS
    // =========================

    final bidFill = Path.from(bidPath)
      ..lineTo(
        bidCurve.last.dx,
        size.height,
      )
      ..lineTo(
        bidCurve.first.dx,
        size.height,
      )
      ..close();

    final askFill = Path.from(askPath)
      ..lineTo(
        askCurve.last.dx,
        size.height,
      )
      ..lineTo(
        askCurve.first.dx,
        size.height,
      )
      ..close();

    // =========================
    // BID FILL
    // =========================

    canvas.drawPath(
      bidFill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.withOpacity(.45),
            Colors.green.withOpacity(.08),
          ],
        ).createShader(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
        ),
    );

    // =========================
    // ASK FILL
    // =========================

    canvas.drawPath(
      askFill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red.withOpacity(.45),
            Colors.red.withOpacity(.08),
          ],
        ).createShader(
          Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
        ),
    );

    // =========================
    // CENTER LINE
    // =========================

    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      Paint()
        ..color = Colors.grey.withOpacity(.15)
        ..strokeWidth = 1,
    );

    // =========================
    // SHADOW
    // =========================

    final shadowPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      bidPath,
      shadowPaint,
    );

    canvas.drawPath(
      askPath,
      shadowPaint,
    );

    // =========================
    // MAIN BID LINE
    // =========================

    canvas.drawPath(
      bidPath,
      Paint()
        ..color = const Color(0xff00C087)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    // =========================
    // MAIN ASK LINE
    // =========================

    canvas.drawPath(
      askPath,
      Paint()
        ..color = const Color(0xffF6465D)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  // =========================
  // SMOOTH BEZIER PATH
  // =========================

  Path _smoothPath(
      List<Offset> points, {
        required bool centerAtEnd,
      }) {
    final path = Path();

    if (points.isEmpty) {
      return path;
    }

    if (points.length == 1) {
      path.moveTo(
        points.first.dx,
        points.first.dy,
      );
      return path;
    }

    // =========================
    // RAW POINT SMOOTHING
    // =========================

    final smoothed = <Offset>[];

    const radius = 4;

    for (int i = 0; i < points.length; i++) {
      double total = 0;
      double weightTotal = 0;

      for (int j = -radius; j <= radius; j++) {
        final index = i + j;

        if (index < 0 || index >= points.length) {
          continue;
        }

        final distance = j.abs();
        final weight = radius + 1 - distance;

        total += points[index].dy * weight;
        weightTotal += weight;
      }

      smoothed.add(
        Offset(
          points[i].dx,
          total / weightTotal,
        ),
      );
    }

    // Keep original endpoints.
    smoothed[0] = points[0];
    smoothed[smoothed.length - 1] =
    points[points.length - 1];

    // =========================
    // BEZIER CURVE
    // =========================

    path.moveTo(
      smoothed.first.dx,
      smoothed.first.dy,
    );

    for (int i = 0; i < smoothed.length - 1; i++) {
      final p0 = i == 0
          ? smoothed[i]
          : smoothed[i - 1];

      final p1 = smoothed[i];

      final p2 = smoothed[i + 1];

      final p3 = i + 2 < smoothed.length
          ? smoothed[i + 2]
          : p2;

      var cp1 = Offset(
        p1.dx + (p2.dx - p0.dx) / 6,
        p1.dy + (p2.dy - p0.dy) / 6,
      );

      var cp2 = Offset(
        p2.dx - (p3.dx - p1.dx) / 6,
        p2.dy - (p3.dy - p1.dy) / 6,
      );

      // =========================
      // CENTER U
      // =========================
      //
      // BOTH BID AND ASK START
      // FROM THE CENTER.
      //
      // So the first segment needs
      // a horizontal tangent.
      // =========================

      if (i == 0) {
        final dx = p2.dx - p1.dx;

        cp1 = Offset(
          p1.dx + (dx * 0.45),
          p1.dy,
        );
      }

      path.cubicTo(
        cp1.dx,
        cp1.dy,
        cp2.dx,
        cp2.dy,
        p2.dx,
        p2.dy,
      );
    }

    return path;
  }
  @override
  bool shouldRepaint(
      covariant DepthPainter oldDelegate,
      ) {
    return true;
  }
}