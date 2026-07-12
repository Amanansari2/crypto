import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class MarketOrderForm extends StatelessWidget {
  const MarketOrderForm({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [

        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
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
          child:  Text(
            'Market Price',
            style: TextStyle(
              color: dark ? AppColors.white : AppColors.black,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // const CostField(),
      ],
    );
  }
}