

import '../../../../../core/network/methods/get_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../model/wallet_overview_model.dart';
import '../model/wallet_trade__history_model.dart';
import '../model/wallet_transaction_model.dart';

class WalletRepository {
  final GetMethod _getMethod = GetMethod();

  Future<WalletOverviewModel> getWalletOverview({
    required String accountId,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.walletOverview}/$accountId',
    );

    return WalletOverviewModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }



  Future<WalletTransactionsResponseModel> getWalletTransactions({
    required String accountId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.walletTransactions}/$accountId',
      queryParams: {
        'limit': limit,
        'offset': offset,
      },
    );

    return WalletTransactionsResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }



  Future<WalletTradeHistoryResponseModel> getWalletTrades({
    required String accountId,
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _getMethod.getRequest(
      endpoint: '${ApiUrls.walletTrades}/$accountId',
      queryParams: {
        'limit': limit,
        'offset': offset,
      },
    );

    return WalletTradeHistoryResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

}
