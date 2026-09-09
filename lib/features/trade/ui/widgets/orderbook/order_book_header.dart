import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class OrderBookHeader extends StatelessWidget {
  const OrderBookHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Price",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: dark
                    ? AppColors.white.withOpacity(.6)
                    : AppColors.black.withOpacity(.6),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Amount",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: dark
                      ? AppColors.white.withOpacity(.6)
                      : AppColors.black.withOpacity(.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}