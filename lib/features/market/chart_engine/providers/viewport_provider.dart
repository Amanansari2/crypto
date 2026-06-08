import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/chart_config.dart';
import '../core/engine/viewport_engine.dart';
import '../core/models/viewport_model.dart';

final viewportProvider = NotifierProvider<ViewportNotifier, ChartViewport>(
  ViewportNotifier.new,
);

class ViewportNotifier extends Notifier<ChartViewport> {
  @override
  ChartViewport build() {
    return const ChartViewport(
      scrollX: 0,

      candleWidth: 12,

      visibleStartIndex: 0,

      visibleEndIndex: 0,
      isAtLatest: true
    );
  }

  void setScroll(double scrollX, int totalCandles, double screenWidth) {


    final maxScroll =

    ViewportEngine.calculateMaxScroll(
      totalCandles: totalCandles,
      candleWidth: state.candleWidth,
      screenWidth: screenWidth,
    );

    final safeScroll = scrollX
        .clamp(0, maxScroll < 0 ? 0 : maxScroll)
        .toDouble();
    // final isAtLatest = (maxScroll - safeScroll) < (state.candleWidth *3);

    final isAtLatest = ViewportEngine.isAtLatest(
      scrollX: safeScroll,
      maxScroll: maxScroll,
      candleWidth: state.candleWidth,);

    state = state.copyWith(scrollX: safeScroll, isAtLatest:  isAtLatest);
  }

  void setZoom(double candleWidth) {
    final width = candleWidth.clamp(2, 150).toDouble();

    state = state.copyWith(candleWidth: width);
  }

  void updateVisibleIndexes({required int start, required int end}) {
    state = state.copyWith(visibleStartIndex: start, visibleEndIndex: end);
  }

  /// 🔥 maintain viewport after prepend
  void compensatePrepend(int addedCandles) {
    state = state.copyWith(
      scrollX: state.scrollX + (addedCandles * state.candleWidth),
    );
  }
}
