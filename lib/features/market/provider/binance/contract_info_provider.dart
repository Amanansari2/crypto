import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/binance/rest/contract_info_rest_datasource.dart';
import '../../data/models/binance/contract_info_model.dart';

final contractInfoProvider =
FutureProvider.family<
    ContractInfoModel,
    String>(
      (
      ref,
      symbol,
      ) async {

    final datasource =
    ContractInfoRestDatasource();

    return datasource.getContractInfo(
      symbol,
    );
  },
);