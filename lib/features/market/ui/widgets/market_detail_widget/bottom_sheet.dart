import 'package:crypto_app/core/utils/enums/price_type.dart';
import 'package:crypto_app/core/utils/extensions/price_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class PriceSelectorSheet extends StatelessWidget {
  final PriceType selected;
  final Function(PriceType) onSelect;

  const PriceSelectorSheet({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10.h),

        /// HANDLE
        Container(
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),

        SizedBox(height: 16.h),

        _item(context, PriceType.last),
        _item(context, PriceType.indexPrice),
        _item(context, PriceType.mark),

        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _item(BuildContext context, PriceType type) {
    final isSelected = selected == type;

    return InkWell(
      onTap: () {
        onSelect(type);
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              type.label,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),

            /// ✔️ TICK ICON
            if (isSelected) Icon(Icons.check, size: 18, color: AppColors.blue),
          ],
        ),
      ),
    );
  }
}

class BottomSheetHelper {
  BottomSheetHelper._();

  static void showPriceSelector({
    required BuildContext context,
    required PriceType selected,
    required Function(PriceType) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return PriceSelectorSheet(selected: selected, onSelect: onSelect);
      },
    );
  }
}
