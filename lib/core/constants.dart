import 'package:crypto_tutorial_app/screens/home_screen.dart';
import 'package:crypto_tutorial_app/screens/widgets/first_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/navbar/widgets/samle_widget.dart';
import 'app_sizes.dart';

const String kApiHost = 'api.coinmarketcap.com';
const String kApiPath = '/data-api/v3/cryptocurrency/listing';

const Map<String, String> kBaseQuery = {
  'start': '1',
  'limit': '1000',
  'sortBy': 'market_cap',
  'sortType': 'desc',
  'convert': 'USD',
  'cryptoType': 'all',
  'tagType': 'all',
  'audited': 'false',
  'aux':
      'ath,atl,high24h,low24h,num_market_pairs,cmc_rank,date_added,max_supply,circulating_supply,total_supply,volume_7d,volume_30d,self_reported_circulating_supply,self_reported_market_cap',
};

const int kTopCount = 200; // show top 200 in list to keep it snappy

// Colors for up/down
const int kGreenHex = 0xFF16C784;
const int kRedHex = 0xFFEA3943;

// Currency symbols
const Map<String, String> kCurrencySymbols = {
  'USD': '\$',
  'EUR': '€',
  'GBP': '£',
  'INR': '₹',
  'JPY': '¥',
  'CNY': '¥',
  'AUD': 'A\$',
  'CAD': 'C\$',
  'KRW': '₩',
  'RUB': '₽',
  'BRL': 'R\$',
};

String currencySymbolFor(String code) =>
    kCurrencySymbols[code.toUpperCase()] ?? code.toUpperCase();


List<Widget> screens = [
  const FirstScreen(),

  const HomeScreen(),

  const SampleWidget(
    label: 'EXPLORE',
    color: Colors.cyan,
  ),

];


double animatedPositionedLEftValue(int currentIndex, BuildContext context) {
  int itemCount = 3;
  double totalWidth =
      MediaQuery.of(context).size.width -
          (AppSizes.blockSizeHorizontal * 9); // padding

  double itemWidth = totalWidth / itemCount;


  return (AppSizes.blockSizeHorizontal * 4.5) + // left padding
      (itemWidth * currentIndex) +
      (itemWidth / 2) -
      (itemWidth / 2) + 18; // indicator center adjust
}

final List<Color> gradient = [
  CupertinoColors.activeOrange.withOpacity(0.8),
  CupertinoColors.activeOrange.withOpacity(0.5),
  Colors.transparent
];