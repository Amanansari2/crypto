import 'package:crypto_app/features/trade/ui/widgets/text_field/trade_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';
import '../bottom_sheets/bbo_sheet.dart';

class LimitOrderForm extends ConsumerStatefulWidget {
  const LimitOrderForm({super.key});

  @override
  ConsumerState<LimitOrderForm> createState() => _LimitOrderFormState();
}

class _LimitOrderFormState extends ConsumerState<LimitOrderForm> {
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
        SizedBox(height: 6,),

        if (!state.useBbo) ...[
          Row(
            children: [
              Expanded(
                child: TradeTextField(
                  dark: dark,
                  labelText: 'Price USDT',
                  controller: priceController,
                  onChanged: (value) {},
                ),
              ),

              const SizedBox(width: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    ref.read(tradeHomeProvider.notifier).toggleBbo();
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    alignment: Alignment.center,
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
                    child: Text(
                      'BBO',
                      style: TextStyle(
                        color: dark ? Colors.blue : AppColors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],

        if (state.useBbo) ...[
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const BboSheet(),
                    );
                  },
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
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
                        Expanded(child:
                        Text(state.bboType,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: dark ? AppColors.white : AppColors.black
                        ),
                        )),

                         Icon(Icons.keyboard_arrow_down,
                        size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  ref.read(tradeHomeProvider.notifier).toggleBbo();
                },
                child: Container(
                  width: 50,
                  height: 40,
                  alignment: Alignment.center,
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
                  child: Text(
                    'BBO',
                    style: TextStyle(
                      color: dark ? Colors.blue : AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 8),

      ],
    );
  }
}
