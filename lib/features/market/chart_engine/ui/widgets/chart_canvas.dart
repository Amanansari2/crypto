import 'package:crypto_app/features/market/chart_engine/providers/chart_width_provider.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/ema/ema_data_provider.dart';
import 'package:crypto_app/features/market/chart_engine/providers/indicators/ema/ema_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../overlays/high_low/high_low_overlay.dart';
import '../../overlays/indicators/boll/boll_painter.dart';
import '../../overlays/indicators/ema/ema_painter.dart';
import '../../providers/candle_provider.dart';
import '../../providers/indicators/boll/boll_data_provider.dart';
import '../../providers/indicators/boll/boll_provider.dart';
import '../../providers/viewport_provider.dart';
import '../../providers/visible_price_provider.dart';
import '../painters/candel_painter.dart';
import '../painters/grid_painter.dart';

class ChartCanvas extends ConsumerStatefulWidget {
  final List<CandleModel> candles;

  const ChartCanvas({super.key, required this.candles});

  @override
  ConsumerState<ChartCanvas> createState() => _ChartCanvasState();
}

class _ChartCanvasState extends ConsumerState<ChartCanvas> {


  @override
  Widget build(BuildContext context) {
    final viewport = ref.watch(viewportProvider);
    final visiblePrice = ref.watch(visiblePriceProvider);
    final isLoadingMore = ref.watch(candleLoadingMoreProvider,);
    final emaData = ref.watch(emaDataProvider);
    final emaSettings = ref.watch(emaProvider);
    final bollData =ref.watch(bollDataProvider);
    final bollSettings = ref.watch(bollProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = constraints.maxHeight;

        WidgetsBinding.instance.addPostFrameCallback((_){
          ref.read(chartWidthProvider.notifier).update(chartWidth);
        });


        final startIndex = (viewport.scrollX / viewport.candleWidth).floor();

        final visibleCount = (chartWidth / viewport.candleWidth).ceil();

        final endIndex = startIndex + visibleCount + 2;

        final safeStart = startIndex.clamp(0, widget.candles.length);

        final safeEnd = endIndex.clamp(0, widget.candles.length);

        if (safeStart < safeEnd) {
          double maxPrice = double.negativeInfinity;

          double minPrice = double.infinity;

          for (int i = safeStart; i < safeEnd; i++) {
            final candle = widget.candles[i];

            if (candle.high > maxPrice) {
              maxPrice = candle.high;
            }

            if (candle.low < minPrice) {
              minPrice = candle.low;
            }
          }

          for (final config in emaSettings) {

            if (!config.enabled) {
              continue;
            }

            final values =
            emaData.getPeriod(
              config.period,
            );

            if (values == null) {
              continue;
            }

            for (
            int i = safeStart;
            i < safeEnd && i < values.length;
            i++
            ) {

              final value = values[i];

              if (value == null) {
                continue;
              }

              if (value > maxPrice) {
                maxPrice = value;
              }

              if (value < minPrice) {
                minPrice = value;
              }
            }
          }

          if (bollSettings.showUpper) {

            for (
            int i = safeStart;
            i < safeEnd &&
                i < bollData.upper.length;
            i++
            ) {

              final value = bollData.upper[i];

              if (value == null) {
                continue;
              }

              if (value > maxPrice) {
                maxPrice = value;
              }

              if (value < minPrice) {
                minPrice = value;
              }
            }
          }

          if (bollSettings.showMiddle) {

            for (
            int i = safeStart;
            i < safeEnd &&
                i < bollData.middle.length;
            i++
            ) {

              final value = bollData.middle[i];

              if (value == null) {
                continue;
              }

              if (value > maxPrice) {
                maxPrice = value;
              }

              if (value < minPrice) {
                minPrice = value;
              }
            }
          }

          if (bollSettings.showLower) {

            for (
            int i = safeStart;
            i < safeEnd &&
                i < bollData.lower.length;
            i++
            ) {

              final value = bollData.lower[i];

              if (value == null) {
                continue;
              }

              if (value > maxPrice) {
                maxPrice = value;
              }

              if (value < minPrice) {
                minPrice = value;
              }
            }
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final range = maxPrice - minPrice;

            final padding = range * 0.08;

            ref
                .read(visiblePriceProvider.notifier)
                .update(
              minPrice: minPrice - padding,

              maxPrice: maxPrice + padding,
            );
          });
        }

        return Stack(
          children: [
            /// 🔥 background grid
            RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: GridPainter(context: context, drawVertical: false),
              ),
            ),

            RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: CandlePainter(
                  candles: widget.candles,
                  viewport: viewport,
                  minPrice: visiblePrice.minPrice,
                  maxPrice: visiblePrice.maxPrice,
                ),
              ),
            ),

            // RepaintBoundary(
            //   child: CustomPaint(
            //     size: Size.infinite,
            //     painter: EmaPainter(
            //       candles: widget.candles,
            //       emaData: emaData,
            //       viewport: viewport,
            //       settings: emaSettings,
            //       minPrice: visiblePrice.minPrice,
            //       maxPrice: visiblePrice.maxPrice,
            //     ),
            //   ),
            // ),

            RepaintBoundary(
              child: CustomPaint(
                size: Size.infinite,
                painter: BollPainter(
                  candles: widget.candles,

                  bollData: bollData,

                  viewport: viewport,

                  settings: bollSettings,

                  minPrice:
                  visiblePrice.minPrice,

                  maxPrice:
                  visiblePrice.maxPrice,
                ),
              ),
            ),

            HighLowOverlay(candles: widget.candles,),


            if (isLoadingMore)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
