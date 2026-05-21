import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/visible_price_range.dart';

final visiblePriceProvider =
    NotifierProvider<VisiblePriceNotifier, VisiblePriceRange>(
      VisiblePriceNotifier.new,
    );

class VisiblePriceNotifier extends Notifier<VisiblePriceRange> {
  @override
  VisiblePriceRange build() {
    return const VisiblePriceRange(minPrice: 0, maxPrice: 1);
  }

  void update({required double minPrice, required double maxPrice}) {
    state = VisiblePriceRange(minPrice: minPrice, maxPrice: maxPrice);
  }
}
