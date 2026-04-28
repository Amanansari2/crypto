import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class TrendingShimmer extends StatelessWidget {
  final bool isDark;

  const TrendingShimmer({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (_, __) {
        return Container(
          width: 140.w,
          margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            color: isDark ? AppColors.blue.withOpacity(0.08) : Colors.white,
            border: Border.all(
              color: isDark
                  ? AppColors.blue.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.4),
            ),
          ),
          child: Shimmer.fromColors(
            period: const Duration(milliseconds: 800),

            baseColor: isDark
                ? AppColors.blue.withOpacity(0.5)
                : AppColors.blue.withOpacity(0.10),
            highlightColor: isDark
                ? AppColors.blue.withOpacity(0.9)
                : AppColors.blue.withOpacity(0.20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// top row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _box(30.w, 15.h),
                    Column(
                      children: [
                        _box(40.w, 8.h),
                        SizedBox(height: 4.h),
                        _box(30.w, 6.h),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                _box(double.infinity, 8.h),

                SizedBox(height: 4.h),

                _box(double.infinity, 20.h),
                SizedBox(height: 4.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_box(50.w, 10.h), _box(40.w, 10.h)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _box(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? AppColors.blue.withOpacity(0.40) : AppColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
