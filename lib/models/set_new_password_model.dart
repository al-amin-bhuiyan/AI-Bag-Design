/// SetNewPasswordRequestModel
/// Body for POST /accounts/user/set-new-password/
class SetNewPasswordRequestModel {
  final String resetToken;
  final String newPassword;
  final String newPassword2;

  const SetNewPasswordRequestModel({
    required this.resetToken,
    required this.newPassword,
    required this.newPassword2,
  });

  Map<String, dynamic> toJson() => {
        'reset_token': resetToken,
        'new_password': newPassword,
        'new_password2': newPassword2,
      };

  @override
  String toString() => 'SetNewPasswordRequestModel(resetToken: $resetToken)';
}

/// SetNewPasswordResponseModel
/// Response from POST /accounts/user/set-new-password/
/// { "msg": "Password reset successfully" }
class SetNewPasswordResponseModel {
  final String message;

  const SetNewPasswordResponseModel({required this.message});

  factory SetNewPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return SetNewPasswordResponseModel(
      message: json['msg'] as String? ??
          json['message'] as String? ??
          'Password reset successfully',
    );
  }

  @override
  String toString() => 'SetNewPasswordResponseModel(message: $message)';
}
