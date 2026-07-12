import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';
import '../bottom_sheets/advance_order_type_sheet.dart';
import '../text_field/trade_text_field.dart';

class AdvancedLimitForm extends ConsumerStatefulWidget {
  const AdvancedLimitForm({super.key});
  @override
  ConsumerState<AdvancedLimitForm> createState() => _AdvancedLimitFormState();
}

class _AdvancedLimitFormState extends ConsumerState<AdvancedLimitForm> {
  final priceController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;


    return Column(
      children: [

        GestureDetector(
          onTap: () {
            showModalBottomSheet(

              context: context,
              builder: (_) =>
              const AdvancedOrderTypeSheet(),
            );
          },
          child: Container(
            height: 40,
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
                    state.advancedOrderType,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: dark ? AppColors.white : AppColors.black
                    ),
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,

                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),
        SizedBox(height: 6,),


        TradeTextField(
          dark: dark,
          labelText: 'Price USDT',
          controller: priceController,
          onChanged: (value) {},
        ),

        const SizedBox(height: 8),

      ],
    );
  }
}