/// OtpTokenModel - JWT token pair returned after OTP verification
class OtpTokenModel {
  final String refresh;
  final String access;

  const OtpTokenModel({
    required this.refresh,
    required this.access,
  });

  factory OtpTokenModel.fromJson(Map<String, dynamic> json) {
    return OtpTokenModel(
      refresh: json['refresh'] as String? ?? '',
      access: json['access'] as String? ?? '',
    );
  }

  @override
  String toString() => 'OtpTokenModel(access: $access)';
}

/// OtpVerifyUserModel - User info returned after OTP verification
class OtpVerifyUserModel {
  final int id;
  final String email;
  final String name;

  const OtpVerifyUserModel({
    required this.id,
    required this.email,
    required this.name,
  });

  factory OtpVerifyUserModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyUserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  @override
  String toString() => 'OtpVerifyUserModel(id: $id, email: $email, name: $name)';
}

/// OtpVerifyResponseModel - Full response from POST /accounts/user/verify-otp/
/// {
///   "msg": "Account activated successfully",
///   "token": { "refresh": "...", "access": "..." },
///   "user": { "id": 3, "email": "...", "name": "..." }
/// }
class OtpVerifyResponseModel {
  final String message;
  final OtpTokenModel token;
  final OtpVerifyUserModel user;

  const OtpVerifyResponseModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory OtpVerifyResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponseModel(
      message: json['msg'] as String? ?? '',
      token: OtpTokenModel.fromJson(json['token'] as Map<String, dynamic>? ?? {}),
      user: OtpVerifyUserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  String toString() =>
      'OtpVerifyResponseModel(msg: $message, user: ${user.email})';
}
