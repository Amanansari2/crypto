import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/candle_provider.dart';
import '../../../providers/viewport_provider.dart';
import '../../../providers/indicators/volume/volume_provider.dart';
import 'volume_painter.dart';

class VolumeWidget extends ConsumerWidget {

  const VolumeWidget({
    super.key,
  });

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final candlesAsync =
    ref.watch(candleProvider);

    final viewport =
    ref.watch(viewportProvider);

    final settings =
    ref.watch(volumeProvider);

    return candlesAsync.when(

      loading: () =>
      const SizedBox(),

      error: (_, __) =>
      const SizedBox(),

      data: (candles) {

        return CustomPaint(
          painter: VolumePainter(
            candles: candles,
            viewport: viewport,
            settings: settings,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}