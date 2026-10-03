import '../../../../../core/network/methods/get_method.dart';
import '../../../../core/utils/constants/api_urls.dart';
import '../models/trading_account_model.dart';

class TradingAccountRepository {
  final GetMethod _getMethod = GetMethod();

  Future<TradingAccountModel> getTradingAccount(
      String accountId,
      ) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.tradingAccount}/$accountId',
    );

    return TradingAccountModel.fromJson(
      response.data['account'],
    );
  }
}