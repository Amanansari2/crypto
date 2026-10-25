import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/position_history_model.dart';
import '../repository/position_history_repository.dart';

final positionHistoryProvider =
    NotifierProvider<PositionHistoryNotifier, PositionHistoryState>(
      PositionHistoryNotifier.new,
    );

class PositionHistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<PositionHistoryModel> positions;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final String? error;

  const PositionHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.positions = const [],
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
    this.error,
  });

  bool get hasMore => page < totalPages;

  PositionHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<PositionHistoryModel>? positions,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    String? error,
    bool clearError = false,
  }) {
    return PositionHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      positions: positions ?? this.positions,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class PositionHistoryNotifier extends Notifier<PositionHistoryState> {
  late final PositionHistoryRepository _repository;
  String? _accountId;

  @override
  PositionHistoryState build() {
    _repository = PositionHistoryRepository();
    return const PositionHistoryState();
  }

  Future<void> getPositionHistory(
    String accountId, {
    bool refresh = false,
  }) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh &&
        _accountId == accountId &&
        state.positions.isNotEmpty &&
        !state.hasMore) {
      return;
    }

    final requestedPage =
        refresh || _accountId != accountId || state.positions.isEmpty
        ? 1
        : state.page + 1;

    _accountId = accountId;

    if (requestedPage == 1) {
      state = state.copyWith(
        isLoading: true,
        positions: [],
        page: 1,
        total: 0,
        totalPages: 0,
        clearError: true,
      );
    } else {
      state = state.copyWith(isLoadingMore: true, clearError: true);
    }

    try {
      final response = await _repository.getPositionHistory(
        accountId: accountId,
        page: requestedPage,
        limit: state.limit,
      );

      final updatedPositions = requestedPage == 1
          ? response.positions
          : [...state.positions, ...response.positions];

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        positions: updatedPositions,
        page: response.pagination.page,
        limit: response.pagination.limit,
        total: response.pagination.total,
        totalPages: response.pagination.totalPages,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh(String accountId) async {
    await getPositionHistory(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const PositionHistoryState();
  }
}
