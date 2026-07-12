import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/order_book_repository.dart';
import '../models/orderbook_home/order_book_home_model.dart';

final orderBookRepositoryProvider =
Provider<OrderBookRepository>((ref) {
  final repo = OrderBookRepository();

  ref.onDispose(repo.dispose);

  return repo;
});

final orderBookHomeProvider =
StreamProvider.family<OrderBookHomeModel, String>((ref, symbol) {
  final repo = ref.watch(orderBookRepositoryProvider);

  return repo.connect(symbol);
});