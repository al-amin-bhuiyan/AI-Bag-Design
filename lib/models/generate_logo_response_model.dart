/// GenerateLogoResponseModel - Response model for text prompt logo generation API
/// POST {{bag_app}}api/generate-logo/
/// Body: { "prompt": "..." }
/// Response: { "full_logo_url": "http://..." }
class GenerateLogoResponseModel {
  final String fullLogoUrl;

  const GenerateLogoResponseModel({
    required this.fullLogoUrl,
  });

  factory GenerateLogoResponseModel.fromJson(Map<String, dynamic> json) {
    return GenerateLogoResponseModel(
      fullLogoUrl: json['full_logo_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_logo_url': fullLogoUrl,
    };
  }
}
