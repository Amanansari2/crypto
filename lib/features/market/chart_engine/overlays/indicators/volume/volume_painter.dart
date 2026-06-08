import 'package:flutter/material.dart';

import '../../../core/models/candle_model.dart';

class VolumePainter extends CustomPainter {

  final List<CandleModel> candles;

  VolumePainter({
    required this.candles,
  });

  @override
  void paint(
      Canvas canvas,
      Size size,
      ) {

    if (candles.isEmpty) {
      return;
    }

    final paint = Paint()
      ..strokeWidth = 2;

    final maxVolume =
    candles
        .map((e) => e.volume)
        .reduce(
          (a, b) => a > b ? a : b,
    );

    if (maxVolume <= 0) {
      return;
    }

    final barWidth =
        size.width / candles.length;

    for (
    int i = 0;
    i < candles.length;
    i++
    ) {

      final candle =
      candles[i];

      final heightFactor =
          candle.volume / maxVolume;

      final barHeight =
          size.height * heightFactor;

      final left =
          i * barWidth;

      final rect = Rect.fromLTWH(
        left,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRect(
        rect,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant VolumePainter oldDelegate,
      ) {

    return oldDelegate.candles != candles;
  }
}