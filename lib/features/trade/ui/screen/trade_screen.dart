import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:crypto_app/features/trade/data/providers/order_calculation_provider.dart';
import 'package:crypto_app/features/trade/data/providers/position/position_provider.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/leverage_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/bottom_sheets/margin_mode_sheet.dart';
import 'package:crypto_app/features/trade/ui/widgets/order_form/order_form_builder.dart';
import 'package:crypto_app/features/trade/ui/widgets/position/position_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/providers/trade_provider.dart';
import '../../data/providers/trading_account_provider.dart';
import '../widgets/bottom_sheets/coin_search_sheet.dart';
import '../widgets/bottom_sheets/order_type_sheet.dart';
import '../widgets/order_form/order_type_tile.dart';
import '../widgets/order_form/trade_header.dart';
import '../widgets/orderbook/order_book_widget.dart';

class TradeScreen extends ConsumerStatefulWidget  {
  const TradeScreen({super.key});
  @override
  ConsumerState<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends ConsumerState<TradeScreen> {
  String _selectedSymbol = 'BTCUSDT';
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {

    await  ref.read(tradingAccountProvider.notifier).getTradingAccount('DEMO001');

      final account = ref.read(tradingAccountProvider).account;

      if (account != null) {
        ref.read(orderCalculationProvider.notifier).setAvailableBalance(account.availableBalance);
      }

      await ref.read(positionProvider.notifier).getOpenPositions('DEMO001');
    });
  }

  @override
  Widget build(BuildContext context, ) {
    final state = ref.watch(tradeHomeProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accountState = ref.watch(tradingAccountProvider);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Trade', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: dark ? AppColors.white : AppColors.black),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCoinSearchBar(context, dark,),
                    SizedBox(height: 10,),
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
                          builder: (context) =>  LeverageSheet(symbol: _selectedSymbol,),
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

                        Text( accountState.account == null
                            ? '-- USDT'
                            : '${accountState.account!.availableBalance.toStringAsFixed(2)} USDT',
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
                     OrderFormBuilder( symbol: _selectedSymbol,),

                    SizedBox(height: 12),


                    SizedBox(height: 12),
                  ],
                ),
              ),


              SizedBox(width: 15,),

              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 460,
                  child: OrderBookWidget(
                    symbol: _selectedSymbol,
                  ),
                ),
              ),
            ],),


            PositionsSection(accountId: "DEMO001")
           ],
        ),
      ),
    );
  }

  Widget _buildCoinSearchBar(
      BuildContext context,
      bool dark,
      ) {
    return InkWell(
      onTap: () async {
        final selectedSymbol =
        await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return const CoinSearchSheet();
          },
        );

        if (selectedSymbol == null) {
          return;
        }
        setState(() {
          _selectedSymbol = selectedSymbol;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 42,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: dark
              ? AppColors.blue.withOpacity(0.08)
              : AppColors.white,
          border: Border.all(
            color: dark
                ? AppColors.blue.withOpacity(0.4)
                : Colors.grey.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 18,
            ),

            const SizedBox(width: 8),

             Expanded(
              child: Text(
                _selectedSymbol,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}