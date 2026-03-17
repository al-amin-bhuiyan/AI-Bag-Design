/// LoginRequestModel - Request body for login API
/// POST /accounts/user/login/
class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  @override
  String toString() => 'LoginRequestModel(email: $email)';
}

/// LoginUserModel - User info returned inside login response
class LoginUserModel {
  final int id;
  final String email;
  final String name;
  final String image;
  final bool isAdmin;

  const LoginUserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.image,
    required this.isAdmin,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }

  @override
  String toString() => 'LoginUserModel(id: $id, email: $email, name: $name)';
}

/// LoginResponseModel - Full response from POST /accounts/user/login/
/// {
///   "access": "...",
///   "refresh": "...",
///   "user": { "id":4, "email":"...", "name":"...", "image":"...", "is_admin":false }
/// }
class LoginResponseModel {
  final String accessToken;
  final String refreshToken;
  final LoginUserModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access'] as String? ?? '',
      refreshToken: json['refresh'] as String? ?? '',
      user: LoginUserModel.fromJson(
          json['user'] as Map<String, dynamic>? ?? {}),
    );
  }

  @override
  String toString() =>
      'LoginResponseModel(user: ${user.email}, hasAccess: ${accessToken.isNotEmpty})';
}
