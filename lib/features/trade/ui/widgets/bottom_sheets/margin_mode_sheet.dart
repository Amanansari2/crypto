import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../data/providers/trade_provider.dart';

class MarginModeSheet extends ConsumerStatefulWidget {
  const MarginModeSheet({super.key});

  @override
  ConsumerState<MarginModeSheet> createState() =>
      _MarginModeSheetState();
}

class _MarginModeSheetState
    extends ConsumerState<MarginModeSheet> {

  late bool selectedIsolated;

  @override
  void initState() {
    super.initState();

    final state = ref.read(tradeHomeProvider);

    selectedIsolated = state.isIsolated;
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

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

            Text(
                  'Margin Mode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

            const SizedBox(height: 16),

            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIsolated = false;
                      });
                    },
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),

                          color:dark
                              ? (!selectedIsolated
                              ? AppColors.blue
                              : AppColors.blue.withOpacity(0.08))
                              : (!selectedIsolated
                              ? AppColors.blue
                              : AppColors.white),

                          border: Border.all(
                              color: dark ? AppColors.blue.withOpacity(0.4): Colors.grey.withOpacity(0.4)
                          )
                      ),
                      child: Text(
                        'Cross',
                        style: TextStyle(
                          color: dark
                              ? AppColors.white
                              : (!selectedIsolated
                              ? AppColors.white
                              : AppColors.black),
                          fontSize: 18,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIsolated = true;
                      });
                    },
                    child: Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),

                          color:dark
                              ? (selectedIsolated
                              ? AppColors.blue
                              : AppColors.blue.withOpacity(0.08))
                              : (selectedIsolated
                              ? AppColors.blue
                              : AppColors.white),

                          border: Border.all(
                              color: dark ? AppColors.blue.withOpacity(0.4): Colors.grey.withOpacity(0.4)
                          )
                      ),
                      child: Text(
                        'Isolated',
                        style: TextStyle(
                          color: dark
                              ? AppColors.white
                              : (selectedIsolated
                              ? AppColors.white
                              : AppColors.black),
                          fontSize: 18,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'This mode change will only apply to the selected contract.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'What are cross and isolated margin modes?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: const [
                  TextSpan(
                    text: 'Cross: ',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                    'All positions share the same margin balance. If liquidation occurs, available balance may be used to support positions.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: const [
                  TextSpan(
                    text: 'Isolated: ',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                    'Margin is assigned per position. Risk is limited to the margin allocated to that specific trade.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

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
                  ref.read(tradeHomeProvider.notifier)
                      .setMarginMode(
                    selectedIsolated,
                  );

                  Navigator.pop(context);
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700
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