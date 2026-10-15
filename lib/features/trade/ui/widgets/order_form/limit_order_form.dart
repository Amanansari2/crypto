import 'package:crypto_app/features/trade/ui/widgets/order_form/trade_buttons.dart';
import 'package:crypto_app/features/trade/ui/widgets/text_field/trade_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/home_ticker_provider.dart';
import '../../../data/providers/limit_order_provider.dart';
import '../../../data/providers/order_calculation_provider.dart';
import '../../../data/providers/trade_provider.dart';
import '../bottom_sheets/price_type_sheet.dart';

class LimitOrderForm extends ConsumerStatefulWidget {
  final String symbol;

  const LimitOrderForm({super.key, required this.symbol});

  @override
  ConsumerState<LimitOrderForm> createState() => _LimitOrderFormState();
}

class _LimitOrderFormState extends ConsumerState<LimitOrderForm> {
  late final TextEditingController priceController;

  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController();
    _amountController = TextEditingController();

    Future.microtask(() {
      final leverage = ref.read(tradeHomeProvider).leverage;

      ref.read(orderCalculationProvider.notifier).setLeverage(leverage);
    });

    _listenToTicker(widget.symbol);
  }

  @override
  void dispose() {
    priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _listenToTicker(String symbol) {
    ref.listenManual(homeTickerProvider(symbol), (previous, next) {
      next.whenData((ticker) {
        ref
            .read(orderCalculationProvider.notifier)
            .setMarketPrice(ticker.lastPrice);
      });
    });
  }

  void _setTickerPrice(double price) {
    if (price <= 0) {
      return;
    }

    if (priceController.text.isEmpty) {
      priceController.text = price.toStringAsFixed(2);
    }
  }

  void _onAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0;

    ref.read(orderCalculationProvider.notifier).setAmount(amount);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final tickerAsync = ref.watch(homeTickerProvider(widget.symbol));
    final calculationState = ref.watch(orderCalculationProvider);
    final limitOrderState = ref.watch(limitOrderProvider);

    final minimumErrorText = calculationState.priceType == 'USDT'
        ? 'Minimum amount is ${calculationState.minimumAmount.toStringAsFixed(2)} USDT'
        : 'Minimum lot size is ${calculationState.minimumLotSize.toStringAsFixed(4)} BTC';

    final hasMinimumError =
        calculationState.amount > 0 &&
        (calculationState.priceType == 'USDT'
            ? calculationState.amount < calculationState.minimumAmount
            : calculationState.amount < calculationState.minimumLotSize);

    return Column(
      children: [
        SizedBox(height: 6),
        tickerAsync.when(
          data: (ticker) {
            _setTickerPrice(ticker.lastPrice);
            return TradeTextField(
              dark: dark,
              labelText: 'Price USDT',
              controller: priceController,
              onChanged: (value) {},
            );
          },
          error: (_, __) {
            return TradeTextField(
              dark: dark,
              labelText: 'Price USDT',
              controller: priceController,
              onChanged: (value) {},
            );
          },
          loading: () {
            return TradeTextField(
              dark: dark,
              labelText: 'Price USDT',
              controller: priceController,
              onChanged: (value) {},
            );
          },
        ),

        const SizedBox(height: 8),

        TradeTextField(
          hideAffixesWhenTyping: true,
          dark: dark,
          controller: _amountController,
          hintText: '0.00',
          labelText: 'Amount (${calculationState.priceType})',
          errorText: hasMinimumError ? minimumErrorText : null,
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
                color: dark ? AppColors.white : AppColors.black,
                fontSize: 11,
              ),
            ),
            Text(
              '${calculationState.sliderPercent.toStringAsFixed(0)}%',
              style: TextStyle(
                color: dark ? AppColors.white : AppColors.black,
                fontSize: 11,
              ),
            ),
            Text(
              '100%',
              style: TextStyle(
                color: dark ? AppColors.white : AppColors.black,
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
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            value: calculationState.sliderPercent.clamp(0, 100).toDouble(),
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
            final price = double.tryParse(priceController.text) ?? 0;

            ref
                .read(limitOrderProvider.notifier)
                .placeBuyOrder(widget.symbol, price);
          },
          onSell: () {
            final price = double.tryParse(priceController.text) ?? 0;

            ref
                .read(limitOrderProvider.notifier)
                .placeSellOrder(widget.symbol, price);
          },
        ),

        if (limitOrderState.error != null) ...[
          const SizedBox(height: 8),
          Text(
            limitOrderState.error!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
