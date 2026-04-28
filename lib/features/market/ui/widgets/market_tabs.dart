import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';

class MarketTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const MarketTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  static const tabs = ["All", "Gainers", "Losers", "New"];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemBuilder: (_, i) {
          final isActive = selectedIndex == i;

          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),

                /// 🔥 background
                color: isActive
                    ? (isDark
                          ? AppColors.blue.withOpacity(0.08)
                          : AppColors.white)
                    : isDark
                    ? AppColors.white.withOpacity(0.04)
                    : Colors.grey.withOpacity(0.2),

                border: Border.all(
                  color: isActive
                      ? (isDark ? AppColors.blue : Colors.blue)
                      : Colors.grey.withOpacity(0.4),
                ),
              ),

              child: Center(
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w400,
                    color: isActive
                        ? (isDark ? Colors.blue : Colors.blue)
                        : isDark
                        ? Colors.white70
                        : Colors.black87,
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
