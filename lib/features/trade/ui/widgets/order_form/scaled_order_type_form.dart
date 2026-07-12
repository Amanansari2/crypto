import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/amount_sheet/amount_distribution_chart.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/amount_sheet/amount_distribution_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';
import '../text_field/trade_text_field.dart';

class ScaledOrderForm extends ConsumerStatefulWidget {
  const ScaledOrderForm({super.key});

  @override
  ConsumerState<ScaledOrderForm> createState() => _ScaledOrderFormState();
}

class _ScaledOrderFormState extends ConsumerState<ScaledOrderForm> {
  final minimumPriceController = TextEditingController();
  final maximumPriceController = TextEditingController();
  final subOrderController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    minimumPriceController.dispose();
    maximumPriceController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6),

        TradeTextField(
          dark: dark,
          labelText: 'Minimum Price (USDT)',
          controller: minimumPriceController,
          onChanged: (value) {
            _validateForm();
          },
        ),
        if (state.minPriceError != null) ...[
          const SizedBox(height: 4),
          Text(
            state.minPriceError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
            ),
          ),
        ],

        const SizedBox(height: 8),
        const SizedBox(height: 6),

        TradeTextField(
          dark: dark,
          labelText: 'Maximum Price (USDT)',
          controller: maximumPriceController,
          onChanged: (value) {
            _validateForm();
          },
        ),
        if (state.maxPriceError != null) ...[
          const SizedBox(height: 4),
          Text(
            state.maxPriceError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
            ),
          ),
        ],

        const SizedBox(height: 8),
        const SizedBox(height: 6),

        TradeTextField(
          dark: dark,
          labelText: 'Sub-order count',
          hintText: '2-60',
          controller: subOrderController,
          onChanged: (value) {
            _validateForm();
          },
        ),
        if (state.subOrderError != null) ...[
          const SizedBox(height: 4),
          Text(
            state.subOrderError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
            ),
          ),
        ],

        const SizedBox(height: 8),
        const SizedBox(height: 6),

        TradeTextField(
          dark: dark,
          labelText: 'Amount (USDT)',
          controller: amountController,
          onChanged: (value) {
            _validateForm();
          },
        ),
        if (state.amountError != null) ...[
          const SizedBox(height: 4),
          Text(
            state.amountError!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
            ),
          ),
        ],

        const SizedBox(height: 8),
        const SizedBox(height: 6),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled:  true,
                      context: context,
                      builder: (_) =>
                      const AmountDistributionChart(),
                    );
                  },
                  child: Text(
                    'Amount Distribution',
                    style: TextStyle(
                      color: dark ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                    ),
                  ),
                ),
                SizedBox(height: 2),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        20,
                        (_) => Container(
                          margin: const EdgeInsets.only(right: 2),
                          width: 3,
                          height: 1,
                          color: dark ? AppColors.white : AppColors.black,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            InkWell(
              onTap: state.canOpenDistribution
                ?() {
                ref.read(tradeHomeProvider.notifier).generateDistribution(
                  minPrice: double.parse(minimumPriceController.text),
                  maxPrice: double.parse(maximumPriceController.text),
                  orderCount: int.parse(subOrderController.text),
                  totalAmount: double.parse(amountController.text),
                  distributionType: state.selectedDistributionType,
                  isRatio: false,
                );

                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) =>
                   AmountDistributionSheet(
                    minPrice: double.parse(minimumPriceController.text),
                    maxPrice: double.parse(maximumPriceController.text),
                    orderCount: int.parse(subOrderController.text),
                    totalAmount: double.parse(amountController.text),
                  ),
                );
              }
              :null,
              child: Row(
                children: [
                  Text(
                    state.selectedDistributionType,
                    style: TextStyle(
                      color: state.canOpenDistribution
                          ? (dark
                          ? AppColors.white
                          : AppColors.black)
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 8,
                    color: state.canOpenDistribution
                        ? (dark
                        ? AppColors.white
                        : AppColors.black)
                        : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  void _validateForm() {
    ref
        .read(tradeHomeProvider.notifier)
        .validateScaledOrder(
      minPriceText: minimumPriceController.text,
      maxPriceText: maximumPriceController.text,
      subOrderText: subOrderController.text,
      amountText: amountController.text,
    );
  }
}
