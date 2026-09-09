import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradeHeader extends StatelessWidget {
  final bool isIsolated;
  final int leverage;
  final VoidCallback? onLeverageTap;
  final VoidCallback? onMarginTap;

  const TradeHeader({
    super.key,
    required this.isIsolated,
    required this.leverage,
    this.onLeverageTap,
    this.onMarginTap
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onMarginTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 28,
            width: 78,
            alignment: Alignment.center,
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
                  child: Text(
                    isIsolated ? 'Isolated' : 'Cross',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: dark ? AppColors.white : AppColors.black
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

        const SizedBox(width: 10),

        InkWell(
          onTap: onLeverageTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 28,
            width: 58,
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
                  child: Text(
                      '${leverage}X',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: dark ? AppColors.white : AppColors.black
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