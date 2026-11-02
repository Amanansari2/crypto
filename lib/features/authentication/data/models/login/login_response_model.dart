
class LoginResponseModel {
  final bool success;
  final String message;
  final String token;
  final LoginUserModel user;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data['token'] ?? '',
      user: LoginUserModel.fromJson(
        Map<String, dynamic>.from(data['user'] as Map),
      ),
    );
  }
}

class LoginUserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final bool isEmailVerified;
  final String accountStatus;
  final String? emailVerifiedAt;
  final String? createdAt;

  LoginUserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.accountStatus,
    this.emailVerifiedAt,
    this.createdAt,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      uid: json['uid'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      isEmailVerified: json['is_email_verified'] ?? false,
      accountStatus: json['account_status'] ?? '',
      emailVerifiedAt: json['email_verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'is_email_verified': isEmailVerified,
      'account_status': accountStatus,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
    };
  }
}
