import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class BboTile extends StatelessWidget {
  final String bboType;
  final VoidCallback? onTap;

  const BboTile({
    super.key,
    required this.bboType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: dark
              ? AppColors.blue.withOpacity(0.008)
              : AppColors.white,

          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: dark
                ? AppColors.blue
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
        child: Row(
          children: [
            Expanded(
              child: Text(bboType,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: dark ? AppColors.white : AppColors.black),
              ),
            ),
             Icon(
              Icons.keyboard_arrow_down,
              size: 20.sp,
              color: dark ? AppColors.white : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}