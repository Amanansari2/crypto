import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../providers/viewport_provider.dart';
import '../../providers/visible_price_provider.dart';
import 'high_low_painter.dart';

class HighLowOverlay extends ConsumerWidget {
  final List<CandleModel> candles;

  const HighLowOverlay({super.key, required this.candles});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewport = ref.watch(viewportProvider);

    final visiblePrice = ref.watch(visiblePriceProvider);

    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,

        painter: HighLowPainter(
          candles: candles,

          viewport: viewport,

          minPrice: visiblePrice.minPrice,

          maxPrice: visiblePrice.maxPrice,
        ),
      ),
    );
  }
}
