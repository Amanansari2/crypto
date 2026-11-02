class VerifyResetOtpResponseModel {
  final bool success;
  final String message;
  final String resetToken;

  VerifyResetOtpResponseModel({
    required this.success,
    required this.message,
    required this.resetToken,
  });

  factory VerifyResetOtpResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : <String, dynamic>{};

    return VerifyResetOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      resetToken: data['reset_token'] ?? '',
    );
  }
}