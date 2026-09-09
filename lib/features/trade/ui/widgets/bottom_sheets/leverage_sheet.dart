import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';
import '../order_form/leverage_slider.dart';

class LeverageSheet extends ConsumerStatefulWidget {
  const LeverageSheet({super.key});

  @override
  ConsumerState<LeverageSheet> createState() => _LeverageSheetState();
}


  class _LeverageSheetState extends ConsumerState<LeverageSheet>{

    late int leverage;

    @override
    void initState() {
      super.initState();

      leverage = ref.read(
        tradeHomeProvider,
      ).leverage;
    }

  @override
  Widget build(BuildContext context) {
    final isIsolated = ref.watch(
      tradeHomeProvider.select(
            (state) => state.isIsolated,
      ),
    );
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: dark ? AppColors.darkBg : AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Header

                Text(
                  'Adjust Leverage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),


            const SizedBox(height: 4),

            Row(
              children: [

                const Text(
                  'BTCUSDT Perp',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
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
                    isIsolated
                        ? 'Isolated'
                        : 'Cross',
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// - 50X +
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  onPressed: () {
                    setState(() {
                      if (leverage > 1) {
                        leverage--;
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.remove,
                    size: 34,
                  ),
                ),

                const SizedBox(width: 20),

                Text(
                  '${leverage}x',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 20),

                IconButton(
                  onPressed: () {
                    setState(() {
                      if (leverage < 150) {
                        leverage++;
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 34,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14,),

            LeverageSlider(
              value: leverage,
              onChanged: (value) {
                setState(() {
                  leverage = value;
                });
              },
            ),


            const SizedBox(height: 20),

            /// Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dark
                    ? AppColors.blue.withOpacity(0.4)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [

                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Maximum position:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '2,172,469.88 USDT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Margin required:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        '0.00 USDT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (leverage >= 50) ...[
              const SizedBox(height: 16),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'High leverage. Please trade with caution!',
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor:  dark ? AppColors.white : AppColors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    )
                ),
                onPressed: () {
                  final currentLeverage =
                      ref.read(tradeHomeProvider).leverage;

                  if (currentLeverage != leverage) {
                    ref
                        .read(tradeHomeProvider.notifier)
                        .setLeverage(leverage);
                  }
                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}