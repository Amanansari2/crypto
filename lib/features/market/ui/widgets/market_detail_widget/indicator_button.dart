// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../../../core/utils/constants/app_colors.dart';
// import '../../../../../core/utils/enums/chart_inidicator_enums.dart';
//
// SfCartesianChart(
// backgroundColor:
// Theme.of(context).scaffoldBackgroundColor,
//
// plotAreaBorderWidth: 0,
// margin: EdgeInsets.zero,
//
// /// 🔥 MULTI ROWS
//
//
// /// 🔥 EXTRA AXES
// axes: <ChartAxis>[
//
// /// 🔥 VOLUME AXIS
// NumericAxis(
// name: 'volumeAxis',
//
// opposedPosition: true,
//
// /// 🔥 volume ko niche push karega
// plotOffsetStart: 180,
//
// majorGridLines:
// const MajorGridLines(width: 0),
//
// axisLine:
// const AxisLine(width: 0),
//
// majorTickLines:
// const MajorTickLines(size: 0),
//
// labelStyle: const TextStyle(
// color: Colors.grey,
// fontSize: 8,
// ),
// ),
// ],
//
// primaryXAxis: DateTimeAxis(
// desiredIntervals: 2,
//
// initialVisibleMinimum:
// _initialMin,
//
// initialVisibleMaximum:
// _initialMax,
//
// majorGridLines:
// MajorGridLines(
// width: 0.2,
// dashArray: [15, 10],
//
// color: widget.dark
// ? AppColors.white
//     .withOpacity(0.5)
//     : AppColors.black
//     .withOpacity(0.4),
// ),
//
// axisLine:
// const AxisLine(width: 0.2),
//
// majorTickLines:
// const MajorTickLines(
// size: 2),
//
// labelStyle:
// const TextStyle(
// color: Colors.grey,
// fontSize: 10,
// ),
// ),
//
// /// 🔥 MAIN PRICE AXIS
// primaryYAxis: NumericAxis(
// opposedPosition: true,
//
//
// labelStyle:
// const TextStyle(
// color: Colors.grey,
// fontSize: 8,
// ),
//
// axisLine:
// const AxisLine(width: 0),
//
// majorTickLines:
// const MajorTickLines(size: 0),
//
// desiredIntervals: 4,
//
// rangePadding:
// ChartRangePadding.none,
//
// majorGridLines:
// MajorGridLines(
// width: 0.2,
// dashArray: [15, 10],
//
// color: widget.dark
// ? AppColors.white
//     .withOpacity(0.4)
//     : AppColors.black
//     .withOpacity(0.4),
// ),
// ),
//
// zoomPanBehavior:
// ZoomPanBehavior(
// enablePanning: true,
// enablePinching: true,
// zoomMode: ZoomMode.x,
// enableDoubleTapZooming:
// false,
// ),
//
// onActualRangeChanged:
// (ActualRangeChangedArgs args) {
//
// final state =
// ref.read(candleProvider);
//
// if (state.isLoadingMore ||
// !state.hasMoreData) {
// return;
// }
//
// if (state.candles.length < 30) {
// return;
// }
//
// final visibleMin =
// args.visibleMin;
//
// if (visibleMin == null) return;
//
// final triggerPoint =
// state
//     .candles[20]
//     .time
//     .millisecondsSinceEpoch;
//
// if (!_paginationLocked &&
// !state.isLoadingMore &&
// visibleMin <= triggerPoint) {
//
// _paginationLocked = true;
//
// Future.microtask(() async {
//
// await ref
//     .read(
// candleProvider.notifier,
// )
//     .loadMore();
//
// await Future.delayed(
// const Duration(
// milliseconds: 400,
// ),
// );
//
// if (mounted) {
// _paginationLocked =
// false;
// }
// });
// }
// },
//
// trackballBehavior:
// TrackballBehavior(
// enable: true,
//
// activationMode:
// ActivationMode.singleTap,
//
// tooltipDisplayMode:
// TrackballDisplayMode.none,
//
// lineType:
// TrackballLineType.vertical,
//
// lineColor: Colors.white38,
//
// lineWidth: 0.5,
//
// markerSettings:
// const TrackballMarkerSettings(
// markerVisibility:
// TrackballVisibilityMode
//     .visible,
//
// width: 6,
// height: 6,
//
// borderWidth: 2,
//
// borderColor: Colors.white,
// ),
//
// builder: (
// context,
// TrackballDetails details,
// ) {
//
// final index =
// details.pointIndex;
//
// if (index == null) {
// return const SizedBox();
// }
//
// if (index < 0 ||
// index >= candles.length) {
// return const SizedBox();
// }
//
// final c = candles[index];
//
// return Container(
// padding:
// const EdgeInsets.all(8),
//
// decoration: BoxDecoration(
// color:
// const Color(0xFF1E2329),
//
// borderRadius:
// BorderRadius.circular(
// 6),
// ),
//
// child: Column(
// mainAxisSize:
// MainAxisSize.min,
//
// crossAxisAlignment:
// CrossAxisAlignment
//     .start,
//
// children: [
//
// Text(
// "${c.time}",
//
// style:
// const TextStyle(
// color:
// Colors.white70,
//
// fontSize: 10,
// ),
// ),
//
// const SizedBox(
// height: 4,
// ),
//
// Text(
// "O: ${c.open}",
// style:
// _tooltipStyle(),
// ),
//
// Text(
// "H: ${c.high}",
// style:
// _tooltipStyle(),
// ),
//
// Text(
// "L: ${c.low}",
// style:
// _tooltipStyle(),
// ),
//
// Text(
// "C: ${c.close}",
// style:
// _tooltipStyle(),
// ),
//
// if (c.volume != null)
// Text(
// "V: ${c.volume}",
// style:
// _tooltipStyle(),
// ),
// ],
// ),
// );
// },
// ),
//
// /// 🔥 ALL SERIES
// series: <CartesianSeries>[
//
// /// CANDLES
// CandleSeries(
// enableSolidCandles: true,
//
// dataSource: candles,
//
// xValueMapper:
// (c, _) => c.time,
//
// lowValueMapper:
// (c, _) => c.low,
//
// highValueMapper:
// (c, _) => c.high,
//
// openValueMapper:
// (c, _) => c.open,
//
// closeValueMapper:
// (c, _) => c.close,
//
// width: 0.9,
// spacing: 0.4,
//
// animationDuration: 0,
//
// bullColor:
// const Color(
// 0xFF16C784),
//
// bearColor:
// const Color(
// 0xFFEA3943),
// ),
//
// /// 🔥 VOLUME
// if (_selectedIndicator ==
// IndicatorType.volume)
//
// ColumnSeries(
//
// yAxisName:
// 'volumeAxis',
//
// dataSource: candles,
//
// xValueMapper:
// (c, _) => c.time,
//
// yValueMapper:
// (c, _) => c.volume,
//
// pointColorMapper:
// (c, _) {
//
// return c.close >= c.open
// ? AppColors.green
//     : AppColors.red;
// },
//
// width: 0.8,
// spacing: 0.2,
// ),
// ],
// ),

