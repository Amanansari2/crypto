import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../market/data/models/order_book_model.dart';
import '../../data/repositories/home_order_book_repository.dart';

final homeOrderBookProvider =
StreamNotifierProvider.autoDispose
    .family<HomeOrderBookNotifier, OrderBookModel, String>(
  HomeOrderBookNotifier.new,
);

class HomeOrderBookNotifier
    extends StreamNotifier<OrderBookModel> {
  final String symbol;

  HomeOrderBookNotifier(this.symbol);

  final HomeOrderBookRepository _repository =
  HomeOrderBookRepository();

  @override
  Stream<OrderBookModel> build() {
    ref.onDispose(() {
      _repository.unsubscribe(symbol);
    });

    return _repository.orderBook(symbol);
  }
}