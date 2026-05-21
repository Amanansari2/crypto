import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/price_converter.dart';
import '../../providers/crosshair_provider.dart';
import '../../providers/visible_price_provider.dart';

class AxisPriceLabel extends ConsumerWidget {
  final List<CandleModel> candles;
  final double chartHeight;
  final double chartWidth;

  const AxisPriceLabel({
    super.key,
    required this.candles,
    required this.chartHeight,
    required this.chartWidth,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crosshair = ref.watch(crosshairProvider);

    final visibleRange = ref.watch(visiblePriceProvider);

    if (!crosshair.visible || crosshair.position == null) {
      return const SizedBox();
    }

    final minPrice = visibleRange.minPrice;

    final maxPrice = visibleRange.maxPrice;

    final price = PriceConverter.yToPrice(
      y: crosshair.position!.dy,

      minPrice: minPrice,

      maxPrice: maxPrice,

      height: chartHeight,
    );

    const labelHeight = 24.0;

    final labelTop = (crosshair.position!.dy - (labelHeight / 2)).clamp(
      4.0,
      chartHeight - labelHeight - 4.0,
    );

    return Align(
      alignment: Alignment.topRight,

      child: Transform.translate(
        offset: Offset(0, labelTop),

        child: Container(
          constraints: const BoxConstraints(maxHeight: labelHeight),

          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),

          decoration: BoxDecoration(
            color: Colors.black,

            borderRadius: BorderRadius.circular(4),

            border: Border.all(color: Colors.white24),
          ),

          child: Text(
            price.toStringAsFixed(2),

            style: const TextStyle(color: AppColors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
