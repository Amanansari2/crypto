class VerifyResetOtpRequestModel {
  final String email;
  final String otp;

  VerifyResetOtpRequestModel({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
    };
  }
}