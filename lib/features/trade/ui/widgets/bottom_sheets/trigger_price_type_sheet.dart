import 'package:crypto_app/features/trade/ui/widgets/trade_constant/trade_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';

class TriggerPriceTypeSheet extends ConsumerWidget {
  const TriggerPriceTypeSheet({super.key});

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
final items = TradeConstants.triggerPriceTypes;

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


          ...items.map(
                (e) => ListTile(
              title: Text(e,
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: dark ? AppColors.white : AppColors.black),

              ),
              trailing:
              state.triggerPriceType == e
                  ?  Icon(Icons.check,
                color: dark ? AppColors.white : AppColors.black,

              )
                  : null,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();

                ref
                    .read(tradeHomeProvider.notifier)
                    .setTriggerPriceType(e);

                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}