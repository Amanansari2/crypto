
import 'package:crypto_app/core/network/methods/get_method.dart';
import 'package:crypto_app/core/utils/constants/api_urls.dart';
import 'package:crypto_app/features/market/data/models/contract_info_model.dart';

class ContractInfoRepository {
  final GetMethod _getMethod;

  ContractInfoRepository({GetMethod? getMethod})
      : _getMethod = getMethod ?? GetMethod();

  Future<ContractInfoModel> getContractInfo(String symbol) async {
    final response = await _getMethod.getRequest(
      endpoint: "${ApiUrls.getContractInfo}/$symbol",
    );

    return ContractInfoModel.fromJson(
      response.data["data"],
    );
  }
}