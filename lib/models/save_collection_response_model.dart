/// SaveCollectionResponseModel - Response model for saving a design to collection
/// POST {{bag_app}}api/collections/save/
/// Body: { "preview_id": "08059ba2-81a8-4c49-952f-9a58c5b0a01d" }
/// Response: {
///     "id": 16,
///     "bag_type": "gusset_fullwrap",
///     "logo_url": "http://10.10.7.74:8000/media/logos/scaled_2f14b4f0-32c2-4ff2-b475-a5067facfdda-1_all_239.jpg",
///     "preview_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_front.png",
///     "dieline_url": "http://10.10.7.82:8008/results/bag_gusset_fullwrap_back.png",
///     "preview_id": "08059ba2-81a8-4c49-952f-9a58c5b0a01d",
///     "created_at": "2026-03-14T18:52:26.205718Z"
/// }
class SaveCollectionResponseModel {
  final int id;
  final String bagType;
  final String logoUrl;
  final String previewUrl;
  final String dielineUrl;
  final String previewId;
  final String createdAt;

  SaveCollectionResponseModel({
    required this.id,
    required this.bagType,
    required this.logoUrl,
    required this.previewUrl,
    required this.dielineUrl,
    required this.previewId,
    required this.createdAt,
  });

  /// Factory constructor from JSON
  factory SaveCollectionResponseModel.fromJson(Map<String, dynamic> json) {
    return SaveCollectionResponseModel(
      id: json['id'] as int? ?? 0,
      bagType: json['bag_type'] as String? ?? '',
      logoUrl: json['logo_url'] as String? ?? '',
      previewUrl: _readImageUrl(
        json,
        keys: const <String>[
          'preview_url',
          'previewUrl',
          'preview',
          'front_url',
          'frontUrl',
          'front',
          'image_url',
          'imageUrl',
          'image',
        ],
        preferredHints: const <String>['front', 'preview'],
      ),
      dielineUrl: _readImageUrl(
        json,
        keys: const <String>[
          'dieline_url',
          'dielineUrl',
          'dieline',
          'back_url',
          'backUrl',
          'back',
        ],
        preferredHints: const <String>['back', 'dieline'],
      ),
      previewId: json['preview_id'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  /// Slider images should only come from preview + dieline.
  List<String> get sliderImageUrls {
    final urls = <String>[];
    for (final value in <String>[previewUrl.trim(), dielineUrl.trim()]) {
      if (value.isNotEmpty && !urls.contains(value)) {
        urls.add(value);
      }
    }
    return urls;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bag_type': bagType,
      'logo_url': logoUrl,
      'preview_url': previewUrl,
      'dieline_url': dielineUrl,
      'preview_id': previewId,
      'created_at': createdAt,
    };
  }

  @override
  String toString() =>
      'SaveCollectionResponseModel(id: $id, bagType: $bagType, logoUrl: $logoUrl, previewId: $previewId)';

  static String _readImageUrl(
    Map<String, dynamic> json, {
    required List<String> keys,
    required List<String> preferredHints,
  }) {
    final candidates = <String>[];

    // Collect direct and nested URL values from preferred keys first.
    for (final key in keys) {
      _collectSupportedUrls(json[key], candidates);
    }

    // Fallback: collect any URL-like values from full payload.
    _collectSupportedUrls(json, candidates);

    if (candidates.isEmpty) return '';

    for (final candidate in candidates) {
      final normalized = candidate.toLowerCase();
      for (final hint in preferredHints) {
        if (normalized.contains(hint.toLowerCase())) {
          return candidate;
        }
      }
    }

    return candidates.first;
  }

  static void _collectSupportedUrls(dynamic value, List<String> output) {
    if (value is String) {
      final normalized = value.trim();
      if (normalized.isNotEmpty && !output.contains(normalized)) {
        output.add(normalized);
      }
      return;
    }

    if (value is Map<String, dynamic>) {
      for (final entry in value.entries) {
        _collectSupportedUrls(entry.value, output);
      }
      return;
    }

    if (value is List) {
      for (final item in value) {
        _collectSupportedUrls(item, output);
      }
    }
  }

}
