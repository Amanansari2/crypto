import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../providers/candle_provider.dart';
import '../../../providers/interval/intervals_provider.dart';
import '../../../providers/interval/selected_interval_provider.dart';
import 'interval_sheet.dart';

class IntervalBar extends ConsumerWidget {
  const IntervalBar({super.key,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final intervals = ref.watch(intervalsProvider);

    final selected = ref.watch(selectedIntervalProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 26,

      padding: const EdgeInsets.symmetric(horizontal: 6),

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: intervals.length + 1,

        separatorBuilder: (_, __) => const SizedBox(width: 4),

        itemBuilder: (context, index) {
          /// 🔥 MORE
          if (index == intervals.length) {
            final isSelectedInVisibleList = intervals.any(
                  (e) => e.value == selected.value,);
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,

                  isScrollControlled: true,

                  backgroundColor: Colors.transparent,

                  builder: (_) {
                    return  IntervalSheet();
                  },
                );
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6, ),

                decoration: BoxDecoration(
                  color: dark
                      ? AppColors.blue.withOpacity(0.08)
                      : AppColors.white,

                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: dark
                        ? AppColors.blue.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.4),
                  ),
                  boxShadow: dark
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
                  child: Row(
                    children: [
                      Text(
                        isSelectedInVisibleList
                            ? 'More'
                            : selected.label,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(width: 2),

                      const Icon(
                        Icons.keyboard_arrow_down,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final interval = intervals[index];

          final isSelected = selected.value == interval.value;

          return GestureDetector(
            onTap: () {
              ref.read(selectedIntervalProvider.notifier).change(interval);

              ref.read(candleProvider.notifier).changeInterval(interval.value);
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8,),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),

                color:dark
                    ? (isSelected
                    ? AppColors.blue
                    : AppColors.blue.withOpacity(0.08))
                    : (isSelected
                    ? AppColors.blue
                    : AppColors.white),

                border: Border.all(
                  color: dark ? AppColors.blue.withOpacity(0.4): Colors.grey.withOpacity(0.4)
                )
              ),



              child: Center(
                child: Text(
                  interval.label,

                  style: TextStyle(
                    color: dark
                        ? AppColors.white
                        : (isSelected
                        ? AppColors.white
                        : AppColors.black),
                    fontSize: 8,

                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
