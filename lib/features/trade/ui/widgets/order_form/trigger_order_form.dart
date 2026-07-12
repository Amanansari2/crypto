import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/trigger_order_type_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/trigger_price_type_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/text_field/trade_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/trade_provider.dart';

class TriggerOrderForm extends ConsumerStatefulWidget {
  const TriggerOrderForm({super.key});

  @override
  ConsumerState<TriggerOrderForm> createState() => _TriggerOrderFormState();
}

class _TriggerOrderFormState extends ConsumerState<TriggerOrderForm> {
  final triggerController = TextEditingController();
  final priceController = TextEditingController();

  @override
  void dispose() {
    triggerController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, ) {

    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    final isMarketOrder =
        state.triggerPriceType == 'Market Order';


    return Column(
      children: [
        SizedBox(height: 6,),

        TradeTextField(
            dark: dark,
            controller: triggerController,
            onChanged: (value){},
          labelText: 'Trigger (USDT)',
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text( state.triggerOrderType.replaceAll('Price', ''),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: dark ? AppColors.white : AppColors.black
              ),
              ),

              Icon(Icons.keyboard_arrow_down,
              size: 12,
                color: dark ? AppColors.white : AppColors.black,
              )
            ],
          ),
          onSuffixTap: (){
            showModalBottomSheet(
              context: context,
              builder: (_) =>
              const TriggerOrderTypeSheet(),
            );
          },
        ),


        const SizedBox(height: 8),
        const SizedBox(height: 6),

        TradeTextField(
          dark: dark,
          controller: priceController,
          readOnly: isMarketOrder,
          onChanged: (value){},
          labelText: isMarketOrder
              ? null
              : 'Limit Order (USDT)',
          hideAffixesWhenTyping: true,
          showAffixesUntilFocused: !isMarketOrder,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text( state.triggerPriceType,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: dark ? AppColors.white : AppColors.black
                  ),
                ),

                Icon(Icons.keyboard_arrow_down,
                  size: 12,
                  color: dark ? AppColors.white : AppColors.black,
                )
              ],
            ),
          ),
          onPrefixTap: (){
            showModalBottomSheet(
              context: context,
              builder: (_) =>
              const TriggerPriceTypeSheet(),
            );
          },
          suffix: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'USDT',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    color: dark ? AppColors.white : AppColors.black
                ),
              ),
            ),
          )

        ),



        const SizedBox(height: 8),

        // const CostField(),
      ],
    );
  }
}