// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../../../core/utils/constants/app_colors.dart';
// import '../../../providers/candle_provider.dart';
//
// class IntervalSelector extends StatelessWidget {
//   final List<String> intervals;
//
//   final bool isDark;
//
//   final bool initialZoomApplied;
//
//   final VoidCallback onResetZoom;
//
//   const IntervalSelector({
//     super.key,
//
//     required this.intervals,
//
//     required this.isDark,
//
//     required this.initialZoomApplied,
//
//     required this.onResetZoom,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 30,
//
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//
//       child: Consumer(
//         builder: (context, ref, _) {
//           final notifier = ref.read(candleProvider.notifier);
//
//           return ListView.separated(
//             scrollDirection: Axis.horizontal,
//
//             itemCount: intervals.length,
//
//             separatorBuilder: (_, __) => const SizedBox(width: 10),
//
//             itemBuilder: (context, index) {
//               final interval = intervals[index];
//
//               return GestureDetector(
//                 onTap: () {
//                   onResetZoom();
//
//                   notifier.changeInterval(interval);
//                 },
//
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//
//                     vertical: 1,
//                   ),
//
//                   decoration: BoxDecoration(
//                     color: isDark
//                         ? AppColors.blue.withOpacity(0.08)
//                         : AppColors.white,
//
//                     borderRadius: BorderRadius.circular(8),
//
//                     border: Border.all(
//                       color: isDark
//                           ? AppColors.blue.withOpacity(0.4)
//                           : Colors.grey.withOpacity(0.4),
//                     ),
//
//                     boxShadow: isDark
//                         ? []
//                         : [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//
//                               blurRadius: 8,
//
//                               spreadRadius: 2,
//
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                   ),
//
//                   child: Center(
//                     child: Text(interval, style: const TextStyle(fontSize: 10)),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
