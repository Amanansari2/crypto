import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/helpers/formatters.dart';

class PriceSection extends StatelessWidget {
  final dynamic data;
  final bool isPriceUp;

  const PriceSection({super.key, required this.data, required this.isPriceUp});

  @override
  Widget build(BuildContext context) {
    final isUp = data.priceChangePercent >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          FormatHelper.price(data.lastPrice),
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: isPriceUp ? AppColors.green : AppColors.red,
          ),
        ),

        SizedBox(height: 3.h),

        Row(
          children: [
            Text(
              "≈ \$${FormatHelper.price(data.lastPrice)}",
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
            ),
            SizedBox(width: 10.w),
            Text(
              FormatHelper.percent(data.priceChangePercent),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isUp ? AppColors.green : AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
