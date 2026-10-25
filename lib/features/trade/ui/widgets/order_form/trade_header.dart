import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradeHeader extends StatelessWidget {
  final bool isIsolated;
  final int leverage;
  final VoidCallback? onLeverageTap;

  const TradeHeader({
    super.key,
    required this.isIsolated,
    required this.leverage,
    this.onLeverageTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [


        Text(
          'Leverage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        Spacer(),

        InkWell(
          onTap: onLeverageTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 28,
            width: 90,
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
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
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        '${leverage}X',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: dark ? AppColors.white : AppColors.black
                      ),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}