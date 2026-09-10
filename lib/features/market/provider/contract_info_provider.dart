import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contract_info_repository.dart';
import '../data/models/contract_info_model.dart';

final contractInfoProvider =
FutureProvider.family<
    ContractInfoModel,
    String>(
      (
      ref,
      symbol,
      ) async {

    final repository = ContractInfoRepository();

    return repository.getContractInfo(
      symbol,
    );
  },
);