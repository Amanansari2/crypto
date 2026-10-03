import 'package:crypto_app/features/trade/data/providers/market_order_provider.dart';
import 'package:crypto_app/features/trade/ui/widgets/order_form/trade_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/home_ticker_provider.dart';
import '../../../data/providers/order_calculation_provider.dart';
import '../../../data/providers/trade_provider.dart';
import '../bottom_sheets/price_type_sheet.dart';
import '../text_field/trade_text_field.dart';

class MarketOrderForm extends ConsumerStatefulWidget {
  const MarketOrderForm({super.key});

  @override
  ConsumerState<MarketOrderForm> createState() => _MarketOrderFormState();
}

class _MarketOrderFormState extends ConsumerState<MarketOrderForm> {
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController();
    Future.microtask(() {
      final leverage = ref.read(tradeHomeProvider).leverage;

      ref.read(orderCalculationProvider.notifier).setLeverage(leverage);
    });
    ref.listenManual(homeTickerProvider("BTCUSDT"),
        (previous, next){
      next.whenData((ticker){
        ref.read(orderCalculationProvider.notifier).setMarketPrice(ticker.lastPrice);
      });
        });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }


  void _onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;
    ref.read(orderCalculationProvider.notifier).setAmount(amount);
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tickerAsync = ref.watch(homeTickerProvider("BTCUSDT"),);
    final marketOrderState = ref.watch(marketOrderProvider);
    final calculationState = ref.watch(orderCalculationProvider);


    final minimumErrorText =
    calculationState.priceType == 'USDT'
        ? 'Minimum amount is ${calculationState.minimumAmount.toStringAsFixed(2)} USDT'
        : 'Minimum lot size is ${calculationState.minimumLotSize.toStringAsFixed(4)} BTC';


    final hasMinimumError =
        calculationState.amount > 0 &&
            (calculationState.priceType == 'USDT'
                ? calculationState.amount < calculationState.minimumAmount
                : calculationState.amount < calculationState.minimumLotSize);

    return Column(
      children: [
        // Market Price
        Container(
          height: 35,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
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
          child: tickerAsync.when(
            data: (ticker) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatPrice(ticker.lastPrice),
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "Market Price",
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            },
            loading: () {
              return Text(
                'Market Price',
                style: TextStyle(
                  color: dark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              );
            },
            error: (_, __) {
              return Text(
                'Market Price',
                style: TextStyle(
                  color: dark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Amount
        TradeTextField(
          hideAffixesWhenTyping: true,
          dark: dark,
          controller: _amountController,
          hintText: '0.00',
          labelText: 'Amount (${calculationState.priceType})',
          errorText: hasMinimumError
              ? minimumErrorText
              : null,
          suffix: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                calculationState.priceType,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: dark ? AppColors.white : AppColors.black,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 12,
                color: dark ? AppColors.white : AppColors.black,
              ),
            ],
          ),
          onSuffixTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => const PriceTypeSheet(),
            );
          },
          onChanged: _onAmountChanged,
        ),

        const SizedBox(height: 12),

        // Percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0%',
              style: TextStyle(
                color: dark
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 11,
              ),
            ),
            Text(
              '${calculationState.sliderPercent.toStringAsFixed(0)}%',
              style: TextStyle(
                color: dark
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 11,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                color: dark
                    ? AppColors.white
                    : AppColors.black,
                fontSize: 11,
              ),
            ),
          ],
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.blue,
            inactiveTrackColor: dark
                ? Colors.white24
                : Colors.grey.withOpacity(0.3),
            thumbColor: Colors.blue,
            overlayColor: AppColors.blue.withOpacity(0.15),

            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 14,
            ),
          ),
          child: Slider(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            value:  calculationState.sliderPercent.clamp(0, 100).toDouble(),
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (value) {
              ref.read(orderCalculationProvider.notifier).setSlider(value);
              final amount = ref.read(orderCalculationProvider).amount;

              _amountController.text = amount.toStringAsFixed(2);
              },
          ),
        ),





        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cost',
              style: TextStyle(
                color: dark ? AppColors.white : AppColors.black,
                fontSize: 12,
              ),
            ),
            Text(
              '${calculationState.displayCost.toStringAsFixed(2)} USDT',
              style: TextStyle(
                color: dark ? AppColors.white : AppColors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),


        TradeButtons(
          onBuy: () {
           ref.read(marketOrderProvider.notifier).placeBuyOrder();
          },
          onSell: () {
            ref.read(marketOrderProvider.notifier).placeSellOrder();
          },
        ),

        if (marketOrderState.error != null) ...[
          const SizedBox(height: 8),
          Text(
            marketOrderState.error!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],



      ],
    );
  }
}