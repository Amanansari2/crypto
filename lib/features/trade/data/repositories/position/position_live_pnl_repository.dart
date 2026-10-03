import '../../../../../core/network/websocket/trading_backend_socket_service.dart';
import '../../models/position/position_pnl_model.dart';

class PositionPnlRepository {
  final TradingBackendSocketService _socket =
  TradingBackendSocketService();

  Stream<PositionPnlModel> livePnl(
      String accountId,
      ) {
    final normalizedAccountId = accountId.trim();

    _socket.subscribePositionPnl(
      normalizedAccountId,
      "POSITIONS",
    );

    return _socket.messages
        .where(
          (message) =>
      message['type'] == 'POSITION_LIVE_PNL' &&
          message['accountId']?.toString() ==
              normalizedAccountId &&
          message['position'] != null,
    )
        .map(
          (message) => PositionPnlModel.fromJson(
        message['position']
        as Map<String, dynamic>,
      ),
    );
  }

  void unsubscribe(String accountId) {
    _socket.unsubscribePositionPnl(
      accountId,
      "POSITIONS",
    );
  }
}