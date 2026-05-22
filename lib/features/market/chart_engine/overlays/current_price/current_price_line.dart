import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/chart_math.dart';

class CurrentPriceLine extends StatelessWidget {
  final List<CandleModel> candles;

  final double chartHeight;

  final double minPrice;

  final double maxPrice;

  const CurrentPriceLine({
    super.key,

    required this.candles,

    required this.chartHeight,

    required this.minPrice,

    required this.maxPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return const SizedBox();
    }

    final lastCandle = candles.last;

    final currentPrice = lastCandle.close;



    final y = ChartMath.priceToY(
      price: currentPrice,

      minPrice: minPrice,

      maxPrice: maxPrice,

      height: chartHeight,
    );

    final isBull = lastCandle.close >= lastCandle.open;

    return Positioned(
      left: 0,
      right: 0,

      top: y,

      child: IgnorePointer(
        child: Container(
          height: 1,

          color: isBull ? AppColors.green : AppColors.red,
        ),
      ),
    );
  }
}
