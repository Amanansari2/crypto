import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/binance/order_book_model.dart';
import '../../../data/repositories/order_book_repository.dart';

final orderBookProvider =
StreamNotifierProvider.autoDispose
    .family<OrderBookNotifier, OrderBookModel, String>(
  OrderBookNotifier.new,
);

class OrderBookNotifier extends StreamNotifier<OrderBookModel> {
  final String symbol;

  OrderBookNotifier(this.symbol);

  final OrderBookRepository _repository =
  OrderBookRepository();

  @override
  Stream<OrderBookModel> build() {
    ref.onDispose(() {
      _repository.unsubscribe(symbol);
    });

    return _repository.orderBook(symbol);
  }
}