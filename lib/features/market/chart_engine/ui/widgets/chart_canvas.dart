import 'package:crypto_app/features/market/chart_engine/overlays/crosshair/crosshair_widget.dart';
import 'package:crypto_app/features/market/chart_engine/providers/chart_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../overlays/high_low/high_low_overlay.dart';
import '../../providers/candle_provider.dart';
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

  // double _startZoom = 1;
  // double _startScroll = 0;
  // Offset _startFocal = Offset.zero;
  // bool _initialized = false;
  // int? _lastHapticIndex;

  @override
  Widget build(BuildContext context) {
    final viewport = ref.watch(viewportProvider);
    final visiblePrice = ref.watch(visiblePriceProvider);
    final isLoadingMore = ref.watch(candleLoadingMoreProvider,);

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = constraints.maxHeight;

        WidgetsBinding.instance.addPostFrameCallback((_){
          ref.read(chartWidthProvider.notifier).update(chartWidth);
        });


        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   if (_initialized) return;
        //
        //   final screenWidth = chartWidth;
        //
        //   final totalWidth = widget.candles.length * viewport.candleWidth;
        //
        //   final initialScroll = (totalWidth - screenWidth)
        //       .clamp(0, double.infinity)
        //       .toDouble();
        //
        //   ref
        //       .read(viewportProvider.notifier)
        //       .setScroll(initialScroll, widget.candles.length, screenWidth);
        //
        //   _initialized = true;
        // });

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
