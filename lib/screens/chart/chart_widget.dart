// import 'package:chart_sparkline/chart_sparkline.dart';
// import 'package:flutter/material.dart';
//
// class Item extends StatelessWidget {
//   var item;
//   Item({this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     double myHeight = MediaQuery.of(context).size.height;
//     double myWidth = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: myWidth * 0.06, vertical: myHeight * 0.02),
//       child: Container(
//         child: Row(
//           children: [
//             Expanded(
//               flex: 1,
//               child: Container(
//                   height: myHeight * 0.05, child: Image.network(item.image)),
//             ),
//             SizedBox(
//               width: myWidth * 0.02,
//             ),
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     item.id,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '0.4 ' + item.symbol,
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.normal,
//                         color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               width: myWidth * 0.01,
//             ),
//             Expanded(
//               flex: 2,
//               child: Container(
//                 height: myHeight * 0.05,
//                 // width: myWidth * 0.2,
//                 child: Sparkline(
//                   data: item.sparklineIn7D.price,
//                   lineWidth: 2.0,
//                   lineColor: item.marketCapChangePercentage24H >= 0
//                       ? Colors.green
//                       : Colors.red,
//                   fillMode: FillMode.below,
//                   fillGradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       stops: const [0.0, 0.7],
//                       colors: item.marketCapChangePercentage24H >= 0
//                           ? [Colors.green, Colors.green.shade100]
//                           : [Colors.red, Colors.red.shade100]),
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: myWidth * 0.04,
//             ),
//             Expanded(
//               flex: 2,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '\$ ' + item.currentPrice.toString(),
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         item.priceChange24H.toString().contains('-')
//                             ? "-\$" +
//                             item.priceChange24H
//                                 .toStringAsFixed(2)
//                                 .toString()
//                                 .replaceAll('-', '')
//                             : "\$" + item.priceChange24H.toStringAsFixed(2),
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.normal,
//                             color: Colors.grey),
//                       ),
//                       SizedBox(
//                         width: myWidth * 0.03,
//                       ),
//                       Text(
//                         item.marketCapChangePercentage24H.toStringAsFixed(2) +
//                             '%',
//                         style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.normal,
//                             color: item.marketCapChangePercentage24H >= 0
//                                 ? Colors.green
//                                 : Colors.red),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto_tutorial_app/screens/chart/select_coin.dart';
import 'package:flutter/material.dart';

import '../../models/coin_model.dart';
import 'package:http/http.dart' as http;

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
        vertical: myHeight * 0.02,
      ),
      child: Row(
        children: [
          /// Image
          Expanded(
            flex: 1,
            child: SizedBox(
              height: myHeight * 0.05,
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '0.4 ${item.symbol ?? ''}',
                  style: const TextStyle(
                      fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          ),

          SizedBox(width: myWidth * 0.01),

          /// Chart
          Expanded(
            flex: 2,
            child: SizedBox(
              height: myHeight * 0.05,
              child: prices.isEmpty
                  ? const SizedBox()
                  : Sparkline(
                data: prices,
                lineWidth: 2.0,
                lineColor: item.marketCapChangePercentage24H >= 0
                    ? Colors.green
                    : Colors.red,
                fillMode: FillMode.below,
                fillGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: item.marketCapChangePercentage24H >= 0
                      ? [Colors.green, Colors.green.shade100]
                      : [Colors.red, Colors.red.shade100],
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
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
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





class Item2 extends StatelessWidget {
  var item;
  Item2({this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.03, vertical: myHeight * 0.02),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (contest) => SelectCoin(selectItem: item,)));
        },
        child: Container(
          padding: EdgeInsets.only(
            left: myWidth * 0.03,
            right: myWidth * 0.06,
            top: myHeight * 0.02,
            bottom: myHeight * 0.02,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: myHeight * 0.035, child: Image.network(item.image)),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Text(
                item.id,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: myHeight * 0.01,
              ),
              Row(
                children: [
                  Text(
                    item.priceChange24H.toString().contains('-')
                        ? "-\$" +
                        item.priceChange24H
                            .toStringAsFixed(2)
                            .toString()
                            .replaceAll('-', '')
                        : "\$" + item.priceChange24H.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                  SizedBox(
                    width: myWidth * 0.03,
                  ),
                  Text(
                    item.marketCapChangePercentage24H.toStringAsFixed(2) + '%',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: item.marketCapChangePercentage24H >= 0
                            ? Colors.green
                            : Colors.red),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 253, 225, 112),
                Color(0xffFBC700),
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.02, vertical: myHeight * 0.005),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      'Main portfolio',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text(
                    'Top 10 coins',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Exprimental',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ 7,466.20',
                    style: TextStyle(fontSize: 35),
                  ),
                  Container(
                    padding: EdgeInsets.all(myWidth * 0.02),
                    height: myHeight * 0.05,
                    width: myWidth * 0.1,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.5)),
                    child: Image.asset(
                      'assets/icons/5.1.png',
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
              child: Row(
                children: [
                  Text(
                    '+162% all time',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: myHeight * 0.02,
            ),
            Container(
              height: myHeight * 0.7,
              width: myWidth,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey.shade300,
                        spreadRadius: 3,
                        offset: Offset(0, 3))
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: myHeight * 0.03,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assets',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.add)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),
                  Container(
                    height: myHeight * 0.36,
                    child: isRefreshing == true
                        ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffFBC700),
                      ),
                    )
                        : coinMarket == null || coinMarket!.length == 0
                        ? Padding(
                      padding: EdgeInsets.all(myHeight * 0.06),
                      child: Center(
                        child: Text(
                          'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Item(
                          item: coinMarket![index],
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                    child: Row(
                      children: [
                        Text(
                          'Recommend to Buy',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: myWidth * 0.03),
                      child: isRefreshing == true
                          ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffFBC700),
                        ),
                      )
                          : coinMarket == null || coinMarket!.length == 0
                          ? Padding(
                        padding: EdgeInsets.all(myHeight * 0.06),
                        child: Center(
                          child: Text(
                            'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                          : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: coinMarket!.length,
                        itemBuilder: (context, index) {
                          return Item2(
                            item: coinMarket![index],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
