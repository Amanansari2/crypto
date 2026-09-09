import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class OrderTypeTile extends StatelessWidget {
  final String orderType;
  final VoidCallback? onTap;

  const OrderTypeTile({
    super.key,
    required this.orderType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 8,
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
            Icon(
              Icons.info_sharp,
              size: 12.sp,
              color: dark ? AppColors.white : AppColors.black,
            ),
            SizedBox(width: 4,),
            Expanded(
              child: Text(orderType,
                style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold, 
                color: dark ? AppColors.white : AppColors.black),),
              ),
             Icon(
              Icons.keyboard_arrow_down,
              size: 12.sp,
              color: dark ? AppColors.white : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}