import 'package:flutter/material.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class IndicatorCheckBox extends StatelessWidget {

  final bool value;

  final bool dark;

  final VoidCallback onTap;

  const IndicatorCheckBox({
    super.key,
    required this.value,
    required this.dark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: value
              ? (dark
              ? AppColors.blue.withOpacity(0.08)
              : Colors.blue)
              : Colors.transparent,
          border: Border.all(
            color: value
                ? (dark
                ? AppColors.blue.withOpacity(0.4)
                : Colors.grey.withOpacity(0.4))
                : Colors.grey,
            width: 1.5,
          ),
        ),
        child: value
            ? const Icon(
          Icons.check,
          size: 12,
          color: Colors.white,
        )
            : null,
      ),
    );
  }
}