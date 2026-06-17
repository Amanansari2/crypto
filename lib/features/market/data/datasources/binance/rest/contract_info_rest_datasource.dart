import 'package:crypto_app/core/utils/constants/api_urls.dart';

import '../../../models/binance/contract_info_model.dart';
import '../../../../../../core/network/methods/get_method.dart';

class ContractInfoRestDatasource {

  final GetMethod _getMethod =
  GetMethod();

  Future<ContractInfoModel>
  getContractInfo(
      String symbol,
      ) async {

    final response =
    await _getMethod.getRequest(
      endpoint:
      "${ApiUrls.getContractInfo}/$symbol",
    );

    return ContractInfoModel.fromJson(
      response.data["data"],
    );
  }
}