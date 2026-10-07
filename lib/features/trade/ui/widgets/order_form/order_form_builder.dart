import 'package:crypto_app/features/trade/ui/widgets/order_form/scaled_order_type_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/trade_provider.dart';
import 'advance_limit_form.dart';
import 'limit_order_form.dart';
import 'market_order_form.dart';
import 'trigger_order_form.dart';

class OrderFormBuilder extends ConsumerWidget {
  final String symbol;
  const OrderFormBuilder({super.key, required this.symbol});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tradeHomeProvider);

    switch (state.orderType) {
      case 'Market':
        return  MarketOrderForm(symbol: symbol,);

      case 'Advanced Limit':
        return const AdvancedLimitForm();

      case 'Trigger':
        return const TriggerOrderForm();

      case 'Scaled Order':
        return const ScaledOrderForm();


      default:
        return const LimitOrderForm();
    }
  }
}