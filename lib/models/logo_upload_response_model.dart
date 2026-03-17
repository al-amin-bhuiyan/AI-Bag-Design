/// LogoUploadResponseModel - Response model for logo upload API
/// POST {{ai_bag}}api/upload-logo/
/// Response: { "logo_url": "http://10.10.7.74:8000/media/logos/Apple_HSOZgtf.png" }
class LogoUploadResponseModel {
  final String logoUrl;

  LogoUploadResponseModel({required this.logoUrl});

  /// Factory constructor from JSON
  factory LogoUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoUploadResponseModel(
      logoUrl: json['logo_url'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'logo_url': logoUrl,
    };
  }

  @override
  String toString() => 'LogoUploadResponse(logoUrl: $logoUrl)';
}
