import 'package:crypto_app/features/trade/ui/widgets/trade_constant/trade_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';

class OrderTypeSheet extends ConsumerWidget {
  const OrderTypeSheet({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final types = TradeConstants.orderTypes;
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
           Text(
            'Order Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          ...types.map(
            (type) => ListTile(
              title: Text(type,
               style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold, 
                color: dark ? AppColors.white : AppColors.black),),
              trailing: state.orderType == type
                  ? Icon(Icons.check, 
                  color: dark ? AppColors.white : AppColors.black,)
                  : null,
              onTap: () {
                ref
                    .read(tradeHomeProvider.notifier)
                    .setOrderType(type);

                Navigator.pop(context);
              },
            ),
          ),

        ],
      ),
    );
  }
}