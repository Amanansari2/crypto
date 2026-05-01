import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/rest/binance_remote_datasource.dart';
import '../../data/repositories/binance/binance_repository_impl.dart';
import '../../domain/entities/binance/pair_entity.dart';
import '../../domain/repositories/binance/binance_repository.dart';
import '../../domain/usecases/binance/binance_pairs.dart';

class BinancePairsNotifier extends AsyncNotifier<List<PairEntity>> {
  @override
  Future<List<PairEntity>> build() async {
    final useCase = ref.read(getBinancePairsProvider);
    return await useCase();
  }
}

/// 🔌 DataSource
final binanceRemoteDataSourceProvider = Provider(
  (ref) => BinanceRemoteDataSource(),
);

/// 🔌 Repository
final binanceRepositoryProvider = Provider<BinanceRepository>(
  (ref) => BinanceRepositoryImpl(
    remoteDataSource: ref.read(binanceRemoteDataSourceProvider),
  ),
);

/// 🔌 UseCase
final getBinancePairsProvider = Provider(
  (ref) => GetBinancePairs(ref.read(binanceRepositoryProvider)),
);

final binancePairsProvider =
    AsyncNotifierProvider<BinancePairsNotifier, List<PairEntity>>(
      BinancePairsNotifier.new,
    );
