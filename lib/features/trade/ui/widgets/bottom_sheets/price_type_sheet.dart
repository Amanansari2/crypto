import 'package:crypto_app/features/trade/data/providers/order_calculation_provider.dart';
import 'package:crypto_app/features/trade/ui/widgets/trade_constant/trade_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';

class PriceTypeSheet extends ConsumerWidget {
  const PriceTypeSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderCalculationProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    final items = TradeConstants.priceType;

    return Container(
      decoration: BoxDecoration(
        color: dark ? AppColors.darkBg : AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          ...items.map(
                (e) => ListTile(
              title: Text(
                e,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: dark
                      ? AppColors.white
                      : AppColors.black,
                ),
              ),
              trailing: state.priceType == e
                  ? Icon(
                Icons.check,
                color: dark
                    ? AppColors.white
                    : AppColors.black,
              )
                  : null,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                ref
                    .read(orderCalculationProvider.notifier)
                    .setPriceType(e);

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}