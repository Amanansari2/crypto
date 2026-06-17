import 'package:flutter_riverpod/flutter_riverpod.dart';

final marketDetailsTabProvider = NotifierProvider<MarketDetailsTabNotifier, int>(
  MarketDetailsTabNotifier.new,
);

class MarketDetailsTabNotifier extends Notifier<int> {
  final Set<int> _loadedTabs = {0};

  @override
  int build() => 0;

  void setTab(int index) {
    state = index;
    _loadedTabs.add(index);
  }

  bool isLoaded(int index) => _loadedTabs.contains(index);
}
