
import 'package:crypto_app/features/trade_history/ui/widget/order_history_tab.dart';
import 'package:crypto_app/features/trade_history/ui/widget/positio_history_tab.dart';
import 'package:crypto_app/features/trade_history/ui/widget/trading_history_tab.dart';
import 'package:flutter/material.dart';

class TradingHistoryScreen extends StatefulWidget {
  final String accountId;

  const TradingHistoryScreen({
    super.key,
    this.accountId = 'DEMO001',
  });

  @override
  State<TradingHistoryScreen> createState() =>
      _TradingHistoryScreenState();
}

class _TradingHistoryScreenState extends State<TradingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading History'),
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          isScrollable: false,
          labelColor: Colors.blue,
          indicatorColor: Colors.blue,
          splashFactory: NoSplash.splashFactory,
          overlayColor:
          WidgetStateProperty.all(Colors.transparent),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          indicatorWeight: 2,
          tabs: const [
            Tab(text: 'Order History'),
            Tab(text: 'Position History'),
            Tab(text: 'Trading History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          OrderHistoryTab(
            key: const PageStorageKey('order_history_tab'),
            accountId: widget.accountId,
          ),

          PositionHistoryTab(
            key: const PageStorageKey('position_history_tab'),
            accountId: widget.accountId,
          ),
          TradingHistoryTab(
            key: const PageStorageKey('trading_history_tab'),
            accountId: widget.accountId,
          ),
        ],
      ),
    );
  }
}



