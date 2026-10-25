import 'package:crypto_app/core/utils/helpers/logger_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/order_history_model.dart';
import '../repository/order_history_repository.dart';

final orderHistoryProvider =
NotifierProvider<OrderHistoryNotifier, OrderHistoryState>(
  OrderHistoryNotifier.new,
);

class OrderHistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<OrderHistoryModel> orders;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final String? error;

  const OrderHistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.orders = const [],
    this.page = 1,
    this.limit = 20,
    this.total = 0,
    this.totalPages = 0,
    this.error,
  });

  bool get hasMore => page < totalPages;

  OrderHistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<OrderHistoryModel>? orders,
    int? page,
    int? limit,
    int? total,
    int? totalPages,
    String? error,
    bool clearError = false,
  }) {
    return OrderHistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      orders: orders ?? this.orders,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class OrderHistoryNotifier extends Notifier<OrderHistoryState> {
  late final OrderHistoryRepository _repository;

  String? _accountId;

  @override
  OrderHistoryState build() {
    _repository = OrderHistoryRepository();
    return const OrderHistoryState();
  }

  Future<void> getOrderHistory(
      String accountId, {
        bool refresh = false,
      }) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (!refresh &&
        state.orders.isNotEmpty &&
        (!state.hasMore || state.totalPages ==0)) {
      return;
    }

    final requestedPage = refresh || _accountId != accountId
        ? 1
        : state.orders.isEmpty
        ? 1
        : state.page + 1;

    _accountId = accountId;

    if (requestedPage == 1) {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        orders: refresh || state.orders.isNotEmpty
            ? []
            : state.orders,
        page: 1,
        total: 0,
        totalPages: 0,
      );
    } else {
      state = state.copyWith(
        isLoadingMore: true,
        clearError: true,
      );
    }

    try {
      final response = await _repository.getOrderHistory(
        accountId: accountId,
        page: requestedPage,
        limit: state.limit,
      );

      LogHelper.log(
        'Order History: requestedPage=$requestedPage, '
            'responsePage=${response.pagination.page}, '
            'totalPages=${response.pagination.totalPages}, '
            'orders=${response.orders.length}',
      );

      final updatedOrders = requestedPage == 1
          ? response.orders
          : [...state.orders, ...response.orders];

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        orders: updatedOrders,
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
    await getOrderHistory(accountId, refresh: true);
  }

  void clear() {
    _accountId = null;
    state = const OrderHistoryState();
  }
}