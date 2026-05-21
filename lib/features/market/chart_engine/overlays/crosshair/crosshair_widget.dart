import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../providers/crosshair_provider.dart';
import 'crosshair_painter.dart';

class CrosshairWidget extends ConsumerWidget {
  final List<CandleModel> candles;

  const CrosshairWidget({super.key, required this.candles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crosshair = ref.watch(crosshairProvider);

    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          size: Size.infinite,

          painter: CrosshairPainter(crosshair: crosshair),
        ),
      ),
    );
  }
}
