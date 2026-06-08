import 'package:crypto_app/features/market/chart_engine/overlays/indicators/volume/volume_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/candle_provider.dart';

class VolumeWidget extends ConsumerWidget {
  const VolumeWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {
    final candles =
        ref.watch(candleProvider).value ?? [];

    return CustomPaint(
      size: Size.infinite,
      painter: VolumePainter(
        candles: candles,
      ),
    );
  }
}