/// SignUpRequestModel - Request body for registration API
/// POST /accounts/user/register/
class SignUpRequestModel {
  final String email;
  final String name;
  final String password;
  final String password2;

  const SignUpRequestModel({
    required this.email,
    required this.name,
    required this.password,
    required this.password2,
  });

  /// Converts model to JSON map for API request
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'password2': password2,
    };
  }

  @override
  String toString() =>
      'SignUpRequestModel(email: $email, name: $name)';
}
