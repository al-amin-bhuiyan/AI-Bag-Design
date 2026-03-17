/// DeleteAccountResponseModel - Response from DELETE /accounts/user/delete-account/
/// Response: { "msg": "Account satipog496@medevsa.com deleted successfully." }
class DeleteAccountResponseModel {
  final String message;

  const DeleteAccountResponseModel({required this.message});

  factory DeleteAccountResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponseModel(
      message: json['msg'] as String? ??
          json['message'] as String? ??
          'Account deleted successfully.',
    );
  }

  @override
  String toString() => 'DeleteAccountResponseModel(message: $message)';
}
