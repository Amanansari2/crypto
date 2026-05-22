import 'package:crypto_app/features/market/chart_engine/overlays/crosshair/crosshair_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/engine/crosshair_engine.dart';
import '../../core/engine/gesture_engine.dart';
import '../../core/models/candle_model.dart';
import '../../core/utils/visible_candle_helper.dart';
import '../../providers/candle_provider.dart';
import '../../providers/crosshair_provider.dart';
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
  double _startZoom = 1;
  double _startScroll = 0;
  Offset _startFocal = Offset.zero;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final viewport = ref.watch(viewportProvider);
    final visiblePrice =
    ref.watch(visiblePriceProvider);
    final size = MediaQuery
        .of(context)
        .size;
    final startIndex =
    (viewport.scrollX /
        viewport.candleWidth)
        .floor();

    final visibleCount =
    (size.width /
        viewport.candleWidth)
        .ceil();

    final endIndex =
        startIndex + visibleCount + 2;

    final safeStart =
    startIndex.clamp(
      0,
      widget.candles.length,
    );

    final safeEnd =
    endIndex.clamp(
      0,
      widget.candles.length,
    );

    if (safeStart < safeEnd) {
      double maxPrice =
          double.negativeInfinity;

      double minPrice =
          double.infinity;

      for (
      int i = safeStart;
      i < safeEnd;
      i++
      ) {
        final candle =
        widget.candles[i];

        if (candle.high > maxPrice) {
          maxPrice = candle.high;
        }

        if (candle.low < minPrice) {
          minPrice = candle.low;
        }
      }

      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        ref
            .read(
            visiblePriceProvider.notifier)
            .update(

          minPrice: minPrice,
          maxPrice: maxPrice,
        );
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;

      final screenWidth = MediaQuery.of(context).size.width;

      final totalWidth = widget.candles.length * viewport.candleWidth;

      final initialScroll = (totalWidth - screenWidth)
          .clamp(0, double.infinity)
          .toDouble();

      ref
          .read(viewportProvider.notifier)
          .setScroll(initialScroll, widget.candles.length, screenWidth);

      _initialized = true;
    });

    return LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth;
          final chartHeight = constraints.maxHeight;
          return GestureDetector(
            onScaleStart: (details) {
              final viewport = ref.read(viewportProvider);

              _startZoom = viewport.candleWidth;
              _startScroll = viewport.scrollX;
              _startFocal = details.localFocalPoint;
            },

            // onTapDown: (details) {
            //   ref.read(crosshairProvider.notifier).toggle(details.localPosition);
            // },

            onTapDown: (details) {
              final viewport =
              ref.read(viewportProvider);

              final result =
              CrosshairEngine.snapToCandle(

                localDx:
                details.localPosition.dx,

                scrollX:
                viewport.scrollX,

                candleWidth:
                viewport.candleWidth,

                candleCount:
                widget.candles.length,
              );

              final safeY =
              details.localPosition.dy
                  .clamp(
                8.0,
                size.height - 8.0,
              );

              final notifier =
              ref.read(
                crosshairProvider.notifier,
              );

              /// 🔥 show crosshair
              notifier.toggle(

                Offset(
                  result.snappedX,
                  safeY,
                ),
              );

              /// 🔥 update snapped position
              notifier.update(

                position: Offset(
                  result.snappedX,
                  safeY,
                ),

                candleIndex:
                result.candleIndex,
              );
            },

            onLongPressMoveUpdate: (details) {
              final viewport =
              ref.read(viewportProvider);

              final result =
              CrosshairEngine.snapToCandle(

                localDx:
                details.localPosition.dx,

                scrollX:
                viewport.scrollX,

                candleWidth:
                viewport.candleWidth,

                candleCount:
                widget.candles.length,
              );

              final safeY =
              details.localPosition.dy
                  .clamp(
                8.0,
                size.height - 8.0,
              );

              ref.read(crosshairProvider.notifier)
                  .update(position: Offset(
                  result.snappedX,
                  safeY
              ),

                candleIndex: result.candleIndex,
              );
            },

            onScaleUpdate: (details) {
              final notifier = ref.read(viewportProvider.notifier);

              final viewport = ref.read(viewportProvider);

              /// 🔥 PINCH ZOOM
              /// 🔥 PINCH ZOOM
              if (details.pointerCount == 2) {
                final newZoom =
                GestureEngine.calculateZoom(

                  startZoom: _startZoom,

                  scale: details.scale,
                );

                final newScroll =
                GestureEngine
                    .calculateZoomScroll(

                  startScroll:
                  _startScroll,

                  startZoom:
                  _startZoom,

                  newZoom:
                  newZoom,

                  focalX:
                  _startFocal.dx,
                );

                notifier.setZoom(newZoom);

                notifier.setScroll(

                  newScroll,

                  widget.candles.length,

                  MediaQuery
                      .of(context)
                      .size
                      .width,
                );
              }

              /// 🔥 PAN
              else if (details.pointerCount == 1) {
                final newScroll =
                GestureEngine.calculatePan(

                  currentScroll:
                  viewport.scrollX,

                  deltaX:
                  details.focalPointDelta.dx,
                );

                notifier.setScroll(

                  newScroll,

                  widget.candles.length,

                  MediaQuery
                      .of(context)
                      .size
                      .width,
                );
              }

              final updatedViewport = ref.read(viewportProvider);

              final visible =
              VisibleCandleHelper.calculate(

                scrollX:
                updatedViewport.scrollX,

                candleWidth:
                updatedViewport.candleWidth,

                screenWidth:
                MediaQuery
                    .of(context)
                    .size
                    .width,

                candleCount:
                widget.candles.length,
              );

              notifier.updateVisibleIndexes(

                start:
                visible.startIndex,

                end:
                visible.endIndex,
              );
            },

            onScaleEnd: (_) {
              final viewport = ref.read(viewportProvider);

              final startIndex = (viewport.scrollX / viewport.candleWidth)
                  .floor();

              if (startIndex < 30) {
                ref.read(candleProvider.notifier).loadMore();
              }
            },

            child: Stack(
              children: [

                /// 🔥 background grid
                RepaintBoundary(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: GridPainter(
                        context: context
                    ),
                  ),
                ),

                RepaintBoundary(
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: CandlePainter(
                      candles: widget.candles,
                      viewport: viewport,
                        minPrice: visiblePrice.minPrice,
                        maxPrice: visiblePrice.maxPrice
                    ),
                  ),
                ),
                CrosshairWidget(candles: widget.candles)
              ],
            ),
          );
        }
    );
  }
}
