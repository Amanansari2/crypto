import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class IndicatorColorBox extends StatelessWidget {

  final bool dark;

  final Color color;

  final VoidCallback onTap;

  const IndicatorColorBox({
    super.key,
    required this.dark,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: dark
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.white,

          borderRadius:
          BorderRadius.circular(8.r),

          border: Border.all(
            color: dark
                ? AppColors.blue.withOpacity(0.4)
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
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                BorderRadius.circular(4),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}