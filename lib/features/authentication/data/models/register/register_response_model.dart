class AuthResponseModel {
  final bool success;
  final String message;

  const AuthResponseModel({
    required this.success,
    required this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}