import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../provider/binance/candle_provider.dart';

class ChartScreen extends ConsumerStatefulWidget {
  final String symbol;
  final bool dark;

  const ChartScreen({super.key, required this.symbol, required this.dark});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  final intervals = ["1m", "5m", "15m", "1h", "1d"];

  DateTimeAxisController? _xAxisController;

  bool _initialZoomApplied = false;
  DateTime? _initialMin;
  DateTime? _initialMax;
  bool _paginationLocked = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(candleProvider.notifier)
          .loadInitial(symbol: widget.symbol, interval: "1m");
    });
  }

  // void _setInitialView(List candles) {
  //   if (_xAxisController == null) return;
  //   if (_initialZoomApplied) return;
  //   if (candles.length < 40) return;
  //
  //   final min = candles[candles.length - 60].time;
  //   final max = candles.last.time;
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _xAxisController?.visibleMinimum = min;
  //     _xAxisController?.visibleMaximum = max;
  //
  //     _initialZoomApplied = true;
  //   });
  // }

  void _setInitialView(List candles) {
    if (_initialZoomApplied) return;
    if (candles.length < 40) return;

    const visibleCandles = 35;

    _initialMin = candles[candles.length - visibleCandles].time;

    _initialMax = candles.last.time;

    _initialZoomApplied = true;
  }

  TextStyle _tooltipStyle() {
    return const TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(candleProvider);

    final candles = state.candles;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _setInitialView(candles);
    // });
    _setInitialView(candles);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _intervalBar(widget.dark),
        SizedBox(height: 6.h),

        Container(
          height: 300.h,
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: widget.dark
                ? AppColors.blue.withOpacity(0.08)
                : AppColors.white,

            border: Border.all(
              color: widget.dark
                  ? AppColors.blue.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.4),
            ),
          ),

          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    SfCartesianChart(
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,

                      plotAreaBorderWidth: 0,
                      margin: EdgeInsets.zero,

                      primaryXAxis: DateTimeAxis(
                        desiredIntervals: 2,
                        initialVisibleMinimum: _initialMin,
                        initialVisibleMaximum: _initialMax,
                        // onRendererCreated: (DateTimeAxisController controller) {
                        //   _xAxisController = controller;
                        // },
                        majorGridLines: MajorGridLines(
                          width: 0.2,
                          dashArray: [15, 10],
                          color: widget.dark
                              ? AppColors.white.withOpacity(0.5)
                              : AppColors.black.withOpacity(0.4),
                        ),

                        axisLine: const AxisLine(width: 0.2),

                        majorTickLines: const MajorTickLines(size: 2),

                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),

                      primaryYAxis: NumericAxis(
                        opposedPosition: true,

                        labelStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),

                        axisLine: const AxisLine(width: 0),

                        majorTickLines: const MajorTickLines(size: 0),

                        desiredIntervals: 4,

                        rangePadding: ChartRangePadding.none,

                        majorGridLines: MajorGridLines(
                          width: 0.2,
                          dashArray: [15, 10],
                          color: widget.dark
                              ? AppColors.white.withOpacity(0.4)
                              : AppColors.black.withOpacity(0.4),
                        ),
                      ),

                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: true,
                        enablePinching: true,
                        zoomMode: ZoomMode.x,
                        enableDoubleTapZooming: false,
                      ),

                      onActualRangeChanged: (ActualRangeChangedArgs args) {
                        final state = ref.read(candleProvider);

                        if (state.isLoadingMore || !state.hasMoreData) {
                          return;
                        }

                        if (state.candles.length < 30) {
                          return;
                        }

                        final visibleMin = args.visibleMin;

                        if (visibleMin == null) return;

                        final triggerPoint =
                            state.candles[20].time.millisecondsSinceEpoch;

                        if (!_paginationLocked &&
                            !state.isLoadingMore &&
                            visibleMin <= triggerPoint) {
                          _paginationLocked = true;

                          Future.microtask(() async {
                            await ref.read(candleProvider.notifier).loadMore();

                            await Future.delayed(
                              const Duration(milliseconds: 400),
                            );

                            if (mounted) {
                              _paginationLocked = false;
                            }
                          });
                        }
                      },

                      trackballBehavior: TrackballBehavior(
                        enable: true,

                        activationMode: ActivationMode.singleTap,

                        tooltipDisplayMode: TrackballDisplayMode.none,

                        lineType: TrackballLineType.vertical,

                        lineColor: Colors.white38,

                        lineWidth: 0.5,

                        markerSettings: const TrackballMarkerSettings(
                          markerVisibility: TrackballVisibilityMode.visible,
                          width: 6,
                          height: 6,
                          borderWidth: 2,
                          borderColor: Colors.white,
                        ),

                        builder: (context, TrackballDetails details) {
                          final index = details.pointIndex;

                          if (index == null) {
                            return const SizedBox();
                          }

                          if (index < 0 || index >= candles.length) {
                            return const SizedBox();
                          }

                          final c = candles[index];

                          return Container(
                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2329),

                              borderRadius: BorderRadius.circular(6),
                            ),

                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  "${c.time}",

                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text("O: ${c.open}", style: _tooltipStyle()),

                                Text("H: ${c.high}", style: _tooltipStyle()),

                                Text("L: ${c.low}", style: _tooltipStyle()),

                                Text("C: ${c.close}", style: _tooltipStyle()),

                                if (c.volume != null)
                                  Text(
                                    "V: ${c.volume}",
                                    style: _tooltipStyle(),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),

                      series: <CandleSeries>[
                        CandleSeries(
                          enableSolidCandles: true,
                          dataSource: candles,

                          xValueMapper: (c, _) => c.time,

                          lowValueMapper: (c, _) => c.low,

                          highValueMapper: (c, _) => c.high,

                          openValueMapper: (c, _) => c.open,

                          closeValueMapper: (c, _) => c.close,

                          width: 0.9,
                          spacing: 0.4,

                          animationDuration: 0,

                          bullColor: const Color(0xFF16C784),

                          bearColor: const Color(0xFFEA3943),
                        ),
                      ],
                    ),

                    /// 🔥 top loader
                    if (state.isLoadingMore)
                      const Positioned(
                        left: 12,
                        top: 20,
                        child: SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _intervalBar(bool isDark) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

      child: Consumer(
        builder: (context, ref, _) {
          final notifier = ref.read(candleProvider.notifier);

          return ListView.separated(
            scrollDirection: Axis.horizontal,

            itemCount: intervals.length,

            separatorBuilder: (_, __) => const SizedBox(width: 10),

            itemBuilder: (context, index) {
              final interval = intervals[index];

              return GestureDetector(
                onTap: () {
                  _initialZoomApplied = false;

                  notifier.changeInterval(interval);
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 1,
                  ),

                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.blue.withOpacity(0.08)
                        : AppColors.white,

                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDark
                          ? AppColors.blue.withOpacity(0.4)
                          : Colors.grey.withOpacity(0.4),
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),

                  child: Center(
                    child: Text(interval, style: const TextStyle(fontSize: 10)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