//[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]

// Container(
//   height: 250.h,
//   padding: EdgeInsets.all(2),
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(18.r),
//     color: widget.dark
//         ? AppColors.blue.withOpacity(0.08)
//         : AppColors.white,
//
//     border: Border.all(
//       color: widget.dark
//           ? AppColors.blue.withOpacity(0.4)
//           : Colors.grey.withOpacity(0.4),
//     ),
//   ),
//
//   child: state.isLoading
//       ? const Center(child: CircularProgressIndicator())
//       : Stack(
//           children: [
//             // SfCartesianChart(
//             //   backgroundColor: Theme.of(
//             //     context,
//             //   ).scaffoldBackgroundColor,
//             //
//             //   plotAreaBorderWidth: 0,
//             //   margin: EdgeInsets.zero,
//             //
//             //   primaryXAxis: DateTimeAxis(
//             //     desiredIntervals: 2,
//             //     initialVisibleMinimum: _initialMin,
//             //     initialVisibleMaximum: _initialMax,
//             //     // onRendererCreated: (DateTimeAxisController controller) {
//             //     //   _xAxisController = controller;
//             //     // },
//             //     majorGridLines: MajorGridLines(
//             //       width: 0.2,
//             //       dashArray: [15, 10],
//             //       color: widget.dark
//             //           ? AppColors.white.withOpacity(0.5)
//             //           : AppColors.black.withOpacity(0.4),
//             //     ),
//             //
//             //     axisLine: const AxisLine(width: 0.2),
//             //
//             //     majorTickLines: const MajorTickLines(size: 2),
//             //
//             //     labelStyle: const TextStyle(
//             //       color: Colors.grey,
//             //       fontSize: 10,
//             //     ),
//             //   ),
//             //
//             //   primaryYAxis: NumericAxis(
//             //     opposedPosition: true,
//             //
//             //     labelStyle: const TextStyle(
//             //       color: Colors.grey,
//             //       fontSize: 8,
//             //     ),
//             //
//             //     axisLine: const AxisLine(width: 0),
//             //
//             //     majorTickLines: const MajorTickLines(size: 0),
//             //
//             //     desiredIntervals: 4,
//             //
//             //     rangePadding: ChartRangePadding.none,
//             //
//             //     majorGridLines: MajorGridLines(
//             //       width: 0.2,
//             //       dashArray: [15, 10],
//             //       color: widget.dark
//             //           ? AppColors.white.withOpacity(0.4)
//             //           : AppColors.black.withOpacity(0.4),
//             //     ),
//             //   ),
//             //
//             //   zoomPanBehavior: ZoomPanBehavior(
//             //     enablePanning: true,
//             //     enablePinching: true,
//             //     zoomMode: ZoomMode.x,
//             //     enableDoubleTapZooming: false,
//             //   ),
//             //
//             //   onActualRangeChanged: (ActualRangeChangedArgs args) {
//             //     final state = ref.read(candleProvider);
//             //
//             //     if (state.isLoadingMore || !state.hasMoreData) {
//             //       return;
//             //     }
//             //
//             //     if (state.candles.length < 30) {
//             //       return;
//             //     }
//             //
//             //     final visibleMin = args.visibleMin;
//             //
//             //     if (visibleMin == null) return;
//             //
//             //     final triggerPoint =
//             //         state.candles[20].time.millisecondsSinceEpoch;
//             //
//             //     if (!_paginationLocked &&
//             //         !state.isLoadingMore &&
//             //         visibleMin <= triggerPoint) {
//             //       _paginationLocked = true;
//             //
//             //       Future.microtask(() async {
//             //         await ref.read(candleProvider.notifier).loadMore();
//             //
//             //         await Future.delayed(
//             //           const Duration(milliseconds: 400),
//             //         );
//             //
//             //         if (mounted) {
//             //           _paginationLocked = false;
//             //         }
//             //       });
//             //     }
//             //   },
//             //
//             //   trackballBehavior: TrackballBehavior(
//             //     enable: true,
//             //
//             //     activationMode: ActivationMode.singleTap,
//             //
//             //     tooltipDisplayMode: TrackballDisplayMode.none,
//             //
//             //     lineType: TrackballLineType.vertical,
//             //
//             //     lineColor: Colors.white38,
//             //
//             //     lineWidth: 0.5,
//             //
//             //     markerSettings: const TrackballMarkerSettings(
//             //       markerVisibility: TrackballVisibilityMode.visible,
//             //       width: 6,
//             //       height: 6,
//             //       borderWidth: 2,
//             //       borderColor: Colors.white,
//             //     ),
//             //
//             //     builder: (context, TrackballDetails details) {
//             //       final index = details.pointIndex;
//             //
//             //       if (index == null) {
//             //         return const SizedBox();
//             //       }
//             //
//             //       if (index < 0 || index >= candles.length) {
//             //         return const SizedBox();
//             //       }
//             //
//             //       final c = candles[index];
//             //
//             //       return Container(
//             //         padding: const EdgeInsets.all(8),
//             //
//             //         decoration: BoxDecoration(
//             //           color: const Color(0xFF1E2329),
//             //
//             //           borderRadius: BorderRadius.circular(6),
//             //         ),
//             //
//             //         child: Column(
//             //           mainAxisSize: MainAxisSize.min,
//             //
//             //           crossAxisAlignment: CrossAxisAlignment.start,
//             //
//             //           children: [
//             //             Text(
//             //               "${c.time}",
//             //
//             //               style: const TextStyle(
//             //                 color: Colors.white70,
//             //                 fontSize: 10,
//             //               ),
//             //             ),
//             //
//             //             const SizedBox(height: 4),
//             //
//             //             Text("O: ${c.open}", style: _tooltipStyle()),
//             //
//             //             Text("H: ${c.high}", style: _tooltipStyle()),
//             //
//             //             Text("L: ${c.low}", style: _tooltipStyle()),
//             //
//             //             Text("C: ${c.close}", style: _tooltipStyle()),
//             //
//             //             if (c.volume != null)
//             //               Text(
//             //                 "V: ${c.volume}",
//             //                 style: _tooltipStyle(),
//             //               ),
//             //           ],
//             //         ),
//             //       );
//             //     },
//             //   ),
//             //
//             //   series: <CandleSeries>[
//             //     CandleSeries(
//             //       enableSolidCandles: true,
//             //       dataSource: candles,
//             //
//             //       xValueMapper: (c, _) => c.time,
//             //
//             //       lowValueMapper: (c, _) => c.low,
//             //
//             //       highValueMapper: (c, _) => c.high,
//             //
//             //       openValueMapper: (c, _) => c.open,
//             //
//             //       closeValueMapper: (c, _) => c.close,
//             //
//             //       width: 0.9,
//             //       spacing: 0.4,
//             //
//             //       animationDuration: 0,
//             //
//             //       bullColor: const Color(0xFF16C784),
//             //
//             //       bearColor: const Color(0xFFEA3943),
//             //     ),
//             //   ],
//             // ),
//
//
//
//             /// 🔥 top loader
//             if (state.isLoadingMore)
//               const Positioned(
//                 left: 12,
//                 top: 20,
//                 child: SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//           ],
//         ),
// ),
// SizedBox(height: 6.h),
