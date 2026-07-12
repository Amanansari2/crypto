import 'package:crypto_app/features/trade/ui/widgets/trade_constant/trade_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';

class AdvancedOrderTypeSheet extends ConsumerWidget {
  const AdvancedOrderTypeSheet({super.key});

  // static const items = [
  //   'Post Only',
  //   'Fill Or Kill (FOK)',
  //   'Immediate Or Cancel (IOC)',
  // ];


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final items = TradeConstants.advancedOrderTypes;


    return Container(
      decoration:
      BoxDecoration(
        color: dark? AppColors.darkBg : AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            18,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const SizedBox(height: 16),

          const Text(
            'Order Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...items.map(
                (e) => ListTile(
              title: Text(e,
      style: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: dark ? AppColors.white : AppColors.black),

      ),
              trailing:
              state.advancedOrderType == e
                  ?  Icon(Icons.check,
      color: dark ? AppColors.white : AppColors.black,

              )
                  : null,
              onTap: () {

                ref
                    .read(tradeHomeProvider.notifier)
                    .setAdvancedOrderType(e);

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}