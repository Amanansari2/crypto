import 'package:flutter/material.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/chart_math.dart';

class CurrentPriceLabel extends StatelessWidget {
  final List<CandleModel> candles;

  final double chartHeight;

  final double minPrice;

  final double maxPrice;

  const CurrentPriceLabel({
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
      right: 0,

      top: (y - 12).clamp(4.0, chartHeight - 28),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),

        decoration: BoxDecoration(
          color: isBull ? AppColors.green : AppColors.red,

          borderRadius: BorderRadius.circular(4),
        ),

        child: Text(
          currentPrice.toStringAsFixed(2),

          style: const TextStyle(
            color: Colors.white,

            fontSize: 10,

            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
