class ResetPasswordRequestModel {
  final String resetToken;
  final String password;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.resetToken,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'reset_token': resetToken,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}