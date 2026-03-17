/// SendResetPasswordEmailResponseModel
/// Response from POST /accounts/user/send-reset-password-email/
/// { "msg": "Password Reset OTP send. Please check your Email" }
class SendResetPasswordEmailResponseModel {
  final String message;

  const SendResetPasswordEmailResponseModel({required this.message});

  factory SendResetPasswordEmailResponseModel.fromJson(
      Map<String, dynamic> json) {
    return SendResetPasswordEmailResponseModel(
      message: json['msg'] as String? ??
          json['message'] as String? ??
          'Password reset OTP sent. Please check your email.',
    );
  }

  @override
  String toString() =>
      'SendResetPasswordEmailResponseModel(message: $message)';
}
