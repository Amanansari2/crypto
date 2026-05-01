import 'package:crypto_app/core/utils/extensions/price_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/price_type.dart';
import '../../provider/binance/ticker_provider.dart';
import '../widgets/market_detail_widget/bottom_sheet.dart';
import '../widgets/market_detail_widget/header_scetion.dart';
import '../widgets/market_detail_widget/price_section.dart';
import '../widgets/market_detail_widget/stats_section.dart';

class MarketDetailScreen extends ConsumerStatefulWidget {
  final String symbol;

  const MarketDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<MarketDetailScreen> createState() => _MarketDetailScreenState();
}

class _MarketDetailScreenState extends ConsumerState<MarketDetailScreen> {
  double? _prevPrice;

  @override
  Widget build(BuildContext context) {
    final tickerAsync = ref.watch(tickerProvider(widget.symbol));
    PriceType _selectedPriceType = PriceType.last;

    return Scaffold(
      appBar: AppBar(title: Text(widget.symbol)),
      body: tickerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            "Error: $e",
            style: const TextStyle(color: AppColors.red),
          ),
        ),
        data: (data) {
          final currentPrice = data.lastPrice;

          bool isPriceUp = true;
          if (_prevPrice != null) {
            isPriceUp = currentPrice >= _prevPrice!;
          }
          _prevPrice = currentPrice;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(
                  selected: _selectedPriceType.label,
                  onTap: () {
                    BottomSheetHelper.showPriceSelector(
                      context: context,
                      selected: _selectedPriceType,
                      onSelect: (value) {
                        setState(() {
                          _selectedPriceType = value;
                        });
                      },
                    );
                  },
                ),

                SizedBox(height: 6.h),

                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PriceSection(data: data, isPriceUp: isPriceUp),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(flex: 3, child: StatsSection(data: data)),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
