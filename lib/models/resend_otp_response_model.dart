/// ResendOtpResponseModel - Response from POST /accounts/user/resend-otp/
/// Success:  { "msg": "OTP sent successfully" }
/// Error:    { "errors": { "email": ["Account is already activated."] } }
class ResendOtpResponseModel {
  final String message;

  const ResendOtpResponseModel({required this.message});

  factory ResendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponseModel(
      message: json['msg'] as String? ?? '',
    );
  }

  @override
  String toString() => 'ResendOtpResponseModel(message: $message)';
}
