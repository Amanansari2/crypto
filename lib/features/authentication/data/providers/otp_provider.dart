import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/otp/otp_request_model.dart';
import '../models/otp/otp_response_model.dart';
import '../repository/auth_repository.dart';

final otpProvider =
AsyncNotifierProvider<OtpNotifier, OtpResponseModel?>(
  OtpNotifier.new,
);

class OtpNotifier extends AsyncNotifier<OtpResponseModel?> {
  late final AuthRepository _repository;

  @override
  Future<OtpResponseModel?> build() async {
    _repository = AuthRepository();
    return null;
  }

  Future<OtpResponseModel?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.verifyEmail(
        VerifyOtpRequestModel(
          email: email,
          otp: otp,
        ),
      );

      state = AsyncData(response);
      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<OtpResponseModel?> resendOtp({
    required String email,
  }) async {
    state = const AsyncLoading();

    try {
      final response = await _repository.resendVerification(
        ResendOtpRequestModel(email: email),
      );

      state = AsyncData(response);
      return response;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }


}