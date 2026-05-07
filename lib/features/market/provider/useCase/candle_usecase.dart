import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/rest/candle_remote_datasource.dart';
import '../../data/repositories/binance/candle_repository_impl.dart';
import '../../domain/usecases/binance/candle_usecase.dart';

final candleRemoteDatasourceProvider = Provider(
  (ref) => CandleRemoteDatasource(),
);

final candleRepositoryProvider = Provider(
  (ref) => CandleRepositoryImpl(ref.watch(candleRemoteDatasourceProvider)),
);

final getCandlesUseCaseProvider = Provider(
  (ref) => GetCandlesUseCase(ref.watch(candleRepositoryProvider)),
);
