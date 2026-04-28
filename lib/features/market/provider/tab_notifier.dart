import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketTabProvider = NotifierProvider<MarketTabNotifier, int>(
  MarketTabNotifier.new,
);

class MarketTabNotifier extends Notifier<int> {
  final Set<int> _loadedTabs = {0};

  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
    _loadedTabs.add(index);
  }

  bool isLoaded(int index) => _loadedTabs.contains(index);
}
