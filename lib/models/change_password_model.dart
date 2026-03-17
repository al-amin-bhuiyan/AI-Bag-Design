/// ChangePasswordRequestModel - Request body for POST /accounts/user/change-password/
/// Body: { "current_password": "...", "new_password": "...", "confirm_new_password": "..." }
class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  const ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      };

  @override
  String toString() => 'ChangePasswordRequestModel(currentPassword: ****, newPassword: ****)';
}

/// ChangePasswordResponseModel - Response from POST /accounts/user/change-password/
/// Response: { "msg": "Password changed successfully" }
class ChangePasswordResponseModel {
  final String message;

  const ChangePasswordResponseModel({required this.message});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      message: json['msg'] as String? ??
          json['message'] as String? ??
          'Password changed successfully',
    );
  }

  @override
  String toString() => 'ChangePasswordResponseModel(message: $message)';
}
