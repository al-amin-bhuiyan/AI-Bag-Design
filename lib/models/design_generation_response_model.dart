/// DesignGenerationResponseModel - Response model for design generation API
/// POST {{bag_app}}api/generate-design/
/// Response: {
///   "id": 6,
///   "bag_type": "gusset_fullwrap",
///   "preview_id": "a6bc62c4-82e4-48df-be72-e4214f1b462e",
///   "preview_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_front.png",
///   "dieline_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_back.png"
/// }
class DesignGenerationResponseModel {
  final int id;
  final String bagType;
  final String previewId;
  final String previewUrl;  // First image (CustomAssets.mockupImage1)
  final String dielineUrl;  // Second image (CustomAssets.mockupImage3)

  DesignGenerationResponseModel({
    required this.id,
    required this.bagType,
    required this.previewId,
    required this.previewUrl,
    required this.dielineUrl,
  });

  /// Factory constructor from JSON
  factory DesignGenerationResponseModel.fromJson(Map<String, dynamic> json) {
    return DesignGenerationResponseModel(
      id: json['id'] as int,
      bagType: json['bag_type'] as String,
      previewId: json['preview_id'] as String,
      previewUrl: json['preview_url'] as String,
      dielineUrl: json['dieline_url'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bag_type': bagType,
      'preview_id': previewId,
      'preview_url': previewUrl,
      'dieline_url': dielineUrl,
    };
  }

  @override
  String toString() =>
      'DesignGenerationResponse(id: $id, bagType: $bagType, previewId: $previewId, previewUrl: $previewUrl, dielineUrl: $dielineUrl)';
}
