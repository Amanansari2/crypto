import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/app_provider.dart';
import '../repository/auth_repository.dart';

final logoutProvider =
AsyncNotifierProvider<LogoutNotifier, bool>(
  LogoutNotifier.new,
);

class LogoutNotifier extends AsyncNotifier<bool> {
  late final AuthRepository _repository;

  @override
  Future<bool> build() async {
    _repository = AuthRepository();
    return false;
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      // Step 1: Call backend logout API
      await _repository.logout();

      // Step 2: Clear local authentication data
      await ref.read(localStorageProvider).clearAuthData();

      // Step 3: Update state
      state = const AsyncData(true);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}