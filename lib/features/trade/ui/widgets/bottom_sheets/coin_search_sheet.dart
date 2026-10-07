import 'package:crypto_app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../market/provider/market_provider.dart';
import '../../../../market/provider/search_provider.dart';

class CoinSearchSheet extends ConsumerStatefulWidget {
  const CoinSearchSheet({super.key});

  @override
  ConsumerState<CoinSearchSheet> createState() => _CoinSearchSheetState();
}

class _CoinSearchSheetState extends ConsumerState<CoinSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.microtask(() {
      ref.read(marketProvider.notifier).loadAll();
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      final query = _searchController.text.trim();

      // Load more only for all-coins list.
      if (query.isEmpty) {
        ref.read(marketProvider.notifier).loadMore();
      }
    }
  }

  void _onSearchChanged(String value) {
    final query = value.trim();

    if (query.isEmpty) {
      setState(() {});
      return;
    }

    ref.read(searchProvider.notifier).search(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    final marketState = ref.watch(marketProvider);
    final searchState = ref.watch(searchProvider);

    final isSearching = _searchController.text.trim().isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        color: dark ? AppColors.darkBg : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 16),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search coin',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();

                    ref
                        .read(searchProvider.notifier)
                        .search('');

                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                fillColor: dark
                    ? AppColors.blue.withOpacity(0.08)
                    : Colors.grey.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: isSearching
                ? _buildSearchResults(
              context,
              dark,
              searchState,
            )
                : _buildAllCoins(
              context,
              dark,
              marketState,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCoins(
      BuildContext context,
      bool dark,
      AsyncValue marketState,
      ) {
    return marketState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Failed to load coins',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      data: (data) {
        if (data.coins.isEmpty) {
          return Center(
            child: Text(
              'No coins found',
              style: TextStyle(
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          itemCount: data.coins.length,
          itemBuilder: (context, index) {
            final coin = data.coins[index];

            return InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  '${coin.symbol.toUpperCase()}USDT',
                );
              },
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                   child: Row(
                     children: [
                       Expanded(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               coin.name,
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                               style: const TextStyle(
                                 fontSize: 12,
                                 fontWeight: FontWeight.w600,
                               ),
                             ),
                             Text(
                               coin.symbol.toUpperCase(),
                               style: const TextStyle(
                                 fontSize: 8,
                               ),
                             ),
                           ],
                         ),
                       ),
                       Text(
                         '${coin.currentPrice}',
                         style: const TextStyle(
                           fontSize: 12,
                           fontWeight: FontWeight.w600,
                         ),
                       ),
                     ],
                   ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchResults(
      BuildContext context,
      bool dark,
      AsyncValue searchState,
      ) {
    return searchState.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Failed to search coins',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      data: (data) {
        if (data == null || data.coins.isEmpty) {
          return Center(
            child: Text(
              'No coins found',
              style: TextStyle(
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: data.coins.length,
          itemBuilder: (context, index) {
            final coin = data.coins[index];

            return InkWell(
              onTap: () {
                Navigator.pop(
                  context,
                  '${coin.symbol.toUpperCase()}USDT',
                );
              },
              child: SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              coin.symbol.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${coin.currentPrice}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}