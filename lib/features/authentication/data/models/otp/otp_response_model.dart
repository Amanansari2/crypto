class OtpResponseModel {
  final bool success;
  final String message;
  final OtpUserModel? user;

  OtpResponseModel({
    required this.success,
    required this.message,
    this.user,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return OtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      user: data is Map && data['user'] is Map
          ? OtpUserModel.fromJson(
        Map<String, dynamic>.from(data['user']),
      )
          : null,
    );
  }
}

class OtpUserModel {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final bool isEmailVerified;
  final String accountStatus;
  final String? emailVerifiedAt;
  final String? createdAt;

  OtpUserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isEmailVerified,
    required this.accountStatus,
    this.emailVerifiedAt,
    this.createdAt,
  });

  factory OtpUserModel.fromJson(Map<String, dynamic> json) {
    return OtpUserModel(
      uid: json['uid'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      isEmailVerified: json['is_email_verified'] ?? false,
      accountStatus: json['account_status'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
    );
  }
}