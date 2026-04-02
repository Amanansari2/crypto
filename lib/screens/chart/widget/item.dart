import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_tutorial_app/core/constants.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final dynamic item; // ideally proper model use karo

  const Item({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    final prices = item.sparklineIn7D?.price ?? [];

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: myWidth * 0.06,
        vertical: 8
      ),
      child: Row(
        children: [
          /// Image
          Expanded(
            flex: 1,
            child: SizedBox(
              height: myHeight * 0.04,
              child: Image.network(
                item.image ?? '',
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.error, color: Colors.grey),
              ),
            ),
          ),

          SizedBox(width: myWidth * 0.02),

          /// Name + Symbol
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.id ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '0.4 ${item.symbol ?? ''}',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),



          /// Chart
          Expanded(
            flex: 4,
            child: SizedBox(
              height: myHeight * 0.05,
              child: prices.isEmpty
                  ? const SizedBox()
                  : Sparkline(
                data: prices,
                lineWidth: 1.0,
                lineColor: item.marketCapChangePercentage24H >= 0
                    ? Color(kGreenHex)
                    : Color(kRedHex),
                fillMode: FillMode.below,
                fillGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: item.marketCapChangePercentage24H >= 0
                      ? [Colors.green, Colors.green.shade100]
                      : [Color(kRedHex), Color(kRedHex).withOpacity(0.1)],
                ),
              ),
            ),
          ),

          SizedBox(width: myWidth * 0.04),

          /// Price + Change
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$ ${item.currentPrice?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    Text(
                      '${item.priceChange24H >= 0 ? '+' : '-'}\$${item.priceChange24H?.abs().toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: myWidth * 0.03),
                    Text(
                      '${item.marketCapChangePercentage24H?.toStringAsFixed(2) ?? '0.00'}%',
                      style: TextStyle(
                        color: item.marketCapChangePercentage24H >= 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
