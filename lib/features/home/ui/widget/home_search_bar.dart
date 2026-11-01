
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const HomeSearchBar({
    super.key,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.r),
        onTap: onTap,
        child: Container(
          height: 42.h,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: isDark
                ? AppColors.blue.withOpacity(0.08)
                : AppColors.white,
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
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 18.sp,
                color: isDark
                    ? Colors.grey.shade400
                    : Colors.grey.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                "Search coins, symbol or name...",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
