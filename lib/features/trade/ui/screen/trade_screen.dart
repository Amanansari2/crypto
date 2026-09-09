import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/leverage_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/margin_mode_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/order_form/order_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/providers/order_book_home_provider.dart';
import '../../data/providers/trade_provider.dart';
import '../widgets/bottom_sheets/order_type_sheet.dart';
import '../widgets/order_form/order_type_tile.dart';
import '../widgets/order_form/trade_header.dart';
import '../widgets/orderbook/order_book_widget.dart';

class TradeScreen extends ConsumerWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final orderBook = ref.watch(orderBookHomeProvider("BTCUSDT"));
    return Scaffold(
      appBar: AppBar(
        title:  Text('Trade', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: dark ? AppColors.white : AppColors.black),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children:  [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TradeHeader(
                      isIsolated: state.isIsolated,
                      leverage: state.leverage,
                      onMarginTap: (){
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => const MarginModeSheet(),
                        );
                      },
                      onLeverageTap: (){
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => const LeverageSheet(),
                        );
                      },
                    ),
                    SizedBox(height: 8   ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Amount",
                      style: TextStyle(
                        color: dark ? AppColors.white : AppColors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400
                      ),
                      ),

                        Text("Available balance USDT",
                          style: TextStyle(
                              color: dark ? AppColors.white : AppColors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ],),
                    SizedBox(height: 8),

                    OrderTypeTile(
                      orderType: state.orderType,
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) => const OrderTypeSheet(),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    const OrderFormBuilder(),

                    SizedBox(height: 12),


                    SizedBox(height: 12),
                  ],
                ),
              ),



              Expanded(
                child: SizedBox(
                  height: 650,
                  child: OrderBookWidget(
                    symbol: "BTCUSDT",
                  ),
                ),
              ),
            ],),







           ],
        ),
      ),
    );
  }
}