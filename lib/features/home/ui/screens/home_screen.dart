import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double sliderValue = 0.2;
  String orderType = "Limit";
  double leverage = 3;
  bool tpSl = false;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _bottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(),
              _tabs(),
              _pairSection(),

              /// MAIN SECTION
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _leftPanel()),
                  Expanded(flex: 4, child: _orderBook()),
                ],
              ),

              _positionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔶 HEADER
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Text("Demo Trading",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  /// 🔶 TABS
  Widget _tabs() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text("Futures",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(width: 20),
          Text("Bots", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  /// 🔶 PAIR INFO
  Widget _pairSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: const [
              Text("FETUSDT",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Text("+0.97%", style: TextStyle(color: Colors.green)),
              Spacer(),
              Icon(Icons.candlestick_chart),
              SizedBox(width: 10),
              Icon(Icons.more_horiz),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _chip("Isolated"),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _showLeverageSheet,
                child: _chip("${leverage.toInt()}X"),
              ),
              const Spacer(),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Funding / Countdown",
                      style: TextStyle(fontSize: 10)),
                  Text("0.0041% / 05:53:29"),
                ],
              )
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Text("Available"),
              Spacer(),
              Text("43,663.27 USDT"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text),
    );
  }

  /// 🔶 LEFT PANEL
  Widget _leftPanel() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _showOrderTypeSheet,
            child: _input(orderType),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _input("0.2082")),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey.shade200,
                child: const Text("BBO"),
              )
            ],
          ),
          const SizedBox(height: 10),
          _input("3%"),
          Slider(
            value: sliderValue,
            onChanged: (v) => setState(() => sliderValue = v),
          ),
          Row(
            children: const [
              Checkbox(value: false, onChanged: null),
              Text("Reduced only"),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: tpSl,
                onChanged: (v) => setState(() => tpSl = v!),
              ),
              const Text("TP/SL"),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow("Max", "130,754.38 / 128,760.24"),
          _infoRow("Cost", "1,307.49 / 1,287.57"),
          _infoRow("Liq. Price", "0.1402 / 0.2747"),
          const SizedBox(height: 10),
          _button("Demo Buy (Long)", Colors.green),
          const SizedBox(height: 10),
          _button("Demo Sell (Short)", Colors.red),
        ],
      ),
    );
  }

  Widget _input(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }

  Widget _infoRow(String title, String value) {
    return Row(
      children: [
        Text(title),
        const Spacer(),
        Text(value, style: const TextStyle(color: Colors.green)),
      ],
    );
  }

  Widget _button(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  /// 🔶 ORDER BOOK (FIXED HEIGHT)
  Widget _orderBook() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: 6,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) =>
                _depthRow("0.209$i", "${100 * i}K", true),
          ),
        ),
        const Text("0.2082", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: 6,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, i) =>
                _depthRow("0.207$i", "${120 * i}K", false),
          ),
        ),
      ],
    );
  }

  Widget _depthRow(String price, String qty, bool sell) {
    return Container(
      color: sell
          ? Colors.red.withOpacity(0.1)
          : Colors.green.withOpacity(0.1),
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(price,
              style: TextStyle(color: sell ? Colors.red : Colors.green)),
          Text(qty),
        ],
      ),
    );
  }

  /// 🔶 POSITIONS
  Widget _positionsSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Row(
            children: [
              _tab("Positions (1)", 0),
              _tab("Open Orders (0)", 1),
              _tab("Bots (0)", 2),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("BTCUSDT Perp"),
              Text("+446.67%", style: TextStyle(color: Colors.green)),
            ],
          ),
          const SizedBox(height: 5),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("PnL: +6,250.96",
                style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _tab(String text, int index) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(
            color: selectedTab == index ? Colors.orange : Colors.grey,
            fontWeight:
            selectedTab == index ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// 🔶 ORDER TYPE SHEET
  void _showOrderTypeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final types = [
          "Limit",
          "Market",
          "Advanced Limit",
          "Trigger",
          "Scaled Order"
        ];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: types.map((t) {
            return ListTile(
              title: Text(t),
              trailing: orderType == t
                  ? const Icon(Icons.check, color: Colors.orange)
                  : null,
              onTap: () {
                setState(() => orderType = t);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  /// 🔶 LEVERAGE SHEET
  void _showLeverageSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(builder: (context, setModal) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text("Adjust Leverage"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (leverage > 1) {
                          setModal(() => leverage--);
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.remove)),
                  Text("${leverage.toInt()}x"),
                  IconButton(
                      onPressed: () {
                        setModal(() => leverage++);
                        setState(() {});
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              Slider(
                value: leverage,
                min: 1,
                max: 75,
                onChanged: (v) {
                  setModal(() => leverage = v);
                  setState(() {});
                },
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Confirm"),
              )
            ],
          );
        });
      },
    );
  }

  /// 🔶 BOTTOM NAV
  Widget _bottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: "Futures"),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Spot"),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance), label: "Assets"),
      ],
    );
  }
}