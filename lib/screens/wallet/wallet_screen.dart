import 'package:crypto_tutorial_app/core/constants.dart';
import 'package:crypto_tutorial_app/screens/wallet/widgets/card.dart';
import 'package:crypto_tutorial_app/screens/wallet/widgets/wallet_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/crypto.dart';
import '../../providers/crypto_provider.dart';
import '../../providers/theme/theme_provider.dart';
import '../../widgets/crypto_list_tile.dart';
import '../../widgets/error_view.dart';
import '../details_screen.dart';
import '../home_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _query = '';
  SortKey _sortKey = SortKey.rank;


  List<Crypto> _applySort(List<Crypto> list) {
    final l = [...list];
    switch (_sortKey) {
      case SortKey.rank:
        l.sort(
              (a, b) => (a.cmcRank ?? 1 << 30).compareTo(b.cmcRank ?? 1 << 30),
        );
        break;
      case SortKey.price:
        l.sort((b, a) => a.quote.price.compareTo(b.quote.price));
        break;
      case SortKey.change24h:
        double p(Crypto c) => c.quote.percentChange24h ?? -1e12;
        l.sort((b, a) => p(a).compareTo(p(b)));
        break;
      case SortKey.name:
        l.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
    }
    return l;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CryptoProvider>();
    final q = _query.trim().toLowerCase();

    // Filter top list by name or symbol
    final filtered = provider.cryptos.where((c) {
      if (q.isEmpty) return true;
      return c.name.toLowerCase().contains(q) ||
          c.symbol.toLowerCase().contains(q);
    }).toList();

     final shown = _applySort(filtered);

    // Compute movers (only when search is empty)
    final movers = [...provider.cryptos]
      ..removeWhere((c) => c.quote.percentChange24h == null);
    movers.sort(
          (b, a) => (a.quote.percentChange24h ?? 0).compareTo(
        b.quote.percentChange24h ?? 0,
      ),
    );
    final topGainers = movers.take(5).toList();
    final topLosers = movers.reversed.take(5).toList();
    final hasHeader = _query.isEmpty && movers.isNotEmpty;


    return Scaffold(
      appBar: AppBar(
        title: Text('Your Wallet'),
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
      
      body: Column(
        children: [
          SizedBox(
            height: 25,
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailWalletScreen()),
                    );
                  },
                  child: _cardWalletBalance(context,
                      total: '\$39.589',
                      totalCrypto: '7.251332 BTC',
                      precent: 7.999),
                ),

                _cardWalletBalance(context,
                    total: '\$43.589',
                    totalCrypto: '5.251332 ETH',
                    precent: -2.999),
              ]),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sorted by higher %',
                    style: TextStyle(color: Colors.black45)),
                Row(children: [
                  Text(
                    '24H',
                    style: TextStyle(color: Colors.black45),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.black45),
                ])
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null
                  ? ErrorView(
                message: provider.error!,
                onRetry: provider.fetchCryptos,
              )
                  : RefreshIndicator(
                onRefresh: provider.fetchCryptos,
                child: shown.isEmpty
                    ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Text(
                        _query.isEmpty
                            ? 'No data available.'
                            : 'No results for "$_query".',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                )
                    : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: shown.length ,
                  itemBuilder: (_, i) {
                    // if (hasHeader && i == 0) {
                    //   return _TopMovers(
                    //     gainers: topGainers,
                    //     losers: topLosers,
                    //     currencySymbol: provider.currencySymbol,
                    //   );
                    // }
                    // final index = hasHeader ? i - 1 : i;
                    final c = shown[i];
                    return Dismissible(
                      key: ValueKey('coin-${c.id}'),
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        color: Colors.amber.withOpacity(0.2),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 28,
                        ),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.amber.withOpacity(0.2),
                        child: const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 28,
                        ),
                      ),
                      confirmDismiss: (dir) async {
                        HapticFeedback.lightImpact();
                        final p = context.read<CryptoProvider>();
                        p.toggleFavorite(c.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              p.isFavorite(c.id)
                                  ? '${c.symbol} added to favorites'
                                  : '${c.symbol} removed from favorites',
                            ),
                            duration: const Duration(milliseconds: 900),
                          ),
                        );
                        return false; // don't remove the tile
                      },
                      child: CryptoListTile(
                        crypto: c,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => DetailsScreen(cryptoId: c.id),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )

              ],
            ),
    );
  }

  Widget _cardWalletBalance(BuildContext context,
      {required String total, totalCrypto, required double precent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: card(
        color: Color(kBlueHex).withOpacity(0.08),
        border: Border.all(color: Color(kBlueHex).withOpacity(0.5)),
        radius: 15,
        width: MediaQuery.of(context).size.width - 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipOval(
                  child: Material(
                    color: Color(kDarkBlueHex),
                    child: InkWell(
                      splashColor: Color(kRedHex), // inkwell color
                      child: SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                            size: 25.0,
                          )),
                      onTap: () {},
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text('Total Wallet Balance',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,),
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
            SizedBox(height: 10),
            Text(
              '$totalCrypto',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,),
            ),
          ],
        ),
      ),
    );
  }
}
