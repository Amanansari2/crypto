import 'package:dio/dio.dart';

import '../../../../../core/network/methods/post_method.dart';
import '../../../../../core/utils/constants/api_urls.dart';
import '../models/forget_password/forget_password_request_model.dart';
import '../models/forget_password/forgot_password_response_model.dart';
import '../models/forget_password/reset_password_request_model.dart';
import '../models/forget_password/reset_password_response_model.dart';
import '../models/forget_password/verify_reset_otp_request_model.dart';
import '../models/forget_password/verify_reset_otp_response_model.dart';
import '../models/login/login_request_model.dart';
import '../models/login/login_response_model.dart';
import '../models/otp/otp_request_model.dart';
import '../models/otp/otp_response_model.dart';
import '../models/register/register_response_model.dart';
import '../models/register/register_request_model.dart';


class AuthRepository {
  final PostMethod _postMethod = PostMethod();

  Future<AuthResponseModel> register(RegisterRequestModel request,) async {
    final response = await _postMethod.postRequest(
      endpoint: ApiUrls.register,
      data: request.toJson(),
    );

    return AuthResponseModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }


  Future<OtpResponseModel> verifyEmail(VerifyOtpRequestModel request,) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.verifyEmail,
        data: request.toJson(),
        requireAuth: false,
      );

      return OtpResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      throw Exception(message ?? 'OTP verification failed');
    }
  }

  Future<OtpResponseModel> resendVerification(
      ResendOtpRequestModel request,) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.resendVerification,
        data: request.toJson(),
        requireAuth: false,
      );

      return OtpResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      throw Exception(message ?? 'Unable to resend OTP');
    }
  }


  Future<LoginResponseModel> login(
      LoginRequestModel request,
      ) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.login,
        data: request.toJson(),
        requireAuth: false,
      );

      return LoginResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      throw Exception(message ?? 'Login failed. Please try again.');
    }
  }



  // Forgot Password
  Future<ForgotPasswordResponseModel> forgotPassword(
      ForgotPasswordRequestModel request,
      ) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.forgotPassword,
        data: request.toJson(),
        requireAuth: false,
      );

      return ForgotPasswordResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;
      throw Exception(message ?? 'Unable to send reset OTP');
    }
  }

// Verify Reset OTP
  Future<VerifyResetOtpResponseModel> verifyResetOtp(
      VerifyResetOtpRequestModel request,
      ) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.verifyResetOtp,
        data: request.toJson(),
        requireAuth: false,
      );

      return VerifyResetOtpResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;
      throw Exception(message ?? 'OTP verification failed');
    }
  }

// Reset Password
  Future<ResetPasswordResponseModel> resetPassword(
      ResetPasswordRequestModel request,
      ) async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.resetPassword,
        data: request.toJson(),
        requireAuth: false,
      );

      return ResetPasswordResponseModel.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map ? data['message']?.toString() : null;
      throw Exception(message ?? 'Unable to reset password');
    }
  }


  Future<void> logout() async {
    try {
      final response = await _postMethod.postRequest(
        endpoint: ApiUrls.logout,
        data: {},
        requireAuth: true,
      );

      final data = Map<String, dynamic>.from(response.data as Map);

      if (data['success'] != true) {
        throw Exception(data['message'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      final message =
      data is Map ? data['message']?.toString() : null;

      throw Exception(message ?? 'Unable to logout');
    }
  }


}