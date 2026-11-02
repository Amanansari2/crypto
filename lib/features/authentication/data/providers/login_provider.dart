
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/app_provider.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_response_model.dart';
import '../repository/auth_repository.dart';

final loginProvider =
AsyncNotifierProvider<LoginNotifier, LoginResponseModel?>(
  LoginNotifier.new,
);

class LoginNotifier extends AsyncNotifier<LoginResponseModel?> {
  late final AuthRepository _repository;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Future<LoginResponseModel?> build() async {
    _repository = AuthRepository();
    ref.onDispose(() {
      emailController.dispose();
      passwordController.dispose();
    });
    return null;
  }



  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Please enter email address';
    }

    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  Future<LoginResponseModel?> login({
    required String email,
    required String password,
  }) async {


    state = const AsyncLoading();

    try {
      final response = await _repository.login(
        LoginRequestModel(
          email: email,
          password: password,
        ),
      );

      if (!response.success || response.token.isEmpty) {
        throw Exception('Invalid login response');
      }

      // Existing Riverpod LocalStorageService
      final localStorage = ref.read(localStorageProvider);

      // Save authentication data
      await localStorage.saveAuthData(
        token: response.token,
        user: response.user.toJson(),
      );
      ref.invalidate(currentUserProvider);

      state = AsyncData(response);

      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }



}
