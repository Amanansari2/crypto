


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/pairs_model.dart';
import '../data/repositories/binance_repository.dart';


class BinancePairsNotifier extends AsyncNotifier<List<PairModel>> {
  @override
  Future<List<PairModel>> build() async {
    final repository = ref.read(binanceRepositoryProvider);
    return await repository.getPairs();
  }
}

/// Repository
final binanceRepositoryProvider = Provider<BinanceRepository>(
      (ref) => BinanceRepository(),
);

final binancePairsProvider =
AsyncNotifierProvider<BinancePairsNotifier, List<PairModel>>(
  BinancePairsNotifier.new,
);