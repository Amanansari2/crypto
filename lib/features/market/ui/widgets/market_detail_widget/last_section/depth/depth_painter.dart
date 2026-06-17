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

    // final maxVolume = [
    //   ...bids.map((e) => e.volume),
    //   ...asks.map((e) => e.volume),
    // ].reduce((a, b) => a > b ? a : b);

    final maxVolume = max(
      bids.last.volume,
      asks.last.volume,
    );

    final maxBidVolume =
        bids.last.volume;

    final maxAskVolume =
        asks.last.volume;

    final centerX = size.width / 2;

    final bidCurve = <Offset>[];
    final askCurve = <Offset>[];

    /// BIDS (LEFT)
    for (int i = 0; i < bids.length; i++) {
      final p = bids[i];

      final x =
          centerX * (i / (bids.length - 1));

      final y =
          size.height -
              ((p.volume / maxVolume) *
                  size.height);

      bidCurve.add(
        Offset(x, y),
      );
    }

    /// ASKS (RIGHT)
    for (int i = 0; i < asks.length; i++) {
      final p = asks[i];

      final x =
          centerX +
              centerX *
                  (i / (asks.length - 1));

      final y =
          size.height -
              ((p.volume / maxVolume) *
                  size.height);

      askCurve.add(
        Offset(x, y),
      );
    }

    final bidPath = _stepPath(bidCurve);
    final askPath = _stepPath(askCurve);

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

    /// CENTER LINE
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      Paint()
        ..color = Colors.grey.withOpacity(.15)
        ..strokeWidth = 1,
    );

    /// SHADOW STROKE
    canvas.drawPath(
      bidPath,
      Paint()
        ..color = Colors.grey.shade600
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    canvas.drawPath(
      askPath,
      Paint()
        ..color = Colors.grey.shade600
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
    );

    /// MAIN STROKE
    canvas.drawPath(
      bidPath,
      Paint()
        ..color = const Color(0xff00C087)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );

    canvas.drawPath(
      askPath,
      Paint()
        ..color = const Color(0xffF6465D)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }


  Path _stepPath(List<Offset> points) {
    final path = Path();

    if (points.isEmpty) return path;

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (int i = 1; i < points.length; i++) {
      path.lineTo(
        points[i].dx,
        points[i - 1].dy,
      );

      path.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    return path;
  }

  // Path _smoothPath(
  //     List<Offset> points,
  //     ) {
  //   final path = Path();
  //
  //   if (points.isEmpty) {
  //     return path;
  //   }
  //
  //   path.moveTo(
  //     points.first.dx,
  //     points.first.dy,
  //   );
  //
  //   for (int i = 1; i < points.length; i++) {
  //     final prev = points[i - 1];
  //     final curr = points[i];
  //
  //     final mx =
  //         (prev.dx + curr.dx) / 2;
  //
  //     final my =
  //         (prev.dy + curr.dy) / 2;
  //
  //     path.quadraticBezierTo(
  //       prev.dx,
  //       prev.dy,
  //       mx,
  //       my,
  //     );
  //   }
  //
  //   path.lineTo(
  //     points.last.dx,
  //     points.last.dy,
  //   );
  //
  //   return path;
  // }

  @override
  bool shouldRepaint(
      covariant DepthPainter oldDelegate,
      ) {
    return true;
  }
}