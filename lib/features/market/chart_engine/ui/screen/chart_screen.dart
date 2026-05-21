import 'package:crypto_app/features/market/chart_engine/overlays/price_labels/axis_price_label.dart';
import 'package:crypto_app/features/market/chart_engine/providers/viewport_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/chart_axis.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/time_axis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../overlays/crosshair/crosshair_widget.dart';
import '../../providers/candle_provider.dart';
import '../widgets/chart_canvas.dart';

class CustomChartScreen extends ConsumerWidget {
  final bool dark;

  const CustomChartScreen({
    super.key,
    required this.dark
  });

  @override
  Widget build(BuildContext context,
      WidgetRef ref,) {
    final candlesAsync =
    ref.watch(candleProvider);

    return
      Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),

          color: dark
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.white,

          border: Border.all(
            color: dark
                ? AppColors.blue.withOpacity(0.4)
                : Colors.grey.withOpacity(0.4),
          ),
        ),

        child: candlesAsync.when(

          loading: () {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          },

          error: (e, _) {

            return Center(
              child: Text(
                e.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },

          data: (candles) {
            return Column(

              children: [

                /// 🔥 CHART + PRICE AXIS
                Expanded(

                  child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ChartCanvas(
                                    candles: candles,
                                  ),
                                ),

                                ChartAxis(
                                  candles: candles,
                                  viewport: ref.watch(viewportProvider),
                                  chartWidth: constraints.maxWidth - 40,
                                )
                              ],
                            ),

                            Positioned.fill(

                              right: 40,

                              child: CrosshairWidget(
                                candles: candles,
                              ),
                            ),

                            AxisPriceLabel(
                              candles: candles,
                              chartHeight: constraints.maxHeight,
                              chartWidth: constraints.maxWidth - 40,
                            )
                          ],
                        );
                      }
                  ),
                ),
                TimeAxis(
                    candles: candles,
                    viewport: ref.watch(viewportProvider))
              ],
            );
          },
        ),
      );
  }
}