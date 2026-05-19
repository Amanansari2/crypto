import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/candle_model.dart';
import '../../providers/candle_provider.dart';
import '../../providers/crosshair_provider.dart';
import '../../providers/viewport_provider.dart';
import '../painters/candel_painter.dart';

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

    return GestureDetector(
      onScaleStart: (details) {
        final viewport = ref.read(viewportProvider);

        _startZoom = viewport.candleWidth;
        _startScroll = viewport.scrollX;
        _startFocal = details.localFocalPoint;
      },

      onTapDown: (details) {
        ref.read(crosshairProvider.notifier).toggle(details.localPosition);
      },

      onLongPressMoveUpdate: (details) {
        ref.read(crosshairProvider.notifier).update(details.localPosition);
      },

      onScaleUpdate: (details) {
        final notifier = ref.read(viewportProvider.notifier);

        final viewport = ref.read(viewportProvider);

        /// 🔥 PINCH ZOOM
        if (details.pointerCount == 2) {
          // final newZoom = (_startZoom * details.scale).clamp(2.0, 150.0);

          double newZoom = (_startZoom * details.scale).clamp(3.0, 28.0);

          /// 🔥 smooth stable zoom
          newZoom = (newZoom * 10).round() / 10;

          /// 🔥 stable focal point
          final focalX = _startFocal.dx;

          /// 🔥 freeze world position
          final worldX = _startScroll + focalX;

          /// 🔥 calculate new scroll
          final newScroll = (worldX * (newZoom / _startZoom)) - focalX;

          notifier.setZoom(newZoom);

          notifier.setScroll(
            newScroll,
            widget.candles.length,
            MediaQuery.of(context).size.width,
          );
        }
        /// 🔥 PAN
        else if (details.pointerCount == 1) {
          final newScroll = viewport.scrollX - details.focalPointDelta.dx;

          notifier.setScroll(
            newScroll,
            widget.candles.length,
            MediaQuery.of(context).size.width,
          );
        }

        final updatedViewport = ref.read(viewportProvider);

        final startIndex =
            (updatedViewport.scrollX / updatedViewport.candleWidth)
                .floor()
                .clamp(0, widget.candles.length);

        final visibleCount =
            (MediaQuery.of(context).size.width / updatedViewport.candleWidth)
                .ceil();

        final endIndex = (startIndex + visibleCount).clamp(
          0,
          widget.candles.length,
        );

        notifier.updateVisibleIndexes(start: startIndex, end: endIndex);

        /// 🔥 PRELOAD
        //   if (startIndex < 30) {
        //
        //     ref
        //         .read(candleProvider.notifier)
        //         .loadMore();
        //   }
      },

      onScaleEnd: (_) {
        final viewport = ref.read(viewportProvider);

        final startIndex = (viewport.scrollX / viewport.candleWidth).floor();

        if (startIndex < 30) {
          ref.read(candleProvider.notifier).loadMore();
        }
      },

      child: CustomPaint(
        size: Size.infinite,

        painter: CandlePainter(
          candles: widget.candles,
          viewport: viewport,
          crosshair: ref.watch(crosshairProvider),
        ),
      ),
    );
  }
}
