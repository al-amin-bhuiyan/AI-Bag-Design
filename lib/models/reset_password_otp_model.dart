/// ResetPasswordOtpResponseModel
/// Response from POST /accounts/user/reset-password-otp/
/// { "reset_token": "23387a12-313e-493f-8af3-8202e50a6e82" }
class ResetPasswordOtpResponseModel {
  final String resetToken;

  const ResetPasswordOtpResponseModel({required this.resetToken});

  factory ResetPasswordOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordOtpResponseModel(
      resetToken: json['reset_token'] as String? ?? '',
    );
  }

  @override
  String toString() =>
      'ResetPasswordOtpResponseModel(resetToken: $resetToken)';
}
