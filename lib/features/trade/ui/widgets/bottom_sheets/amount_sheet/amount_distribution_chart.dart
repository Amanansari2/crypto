import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import 'distribution_graph.dart';

class AmountDistributionChart extends StatefulWidget {
  const AmountDistributionChart({super.key});

  @override
  State<AmountDistributionChart> createState() => _AmountDistributionChartState();
}

class _AmountDistributionChartState extends State<AmountDistributionChart> {
  bool increasingRatio = false;
  bool decreasingRatio = false;
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          height: MediaQuery.of(context).size.height *0.75,
          padding: const EdgeInsets.all(16),
          decoration:
          BoxDecoration(
            color: dark? AppColors.darkBg : AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                18,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Amount Distribution',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 14,),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _section(
                  title: 'Equal',
                  description:
                  'The amount of each sub-order stays the same.',
                    dark: dark

                ),

                const SizedBox(height: 24),

                _section(
                  title: 'Increasing',
                  description:
                  'The amount of each sub-order increases as the price rises.',
                    dark: dark

                ),

                const SizedBox(height: 24),

                _section(
                  title: 'Decreasing',
                  description:
                  'The amount of each sub-order decreases as the price rises.',
                    dark: dark

                ),

                const SizedBox(height: 24),

                _section(
                  title: 'Random',
                  description:
                  'The amount of each sub-order is randomly determined.',
                  dark: dark
                ),
              ],
            ),
          ),
        );

  }

  Widget _section({
    required String title,
    required String description,
    required bool dark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          description,
          style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w500
          ),
        ),

        if (title == 'Increasing' || title == 'Decreasing') ...[
          const SizedBox(height: 12),

          Row(
            children: [
              _toggleButton(
                title == 'Increasing'
                    ? !increasingRatio
                    : !decreasingRatio,
                'Const.Difference',
                    () {
                  setState(() {
                    if (title == 'Increasing') {
                      increasingRatio = false;
                    } else {
                      decreasingRatio = false;
                    }
                  });
                },
              ),

              const SizedBox(width: 8),

              _toggleButton(
                title == 'Increasing'
                    ? increasingRatio
                    : decreasingRatio,
                'Const.Ratio',
                    () {
                  setState(() {
                    if (title == 'Increasing') {
                      increasingRatio = true;
                    } else {
                      decreasingRatio = true;
                    }
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 12),
        ],

        const SizedBox(height: 12),

        Container(
          height: 120,
          width: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: DistributionGraph(
              type: _getType(title),
              isRatio:  title == 'Increasing'
                  ? increasingRatio
                  : title == 'Decreasing'
                  ? decreasingRatio
                  : false,
            ),
          ),
        ),
      ],
    );

  }

  DistributionType _getType(String title) {
    switch (title) {
      case 'Equal':
        return DistributionType.equal;

      case 'Increasing':
        return DistributionType.increasing;

      case 'Decreasing':
        return DistributionType.decreasing;

      case 'Random':
        return DistributionType.random;

      default:
        return DistributionType.equal;
    }
  }

  Widget _toggleButton(
      bool selected,
      String text,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.blue
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.blue,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: selected
                ? Colors.white
                : AppColors.blue,
          ),
        ),
      ),
    );
  }
}

enum DistributionType {
  equal,
  increasing,
  decreasing,
  random,
}