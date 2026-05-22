import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/chart_math.dart';
import '../../providers/viewport_provider.dart';

class CurrentPriceLine extends ConsumerWidget {

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
  Widget build(BuildContext context,
      WidgetRef ref,) {

    if (candles.isEmpty) {
      return const SizedBox();
    }

    final viewport =
    ref.watch(viewportProvider);

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

      left: 0,
      right: 0,

      top: y,

      child: IgnorePointer(

        child:

        latestVisible

            ? Container(

          height: 1,

          color:
          isBull
              ? AppColors.green
              : AppColors.red,
        )

            : Row(

          children: List.generate(

            80,

                (index) {
              return Expanded(

                child: Container(

                  height: 1,

                  color:

                  index.isEven

                      ? (
                      isBull
                          ? AppColors.green
                          : AppColors.red
                  )

                      : Colors.transparent,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}