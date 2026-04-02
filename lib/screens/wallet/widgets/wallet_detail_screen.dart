import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants.dart';
import '../../../providers/theme/theme_provider.dart';
import 'card.dart';

class DetailWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet Details'),
        actions:[
          IconButton(
            onPressed: (){
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: Icon(
              context.read<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 25,
            ),
            _cardWallet(
              iconUrl:
              'https://icons.iconarchive.com/icons/cjdowner/cryptocurrency/128/Bitcoin-icon.png',
              crypto: 'Bitcoin',
              cryptoShort: 'BTC',
              totalCrypto: '3.519020 BTC',
              total: '\$19.153 USD',
              precent: -2.33,
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Day'),
                  Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Text(
                        'Week',
                        style: TextStyle(color: Colors.white),
                      )),
                  Text('Month'),
                  Text('Year'),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),



            card(
              color: Color(kYellowHex).withOpacity(0.07),
               border: Border.all(color: Color(kYellowHex).withOpacity(0.4)),
              radius: 15,
              padding: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _dot(color: Color(kRedHex)),
                            Text(
                              'Lower: \$4.896',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _dot(color: Color(kGreenHex)),
                            Text(
                              'Higher:\$6.857',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Stack(children: [
                      LineChart(
                        sampleData(),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 25,
                        child: Row(
                          children: [
                            _dot(size: 15, color: Color(kOrangeHex)),
                            Text(
                              '1BTC=\$5.483',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                // color: Colors.black
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    text: 'Buy',
                    color: Color(kBlueHex),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: _actionButton(
                    text: 'Sell',
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  LineChartData sampleData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      // minX: 1,
      maxX: 13,
      maxY: 8,
      minY: 0,
      lineBarsData: linesBarData(),
    );
  }

  List<LineChartBarData> linesBarData() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(0, 1),
          FlSpot(0.5, 2.8),
          FlSpot(1, 2),
          FlSpot(1.5, 5.8),
          FlSpot(2, 3),
          FlSpot(2.5, 5.2),
          FlSpot(3, 4),
          FlSpot(3.5, 7),
          FlSpot(4, 3),
          FlSpot(4.5, 6),
          FlSpot(5, 1.8),
          FlSpot(5.5, 5.2),
          FlSpot(6, 3.8),
          FlSpot(6.5, 1.6),
          FlSpot(7, 3),
          FlSpot(7.5, 4),
          FlSpot(8, 4.9),
          FlSpot(8.5, 7),
          FlSpot(9, 6.5),
          FlSpot(9.5, 3),
          FlSpot(10, 5),
          FlSpot(10.5, 2),
          FlSpot(11, 4),
          FlSpot(11.5, 1),
          FlSpot(12, 2),
          FlSpot(13, 3),
        ],
        isCurved: false,
        color: Color(kOrangeHex).withOpacity(0.8),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
        ),
        belowBarData: BarAreaData(
          show: true,
          color: Color(kOrangeHex).withOpacity(0.3),
        ),
      ),
    ];
  }

  Widget _dot({double size = 10, Color color = Colors.black}) {
    return Container(
      margin: EdgeInsets.all(10),
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)),
        child: Container(
          color: color,
        ),
      ),
    );
  }

  Widget _cardWallet(
      {required String crypto,
        cryptoShort,
        iconUrl,
        total,
        totalCrypto,
        required double precent}) {
    return card(
      color: Color(kBlueHex).withOpacity(0.08),
      border: Border.all(color: Color(kBlueHex).withOpacity(0.5)),
      radius: 15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(
                '$iconUrl',
                width: 50,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text('$crypto',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Text('$cryptoShort')
            ],
          ),
          SizedBox(height: 20),
          Text(
            '$totalCrypto',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$total',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: precent >= 0 ? Color(kGreenHex) : Color(kRedHex),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Text(
                  precent >= 0 ? '+ $precent %' : '$precent %',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget _actionButton({required Color color, required String text}) {
    return card(
        color: Color(kCyanHex).withOpacity(0.08),
        border: Border.all(color: Color(kCyanHex).withOpacity(0.5)),
        radius: 15,
        child: Column(
          children: [
            ClipOval(
              child: Material(
                color: color,
                child: InkWell(
                  splashColor: Color(kRedHex), // inkwell color
                  child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 25.0,
                      )),
                  onTap: () {},
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('$text', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
          ],
        ));
  }
}