import 'package:crypto_app/features/market/domain/entities/binance/pair_entity.dart';

import '../../../domain/repositories/binance/binance_repository.dart';
import '../../datasources/binance/rest/binance_remote_datasource.dart';

class BinanceRepositoryImpl implements BinanceRepository {
  final BinanceRemoteDataSource remoteDataSource;

  BinanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PairEntity>> getPairs() async {
    try {
      final result = await remoteDataSource.getPairs();
      return result; // already entity list
    } catch (e) {
      throw Exception("Failed to fetch Binance pairs: $e");
    }
  }
}
