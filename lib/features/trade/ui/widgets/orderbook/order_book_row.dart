import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class OrderBookRow extends StatelessWidget {
  final double price;
  final double quantity;
  final bool isAsk;

  const OrderBookRow({
    super.key,
    required this.price,
    required this.quantity,
    required this.isAsk,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final priceColor = isAsk
        ? AppColors.red
        : AppColors.green;

    return SizedBox(
      height: 22.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            Expanded(
              child: Text(
                price.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: priceColor,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  quantity.toStringAsFixed(4),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: dark
                        ? AppColors.white
                        : AppColors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}