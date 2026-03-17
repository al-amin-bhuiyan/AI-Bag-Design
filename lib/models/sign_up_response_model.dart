/// SignUpResponseModel - Response body from registration API
/// {
///   "msg": "Registration successful. Please check your email for OTP...",
///   "email": "mdshobuj204111@gmail.com",
///   "expires_in_minutes": 15
/// }
class SignUpResponseModel {
  final String message;
  final String email;
  final int expiresInMinutes;

  const SignUpResponseModel({
    required this.message,
    required this.email,
    required this.expiresInMinutes,
  });

  /// Creates model from JSON response
  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      message: json['msg'] as String? ?? '',
      email: json['email'] as String? ?? '',
      expiresInMinutes: json['expires_in_minutes'] as int? ?? 15,
    );
  }

  @override
  String toString() =>
      'SignUpResponseModel(email: $email, expiresInMinutes: $expiresInMinutes)';
}