import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/chart_inidicator_enums.dart';
import '../../../provider/binance/candle_provider.dart';
import 'indicators/boll_indicator.dart';
import 'indicators/ema_indicators.dart';
import 'indicators/ma_indicator.dart';

class ChartScreen extends ConsumerStatefulWidget {
  final String symbol;
  final bool dark;

  const ChartScreen({super.key, required this.symbol, required this.dark});

  @override
  ConsumerState<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends ConsumerState<ChartScreen> {
  final intervals = ["1m", "5m", "15m", "1h", "1d"];


  final Set<IndicatorType> _activeIndicators = {};
  IndicatorType? _activeOverlayIndicator;



  DateTimeAxisController? _xAxisController;

  DateTimeAxisController? _volumeXAxisController;

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

    final ma7 = calculateMA(candles, 7);
    final ma25 = calculateMA(candles, 25);
    final ma99 = calculateMA(candles, 99);


    final ema7 = calculateEMA(candles, 7);
    final ema25 = calculateEMA(candles, 25);
    final ema99 = calculateEMA(candles, 99);

    final boll = calculateBollingerBands(candles);

    final upperBand = boll['upper']!;

    final middleBand = boll['middle']!;

    final lowerBand = boll['lower']!;

    _setInitialView(candles);

    return Column(
      children: [
        _intervalBar(widget.dark),
        SizedBox(height: 6.h),
        Align(
          alignment: Alignment.topRight,

          child: Column(
            children: [
              Row(
                children: [

                  if (_activeOverlayIndicator ==
                      IndicatorType.ma) ...[

                    Text(
                      "MA(7): ${ma7.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10.sp,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      "MA(25): ${ma25.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.sp,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      "MA(99): ${ma99.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],

                  if (_activeOverlayIndicator ==
                      IndicatorType.ema)...[

                    Text(
                      "EMA(7): ${ema7.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    Text(
                      "EMA(25): ${ema25.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    Text(
                      "EMA(99): ${ema99.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],

                  if (_activeOverlayIndicator ==
                      IndicatorType.boll) ...[

                    Text(
                      "Upper: ${upperBand.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 10.sp,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      "Middle: ${middleBand.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10.sp,
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Text(
                      "Lower: ${lowerBand.last?.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 6.h,),
            ],
          ),
        ),

        Expanded(
          child: Container(
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
                ? const Center(
              child: CircularProgressIndicator(),
            )

                : Column(
              children: [

                /// 🔥 MAIN CANDLE CHART
                Expanded(
                  flex: 7,

                  child: SfCartesianChart(

                    backgroundColor:
                    Colors.transparent,

                    plotAreaBorderWidth: 0,

                    margin: EdgeInsets.zero,


                    // onZooming:
                    //     (ZoomPanArgs args) {
                    //       setState(() {
                    //
                    //         _initialMin =
                    //             _xAxisController?.visibleMinimum;
                    //
                    //         _initialMax =
                    //             _xAxisController?.visibleMaximum;
                    //       });
                    // },

                    // onZooming: (ZoomPanArgs args) {
                    //
                    //   final min =
                    //       _xAxisController?.visibleMinimum;
                    //
                    //   final max =
                    //       _xAxisController?.visibleMaximum;
                    //
                    //   if (min == null || max == null) {
                    //     return;
                    //   }
                    //
                    //   _initialMin = min;
                    //   _initialMax = max;
                    //
                    //   /// 🔥 sync lower charts
                    //   _volumeXAxisController?.visibleMinimum =
                    //       min;
                    //
                    //   _volumeXAxisController?.visibleMaximum =
                    //       max;
                    //
                    //   setState(() {});
                    // },

                    primaryXAxis:
                    DateTimeAxis(

                      onRendererCreated:
                          (DateTimeAxisController
                      controller,) {
                        _xAxisController =
                            controller;
                      },

                      desiredIntervals: 2,

                      initialVisibleMinimum:
                      _initialMin,

                      initialVisibleMaximum:
                      _initialMax,

                      majorGridLines:
                      MajorGridLines(
                        width: 0.2,

                        dashArray: [15, 10],

                        color: widget.dark
                            ? AppColors.white
                            .withOpacity(0.5)
                            : AppColors.black
                            .withOpacity(0.4),
                      ),

                      axisLine:
                      const AxisLine(
                        width: 0.2,
                      ),

                      majorTickLines:
                      const MajorTickLines(
                        size: 2,
                      ),

                      labelStyle:
                      const TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),

                    primaryYAxis:
                    NumericAxis(

                      opposedPosition: true,

                      desiredIntervals: 4,

                      rangePadding:
                      ChartRangePadding.none,

                      labelStyle:
                      const TextStyle(
                        color: Colors.grey,
                        fontSize: 8,
                      ),

                      axisLine:
                      const AxisLine(
                        width: 0,
                      ),

                      majorTickLines:
                      const MajorTickLines(
                        size: 0,
                      ),

                      majorGridLines:
                      MajorGridLines(
                        width: 0.2,

                        dashArray: [15, 10],

                        color: widget.dark
                            ? AppColors.white
                            .withOpacity(0.4)
                            : AppColors.black
                            .withOpacity(0.4),
                      ),
                    ),

                    zoomPanBehavior:
                    ZoomPanBehavior(

                      enablePanning: true,

                      enablePinching: true,

                      zoomMode: ZoomMode.x,

                      enableDoubleTapZooming:
                      false,
                    ),


                    onActualRangeChanged: (ActualRangeChangedArgs args,) {


                      /// 🔥 CHART SYNC
                      if (args.orientation ==
                          AxisOrientation.horizontal) {
                        final min = DateTime
                            .fromMillisecondsSinceEpoch(
                          args.visibleMin.toInt(),
                        );

                        final max = DateTime
                            .fromMillisecondsSinceEpoch(
                          args.visibleMax.toInt(),
                        );

                        _initialMin = min;
                        _initialMax = max;

                        /// 🔥 sync volume chart
                        _volumeXAxisController
                            ?.visibleMinimum = min;

                        _volumeXAxisController
                            ?.visibleMaximum = max;
                      }

                      /// 🔥 PAGINATION
                      final state = ref.read(
                        candleProvider,
                      );

                      if (state.isLoadingMore ||
                          !state.hasMoreData) {
                        return;
                      }

                      if (state.candles.length < 20) {
                        return;
                      }

                      final visibleMin =
                          args.visibleMin;

                      if (visibleMin == null) {
                        return;
                      }

                      final triggerPoint =
                          state
                              .candles[20]
                              .time
                              .millisecondsSinceEpoch;

                      if (!_paginationLocked &&
                          !state.isLoadingMore &&
                          visibleMin <= triggerPoint) {
                        _paginationLocked = true;

                        Future.microtask(() async {
                          await ref
                              .read(
                            candleProvider.notifier,
                          )
                              .loadMore();

                          await Future.delayed(
                            const Duration(
                              milliseconds: 400,
                            ),
                          );

                          if (mounted) {
                            _paginationLocked = false;
                          }
                        });
                      }
                    },

                    trackballBehavior:
                    TrackballBehavior(

                      enable: true,

                      activationMode:
                      ActivationMode
                          .singleTap,

                      tooltipDisplayMode:
                      TrackballDisplayMode
                          .none,

                      lineType:
                      TrackballLineType
                          .vertical,

                      lineColor:
                      Colors.white38,

                      lineWidth: 0.5,

                      markerSettings:
                      const TrackballMarkerSettings(

                        markerVisibility:
                        TrackballVisibilityMode
                            .visible,

                        width: 6,
                        height: 6,

                        borderWidth: 2,

                        borderColor:
                        Colors.white,
                      ),

                      builder: (context,
                          TrackballDetails
                          details,) {
                        final index =
                            details.pointIndex;

                        if (index == null) {
                          return const SizedBox();
                        }

                        if (index < 0 ||
                            index >=
                                candles.length) {
                          return const SizedBox();
                        }

                        final c =
                        candles[index];

                        return Container(

                          padding:
                          const EdgeInsets
                              .all(8),

                          decoration:
                          BoxDecoration(

                            color:
                            const Color(
                              0xFF1E2329,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                              6,
                            ),
                          ),

                          child: Column(

                            mainAxisSize:
                            MainAxisSize
                                .min,

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              Text(
                                "${c.time}",

                                style:
                                const TextStyle(
                                  color:
                                  Colors
                                      .white70,

                                  fontSize:
                                  10,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                "O: ${c.open}",
                                style:
                                _tooltipStyle(),
                              ),

                              Text(
                                "H: ${c.high}",
                                style:
                                _tooltipStyle(),
                              ),

                              Text(
                                "L: ${c.low}",
                                style:
                                _tooltipStyle(),
                              ),

                              Text(
                                "C: ${c.close}",
                                style:
                                _tooltipStyle(),
                              ),

                              if (c.volume !=
                                  null)

                                Text(
                                  "V: ${c.volume}",

                                  style:
                                  _tooltipStyle(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    series:
                    <CartesianSeries>[

                      CandleSeries(

                        enableSolidCandles:
                        true,

                        dataSource:
                        candles,

                        xValueMapper:
                            (c, _) =>
                        c.time,

                        lowValueMapper:
                            (c, _) =>
                        c.low,

                        highValueMapper:
                            (c, _) =>
                        c.high,

                        openValueMapper:
                            (c, _) =>
                        c.open,

                        closeValueMapper:
                            (c, _) =>
                        c.close,

                        width: 0.9,

                        spacing: 0.4,

                        animationDuration:
                        0,

                        bullColor:
                        const Color(
                          0xFF16C784,
                        ),

                        bearColor:
                        const Color(
                          0xFFEA3943,
                        ),
                      ),

                      if (_activeOverlayIndicator == IndicatorType.ma)...[

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ma7[i],

                          width: 1.2,

                          color: Colors.orange,
                        ),

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ma25[i],

                          width: 1.2,

                          color: Colors.blue,
                        ),

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ma99[i],

                          width: 1.2,

                          color: Colors.purple,
                        ),
                      ],

                      /// EMA
                      if (_activeOverlayIndicator ==
                          IndicatorType.ema)...[

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ema7[i],

                          width: 1.2,

                          color: Colors.orange,
                        ),
                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ema25[i],

                          width: 1.2,

                          color: Colors.blue,
                        ),
                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => ema99[i],

                          width: 1.2,

                          color: Colors.purple,
                        ),
                      ],

                      /// BOLL UPPER
                      if (_activeOverlayIndicator ==
                          IndicatorType.boll)

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => upperBand[i],

                          width: 1,

                          color: Colors.orange,
                        ),

                      /// BOLL MIDDLE
                      if (_activeOverlayIndicator ==
                          IndicatorType.boll)

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => middleBand[i],

                          width: 1,

                          color: Colors.blue,
                        ),

                      /// BOLL LOWER
                      if (_activeOverlayIndicator ==
                          IndicatorType.boll)

                        LineSeries(
                          animationDuration: 0,

                          dataSource: candles,

                          xValueMapper: (c, i) => c.time,

                          yValueMapper: (c, i) => lowerBand[i],

                          width: 1,

                          color: Colors.purple,
                        ),

                    ],
                  ),
                ),

                // / 🔥 VOLUME CHART
                if (_activeIndicators.contains(IndicatorType.volume))

                  Expanded(
                    flex: 3,

                    child: SfCartesianChart(

                      backgroundColor:
                      Colors.transparent,

                      plotAreaBorderWidth:
                      0,

                      margin:
                      EdgeInsets.zero,

                      // primaryXAxis:
                      // DateTimeAxis(
                      //
                      //   initialVisibleMinimum:
                      //   _initialMin,
                      //
                      //   initialVisibleMaximum:
                      //   _initialMax,
                      //
                      //   isVisible: false,
                      // ),

                      primaryXAxis: DateTimeAxis(
                        onRendererCreated:
                            (DateTimeAxisController controller) {
                          _volumeXAxisController = controller;
                        },


                        initialVisibleMinimum: _initialMin,

                        initialVisibleMaximum: _initialMax,

                        isVisible: false,
                      ),

                      zoomPanBehavior: ZoomPanBehavior(
                        enablePanning: false,
                        enablePinching: false,
                      ),

                      primaryYAxis:
                      NumericAxis(

                        opposedPosition:
                        true,

                        labelStyle:
                        const TextStyle(
                          color: Colors.grey,
                          fontSize: 8,
                        ),

                        axisLine:
                        const AxisLine(
                          width: 0,
                        ),

                        majorTickLines:
                        const MajorTickLines(
                          size: 0,
                        ),

                        majorGridLines:
                        MajorGridLines(
                          width: 0.2,

                          dashArray: [
                            15,
                            10,
                          ],

                          color: widget.dark
                              ? AppColors
                              .white
                              .withOpacity(
                              0.2)
                              : AppColors
                              .black
                              .withOpacity(
                              0.1),
                        ),
                      ),

                      series:
                      <CartesianSeries>[

                        ColumnSeries(
                          animationDuration: 0,

                          dataSource:
                          candles,

                          xValueMapper:
                              (c, _) =>
                          c.time,

                          yValueMapper:
                              (c, _) =>
                          c.volume,

                          pointColorMapper:
                              (c, _) {
                            return c.close >=
                                c.open
                                ? AppColors
                                .green
                                : AppColors
                                .red;
                          },

                          width: 0.8,

                          spacing: 0.2,
                        ),
                      ],
                    ),
                  ),


              ],
            ),
          ),
        ),

        SizedBox(height: 6.h),


        SizedBox(
          height: 34.h,

          child: ListView(
            scrollDirection: Axis.horizontal,

            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
            ),

            children: [

              _indicatorButton(
                "MA",
                IndicatorType.ma,
              ),

              _indicatorButton(
                "EMA",
                IndicatorType.ema,
              ),

              _indicatorButton(
                "BOLL",
                IndicatorType.boll,
              ),

              _indicatorButton(
                "VOL",
                IndicatorType.volume,
              ),

              _indicatorButton(
                "MACD",
                IndicatorType.macd,
              ),

              _indicatorButton(
                "KDJ",
                IndicatorType.kdj,
              ),

              _indicatorButton(
                "RSI",
                IndicatorType.rsi,
              ),

              _indicatorButton(
                "ROC",
                IndicatorType.roc,
              ),

              _indicatorButton(
                "WR",
                IndicatorType.wr,
              ),

              _indicatorButton(
                "OBV",
                IndicatorType.obv,
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

  Widget _indicatorButton(String text,
      IndicatorType type,) {
    final selected =

    (type == IndicatorType.ma ||
        type == IndicatorType.ema ||
        type == IndicatorType.boll)

        ? _activeOverlayIndicator == type

        : _activeIndicators.contains(type);
    return GestureDetector(

      onTap: () {
        setState(() {
          if (
          type == IndicatorType.ma ||
              type == IndicatorType.ema ||
              type == IndicatorType.boll
          ) {
            if (_activeOverlayIndicator == type) {
              _activeOverlayIndicator = null;
            } else {
              _activeOverlayIndicator = type;
            }

            return;
          }

          if (_activeIndicators.contains(type)) {
            _activeIndicators.remove(type);
          } else {
            _activeIndicators.add(type);
          }
        });
      },

      child: Container(

        margin: EdgeInsets.only(
          right: 14.w,
        ),

        alignment: Alignment.center,

        child: Text(
          text,

          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,

            color: selected
                ? AppColors.green
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}
