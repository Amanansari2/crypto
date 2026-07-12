
import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/providers/trade_provider.dart';

class AmountDistributionSheet extends ConsumerStatefulWidget {
  final double minPrice;
  final double maxPrice;
  final int orderCount;
  final double totalAmount;

  const AmountDistributionSheet({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.orderCount,
    required this.totalAmount,
  });

  @override
  ConsumerState<AmountDistributionSheet> createState() =>
      _AmountDistributionSheet();
  }

  class _AmountDistributionSheet extends ConsumerState<AmountDistributionSheet>{

    late String selectedType;
    late bool isRatio;

    @override
    void initState() {
      super.initState();

      final state = ref.read(tradeHomeProvider);

      selectedType = state.selectedDistributionType;
      isRatio = state.isRatio;
    }

  @override
  Widget build(BuildContext context, ) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    final averagePrice = state.distributionRows.isEmpty
        ? 0.0
        : state.distributionRows.fold(
                0.0,
                (sum, row) => sum + (row.price * row.amount),
              ) /
              state.distributionRows.fold(0.0, (sum, row) => sum + row.amount);



    final screenHeight = MediaQuery.of(context).size.height;






    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * .70,
      ),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount Distribution',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// DISTRIBUTION TYPES
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _radio(ref, state, 'Equal', dark),
              _radio(ref, state, 'Increasing', dark),
              _radio(ref, state, 'Decreasing', dark),
              _radio(ref, state, 'Random', dark),
            ],
          ),

          const SizedBox(height: 12),

          /// RATIO / DIFFERENCE
          if (selectedType == 'Increasing' ||
              selectedType == 'Decreasing')
            Padding(
              padding: const EdgeInsets.only(left: 4,),
              child: Row(

                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isRatio = false;
                      });

                      ref.read(tradeHomeProvider.notifier).generateDistribution(
                        minPrice: widget.minPrice,
                        maxPrice: widget.maxPrice,
                        orderCount: widget.orderCount,
                        totalAmount: widget.totalAmount,
                        distributionType: selectedType,
                        isRatio: isRatio,
                      );
                    },
                    child:  Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: dark
                              ?(!isRatio
                              ? AppColors.blue
                          : AppColors.blue.withOpacity(0.08))
                              : (!isRatio
                          ? AppColors.blue
                          : AppColors.white
                          ),
                            border: Border.all(
                                color: dark ? AppColors.blue.withOpacity(0.4): Colors.grey.withOpacity(0.4)
                            )
                        ),
                        child: Center(
                          child: Text('Const.Difference',
                          style: TextStyle(
                            color: dark
                                ? AppColors.white
                                :(!isRatio
                                ? AppColors.white
                            : AppColors.black
                            ),
                            fontSize:  12,
                            fontWeight: FontWeight.w600
                          ),
                          ),
                        )),
                  ),

                  SizedBox(width: 10,),

                  InkWell(
                    onTap: () {
                      setState(() {
                        isRatio = true;
                      });

                      ref.read(tradeHomeProvider.notifier).generateDistribution(
                        minPrice: widget.minPrice,
                        maxPrice: widget.maxPrice,
                        orderCount: widget.orderCount,
                        totalAmount: widget.totalAmount,
                        distributionType: selectedType,
                        isRatio: isRatio,
                      );
                    },
                    child:  Container(

                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: dark
                                ?(isRatio
                                ? AppColors.blue
                                : AppColors.blue.withOpacity(0.08))
                                : (isRatio
                                ? AppColors.blue
                                : AppColors.white
                            ),
                            border: Border.all(
                                color: dark ? AppColors.blue.withOpacity(0.4): Colors.grey.withOpacity(0.4)
                            )
                        ),
                        child: Center(child: Text('Const.Ratio',
                          style: TextStyle(
                              color: dark
                                  ? AppColors.white
                                  :(isRatio
                                  ? AppColors.white
                                  : AppColors.black
                              ),
                              fontSize:  12,
                              fontWeight: FontWeight.w600
                          ),
                        ))),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          /// TABLE HEADER
          const Row(
            children: [

              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Price"),
                ),
              ),

              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Amount (USDT)"),
                ),
              ),

              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text("Percentage"),
                ),
              ),

            ],
          ),

          const Divider(),

          /// TABLE
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight*0.30
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics:  const BouncingScrollPhysics(),
              itemCount: state.distributionRows.length,

              itemBuilder: (_, index) {
                final row = state.distributionRows[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child:
                  Row(
                    children: [

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            row.price.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 10,
                              color: dark
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            row.amount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 10,
                              color: dark
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${row.percentage.toStringAsFixed(2)}%",
                            style: TextStyle(
                              fontSize: 10,
                              color: dark
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
                );
              },
            ),
          ),

          const Divider(),

          /// AVERAGE PRICE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Average Price'),
              Text(
                '${averagePrice.toStringAsFixed(1)} USDT',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: dark ? AppColors.white : AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                ref.read(tradeHomeProvider.notifier)
                    .setDistributionType(selectedType);

                ref.read(tradeHomeProvider.notifier)
                    .setRatio(isRatio);
                Navigator.pop(context);
              },
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _radio(WidgetRef ref, state, String value, bool dark) {
    final selected = selectedType == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedType = value;
        });

        ref.read(tradeHomeProvider.notifier).generateDistribution(
          minPrice: widget.minPrice,
          maxPrice: widget.maxPrice,
          orderCount: widget.orderCount,
          totalAmount: widget.totalAmount,
          distributionType: selectedType,
          isRatio: isRatio,
        );
      },
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: selected ? Colors.blue : dark ? AppColors.white : AppColors.black,
          ),
          const SizedBox(width: 4),
          Text(value),
        ],
      ),
    );
  }
}
