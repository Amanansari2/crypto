import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/forget_password/forget_password_request_model.dart';
import '../models/forget_password/forgot_password_response_model.dart';
import '../models/forget_password/verify_reset_otp_request_model.dart';
import '../models/forget_password/verify_reset_otp_response_model.dart';
import '../models/forget_password/reset_password_request_model.dart';
import '../models/forget_password/reset_password_response_model.dart';
import '../repository/auth_repository.dart';

final forgotPasswordProvider =
AsyncNotifierProvider<ForgotPasswordNotifier, void>(
  ForgotPasswordNotifier.new,
);

class ForgotPasswordNotifier extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  String? _resetToken;

  @override
  Future<void> build() async {
    _repository = AuthRepository();
  }

  // Step 1: Send OTP
  Future<ForgotPasswordResponseModel> forgotPassword({
    required String email,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.forgotPassword(
        ForgotPasswordRequestModel(email: email.trim()),
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      state = const AsyncData(null);
      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  // Step 2: Verify OTP
  Future<VerifyResetOtpResponseModel> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.verifyResetOtp(
        VerifyResetOtpRequestModel(
          email: email.trim(),
          otp: otp.trim(),
        ),
      );

      if (!response.success || response.resetToken.isEmpty) {
        throw Exception(
          response.message.isNotEmpty
              ? response.message
              : 'Invalid OTP verification response',
        );
      }

      _resetToken = response.resetToken;

      state = const AsyncData(null);
      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  // Step 3: Reset Password
  Future<ResetPasswordResponseModel> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    if (_resetToken == null || _resetToken!.isEmpty) {
      throw Exception('Please verify OTP first');
    }

    state = const AsyncLoading();

    try {
      final response = await _repository.resetPassword(
        ResetPasswordRequestModel(
          resetToken: _resetToken!,
          password: password,
          confirmPassword: confirmPassword,
        ),
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      _resetToken = null;

      state = const AsyncData(null);
      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}