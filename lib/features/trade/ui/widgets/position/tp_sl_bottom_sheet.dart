import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/models/position/position_model.dart';
import '../../../data/providers/home_ticker_provider.dart';
import '../../../data/providers/position/tp_sl_provider.dart';
import '../text_field/trade_text_field.dart';

class TpSlBottomSheet extends ConsumerStatefulWidget {
  const TpSlBottomSheet({
    super.key,
    required this.position,
  });

  final PositionModel position;

  @override
  ConsumerState<TpSlBottomSheet> createState() =>
      _TpSlBottomSheetState();
}

class _TpSlBottomSheetState
    extends ConsumerState<TpSlBottomSheet> {
  late final TextEditingController _takeProfitController;
  late final TextEditingController _stopLossController;

  @override
  void initState() {
    super.initState();

    _takeProfitController = TextEditingController(
      text: widget.position.takeProfit?.toString() ?? '',
    );

    _stopLossController = TextEditingController(
      text: widget.position.stopLoss?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _takeProfitController.dispose();
    _stopLossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final position = widget.position;

    final tickerAsync =
    ref.watch(homeTickerProvider(position.symbol));

    final tpSlState = ref.watch(tpSlProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: dark
              ? AppColors.darkBg
              : Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Center(
                    child: Text(
                      'TP / SL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  tickerAsync.when(
                    data: (ticker) => _PriceRow(
                      label: 'Last Price',
                      value: ticker.lastPrice.toStringAsFixed(2),
                    ),
                    loading: () => const _PriceRow(
                      label: 'Last Price',
                      value: '--',
                    ),
                    error: (_, __) => const _PriceRow(
                      label: 'Last Price',
                      value: '--',
                    ),
                  ),

                  _PriceRow(
                    label: 'Entry Price',
                    value: position.entryPrice.toStringAsFixed(2),
                  ),

                  tickerAsync.when(
                    data: (ticker) => _PriceRow(
                      label: 'Mark Price',
                      value: ticker.markPrice.toStringAsFixed(2),
                    ),
                    loading: () => const _PriceRow(
                      label: 'Mark Price',
                      value: '--',
                    ),
                    error: (_, __) => const _PriceRow(
                      label: 'Mark Price',
                      value: '--',
                    ),
                  ),


                  _PriceRow(
                    label: 'Liquidation Price',
                    value: position.liquidationPrice == null
                        ? '--'
                        : position.liquidationPrice!
                        .toStringAsFixed(2),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Take Profit',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  TradeTextField(
                    dark: dark,
                    controller: _takeProfitController,
                    hintText: 'Enter take profit',
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Stop Loss',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 6),

                  TradeTextField(
                    dark: dark,
                    controller: _stopLossController,
                    hintText: 'Enter stop loss',
                    onChanged: (value) {},
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        dark ? Colors.blue : Colors.grey.shade400,
                        foregroundColor:
                        dark ? AppColors.white : AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: tpSlState.isLoading
                          ? null
                          : () async {
                        final takeProfitText =
                        _takeProfitController.text.trim();

                        final stopLossText =
                        _stopLossController.text.trim();

                        final takeProfit = takeProfitText.isEmpty
                            ? null
                            : double.tryParse(takeProfitText);

                        final stopLoss = stopLossText.isEmpty
                            ? null
                            : double.tryParse(stopLossText);

                        if (takeProfitText.isNotEmpty &&
                            takeProfit == null) {
                          return;
                        }

                        if (stopLossText.isNotEmpty &&
                            stopLoss == null) {
                          return;
                        }

                        await ref
                            .read(tpSlProvider.notifier)
                            .updateTpSl(
                          accountId: position.accountId,
                          tradeId: position.tradeId,
                          takeProfit: takeProfit,
                          stopLoss: stopLoss,
                        );

                        final state = ref.read(tpSlProvider);

                        if (!context.mounted) return;

                        if (state.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.error!),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context, true);
                      },
                      child: tpSlState.isLoading
                          ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : const Text('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}