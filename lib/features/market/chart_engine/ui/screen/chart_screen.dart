import 'package:crypto_app/features/market/chart_engine/core/constants/chart_config.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/indicators/indicator_host.dart';
import 'package:crypto_app/features/market/chart_engine/overlays/price_labels/axis_price_label.dart';
import 'package:crypto_app/features/market/chart_engine/providers/viewport_provider.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/chart_axis.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/chart_gesture_layer.dart';
import 'package:crypto_app/features/market/chart_engine/ui/widgets/time_axis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../overlays/crosshair/crosshair_widget.dart';
import '../../overlays/current_price/current_price_label.dart';
import '../../overlays/current_price/current_price_line.dart';
import '../../overlays/price_labels/time_label.dart';
import '../../overlays/tooltip/chart_tooltip.dart';
import '../../providers/candle_provider.dart';
import '../../providers/visible_price_provider.dart';
import '../widgets/chart_canvas.dart';

class CustomChartScreen extends ConsumerStatefulWidget {
  final String symbol;

  const CustomChartScreen({
    super.key,
    required this.symbol
  });

  @override
  ConsumerState<CustomChartScreen>
  createState() =>
      _CustomChartScreenState();
}

class _CustomChartScreenState extends ConsumerState<CustomChartScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      ref
          .read(candleProvider.notifier)
          .changeSymbol(widget.symbol);
    });
  }

  @override
  void didUpdateWidget(covariant CustomChartScreen oldWidget,) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.symbol != widget.symbol) {
      ref
          .read(candleProvider.notifier)
          .changeSymbol(widget.symbol);
    }
  }

  @override
  Widget build(BuildContext context,) {

    final dark = Theme.of(context).brightness == Brightness.dark;


    final candlesAsync =
    ref.watch(candleProvider);

    return
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ChartConfig.chartRadius),

          color: dark
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.white,
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
            return ChartGestureLayer(
              candles: candles,
              child: Column(
                children: [
                  /// 🔥 CHART + PRICE AXIS
                  Expanded(
              
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.withOpacity(0.25),
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.25),
                          ),
                        ),
                      ),
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
                                      chartWidth: constraints.maxWidth -
                                          ChartConfig.axisWidth,
                                    )
                                  ],
                                ),

                                CurrentPriceLine(

                                  candles: candles,

                                  chartHeight:
                                  constraints.maxHeight,

                                  minPrice:
                                  ref
                                      .watch(
                                    visiblePriceProvider,
                                  )
                                      .minPrice,

                                  maxPrice:
                                  ref
                                      .watch(
                                    visiblePriceProvider,
                                  )
                                      .maxPrice,
                                ),
                                ChartTooltip(
                                  candles: candles,
                                ),
                                Positioned.fill(
                                  right: ChartConfig.axisWidth,
                                  child: CrosshairWidget(
                                    candles: candles,
                                  ),
                                ),


                                CurrentPriceLabel(

                                  candles: candles,

                                  chartHeight:
                                  constraints.maxHeight,

                                  minPrice:
                                  ref
                                      .watch(
                                    visiblePriceProvider,
                                  )
                                      .minPrice,

                                  maxPrice:
                                  ref
                                      .watch(
                                    visiblePriceProvider,
                                  )
                                      .maxPrice,
                                ),

                                AxisPriceLabel(
                                  candles: candles,
                                  chartHeight: constraints.maxHeight,
                                  chartWidth: constraints.maxWidth -
                                      ChartConfig.axisWidth,
                                ),


                                TimeLabel(
                                  candles: candles,
                                  chartWidth: constraints.maxWidth -
                                      ChartConfig.axisWidth,
                                ),

                              ],
                            );
                          }
                      ),
                    ),
                  ),
                  TimeAxis(
              
                    candles: candles,
              
                    viewport:
                    ref.watch(
                      viewportProvider,
                    ),
                  ),
              
                  const IndicatorHost()
                ],
              ),
            );
          },
        ),
      );
  }
}