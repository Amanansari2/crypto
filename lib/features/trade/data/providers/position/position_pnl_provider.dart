

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/position/position_pnl_model.dart';
import '../../repositories/position/position_live_pnl_repository.dart';

final positionPnlProvider =
StreamNotifierProvider.autoDispose
    .family<
    PositionPnlNotifier,
    Map<int, PositionPnlModel>,
    String
>(
  PositionPnlNotifier.new,
);

class PositionPnlNotifier
    extends StreamNotifier<Map<int, PositionPnlModel>> {
  final String accountId;

  PositionPnlNotifier(this.accountId);

  final PositionPnlRepository _repository =
  PositionPnlRepository();

  @override
  Stream<Map<int, PositionPnlModel>> build() async* {
    final livePnl = <int, PositionPnlModel>{};

    ref.onDispose(() {
      _repository.unsubscribe(accountId);
    });

    await for (final pnl in _repository.livePnl(accountId)) {
      livePnl[pnl.id] = pnl;

      yield Map<int, PositionPnlModel>.from(livePnl);
    }
  }
}