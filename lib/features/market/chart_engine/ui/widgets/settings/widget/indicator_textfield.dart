import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class IndicatorTextField extends StatelessWidget {

  final bool dark;

  final TextEditingController controller;

  final ValueChanged<String> onChanged;

  const IndicatorTextField({
    super.key,
    required this.dark,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 40,
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
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme:
            TextSelectionThemeData(
              cursorColor: dark
                  ? AppColors.white
                  : AppColors.black,

              selectionHandleColor:
              dark
                  ? Colors.white
                  : Colors.black,

              selectionColor:
              (dark
                  ? Colors.white
                  : Colors.black)
                  .withOpacity(0.25),
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType:
            TextInputType.number,
            textAlign: TextAlign.center,

            style: TextStyle(
              color: dark
                  ? AppColors.white
                  : AppColors.black,
              fontSize: 16,
            ),

            decoration:
            const InputDecoration(
              fillColor: Colors.transparent,
              filled: false,
              border: InputBorder.none,
              enabledBorder:
              InputBorder.none,
              focusedBorder:
              InputBorder.none,
              disabledBorder:
              InputBorder.none,

              contentPadding:
              EdgeInsets.symmetric(
                vertical: 10,
              ),
            ),

            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}