
import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/chart_math.dart';
import '../../providers/viewport_provider.dart';

class CurrentPriceLabel extends ConsumerWidget {

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
  Widget build(BuildContext context,
      WidgetRef ref,) {

    if (candles.isEmpty) {
      return const SizedBox();
    }

    final viewport =
    ref.watch(viewportProvider);

    final notifier =
    ref.read(
      viewportProvider.notifier,
    );

    final lastCandle =
        candles.last;

    final currentPrice =
        lastCandle.close;

    final y =
    ChartMath.priceToY(

      price: currentPrice,

      minPrice: minPrice,

      maxPrice: maxPrice,

      height: chartHeight,
    );

    final isBull =
        lastCandle.close >=
            lastCandle.open;

    final latestVisible =
        viewport.visibleEndIndex >=
            candles.length - 2;

    return Positioned(

      right:
      latestVisible
          ? -1
          : 52,

      top:
      (y - 13).clamp(
        4.0,
        chartHeight - 28,
      ),

      child: GestureDetector(

        onTap: latestVisible
            ? null
            : () {
          final screenWidth =
              MediaQuery
                  .of(context)
                  .size
                  .width;

          final targetScroll =

              (
                  (candles.length + ChartConfig.rightSideExtraCandles) *
                      viewport.candleWidth
              ) -
                  screenWidth;

          notifier.setScroll(

            targetScroll,

            candles.length,

            screenWidth,
          );
        },

        child: Container(

          padding:
          const EdgeInsets.symmetric(

            horizontal: 4,
            vertical: 2,
          ),

          decoration: BoxDecoration(

            color:
            isBull
                ? AppColors.green
                : AppColors.red,

            borderRadius:
            BorderRadius.circular(4),
          ),

          child: Row(

            mainAxisSize: MainAxisSize.min,

            children: [
              Text(
                currentPrice.toStringAsFixed(2),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!latestVisible) ...[
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 8,
                ),

              ],
            ],
          ),
        ),
      ),
    );
  }
}
