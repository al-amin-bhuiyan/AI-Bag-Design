import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:jeebz_bag_design_app/models/design_generation_response_model.dart';
import 'package:jeebz_bag_design_app/models/generate_logo_response_model.dart';
import 'package:jeebz_bag_design_app/models/logo_upload_response_model.dart';
import 'package:jeebz_bag_design_app/services/token_storage_service.dart';
import '../models/api_response_model.dart';
import '../models/save_collection_response_model.dart';
import '../utils/app_constants.dart';
import 'api_service.dart';

/// BagDesignService - Service layer for bag design related API operations
/// Handles all bag design, collection, and preview related API calls
/// Follows OOP principles: encapsulation, single responsibility
class BagDesignService {
  // Private constructor - singleton pattern
  BagDesignService._();
  static final BagDesignService _instance = BagDesignService._();

  /// Singleton accessor
  static BagDesignService get instance => _instance;

  /// Uploads logo image and returns uploaded URL
  Future<ApiResponse<LogoUploadResponseModel>> uploadLogo({
    required File imageFile,
  }) async {
    try {
      final token = await TokenStorageService.instance.getAccessToken();
      final response = await ApiService.instance.postMultipart(
        endpoint: AppConstants.uploadLogoEndpoint,
        fields: {},
        imageFile: imageFile,
        imageFieldName: 'image',
        token: token,
      );

      if (response.success && response.data != null) {
        return ApiResponse.success(
          data: LogoUploadResponseModel.fromJson(response.data!),
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.errorMessage ?? 'Failed to upload logo',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to upload logo: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Generates design from uploaded logo URL
  Future<ApiResponse<DesignGenerationResponseModel>> generateDesign({
    required String bagType,
    required String logoUrl,
  }) async {
    final normalizedLogoUrl = _normalizeLogoUrlForGenerateDesign(logoUrl);
    debugPrint('🧾 generate-design payload => bag_type: $bagType, logo_url: $normalizedLogoUrl');
    final token = await TokenStorageService.instance.getAccessToken();
    final response = await ApiService.instance.post(
      endpoint: AppConstants.generateDesignEndpoint,
      body: {
        'bag_type': bagType,
        'logo_url': normalizedLogoUrl,
      },
      token: token,
      // AI generation can take several minutes.
      timeoutSeconds: AppConstants.aiGenerationTimeoutSeconds,
    );

    if (!response.success || response.data == null) {
      return ApiResponse.error(
        message: response.errorMessage ?? 'Failed to generate design',
        statusCode: response.statusCode,
      );
    }

    try {
      final model = DesignGenerationResponseModel.fromJson(response.data!);
      return ApiResponse.success(data: model, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(
        message: 'Invalid design generation response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Convenience method: upload logo first, then generate design
  Future<ApiResponse<DesignGenerationResponseModel>> uploadLogoAndGenerateDesign({
    required File logoFile,
    String bagType = 'gusset_fullwrap',
  }) async {
    final uploadResponse = await uploadLogo(imageFile: logoFile);
    if (!uploadResponse.success || uploadResponse.data == null) {
      return ApiResponse.error(
        message: uploadResponse.errorMessage ?? 'Logo upload failed',
        statusCode: uploadResponse.statusCode,
      );
    }

    return generateDesign(
      bagType: bagType,
      logoUrl: uploadResponse.data!.logoUrl,
    );
  }

  /// Generates logo image from a text prompt
  /// POST /api/generate-logo/
  /// Body: { "prompt": "string" }
  Future<ApiResponse<GenerateLogoResponseModel>> generateLogo({
    required String prompt,
  }) async {
    final token = await TokenStorageService.instance.getAccessToken();
    if (token == null || token.isEmpty) {
      return ApiResponse.error(
        message: 'Authentication required. Please login.',
        statusCode: 401,
      );
    }

    final response = await ApiService.instance.post(
      endpoint: AppConstants.generateLogoEndpoint,
      body: {
        'prompt': prompt,
      },
      token: token,
      timeoutSeconds: AppConstants.aiGenerationTimeoutSeconds,
    );

    if (!response.success || response.data == null) {
      return ApiResponse.error(
        message: response.errorMessage ?? 'Failed to generate logo',
        statusCode: response.statusCode,
      );
    }

    try {
      final model = GenerateLogoResponseModel.fromJson(response.data!);
      if (model.fullLogoUrl.trim().isEmpty) {
        return ApiResponse.error(
          message: 'Logo URL is missing in response',
          statusCode: response.statusCode,
        );
      }
      // Keep generate-logo response URL unchanged as returned by backend.
      return ApiResponse.success(data: model, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(
        message: 'Invalid generate logo response: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// Saves a generated design preview to user's collection
  /// POST /api/collections/save/
  /// Body: { "preview_id": "string" }
  /// Returns SaveCollectionResponseModel with design details
  Future<ApiResponse<SaveCollectionResponseModel>> saveDesignToCollection(
    String previewId,
  ) async {
    try {
      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('💼 BagDesignService: Saving design to collection');
      debugPrint('📋 PreviewID: $previewId');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Get authentication token
      final token = await TokenStorageService.instance.getAccessToken();

      if (token == null || token.isEmpty) {
        debugPrint('❌ No authentication token found');
        return ApiResponse.error(
          message: 'Authentication required. Please login.',
          statusCode: 401,
        );
      }

      // Prepare request body
      final body = {
        'preview_id': previewId,
      };

      // Call API
      final response = await ApiService.instance.post(
        endpoint: AppConstants.saveCollectionEndpoint,
        body: body,
        token: token,
      );

      if (!response.success) {
        debugPrint('❌ API call failed: ${response.errorMessage}');
        return ApiResponse.error(
          message: response.errorMessage ?? 'Failed to save design to collection',
          statusCode: response.statusCode,
        );
      }

      // Parse response data
      if (response.data == null) {
        debugPrint('❌ No data in response');
        return ApiResponse.error(
          message: 'Invalid response from server',
          statusCode: response.statusCode,
        );
      }

      // Convert to SaveCollectionResponseModel
      final saveCollectionResponse = SaveCollectionResponseModel.fromJson(response.data!);

      debugPrint('✅ Design saved successfully!');
      debugPrint('📊 Response:');
      debugPrint('   ID: ${saveCollectionResponse.id}');
      debugPrint('   Bag Type: ${saveCollectionResponse.bagType}');
      debugPrint('   Preview ID: ${saveCollectionResponse.previewId}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      return ApiResponse.success(
        data: saveCollectionResponse,
        statusCode: response.statusCode,
      );
    } catch (e) {
      debugPrint('❌ Exception in saveDesignToCollection: $e');
      return ApiResponse.error(
        message: 'An error occurred while saving the design: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Loads saved collection designs for the authenticated user.
  Future<ApiResponse<List<SaveCollectionResponseModel>>> getSavedDesigns() async {
    try {
      final token = await TokenStorageService.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          message: 'Authentication required. Please login.',
          statusCode: 401,
        );
      }

      final response = await ApiService.instance.get(
        endpoint: AppConstants.collectionsListEndpoint,
        token: token,
      );

      if (!response.success || response.data == null) {
        return ApiResponse.error(
          message: response.errorMessage ?? 'Failed to load designs',
          statusCode: response.statusCode,
        );
      }

      final items = _extractCollectionItems(response.data!);
      final designs = items
          .whereType<Map<String, dynamic>>()
          .map(SaveCollectionResponseModel.fromJson)
          .toList();

      return ApiResponse.success(data: designs, statusCode: response.statusCode);
    } catch (e) {
      return ApiResponse.error(
        message: 'An error occurred while loading designs: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Deletes a saved collection design for the authenticated user.
  /// DELETE /api/collections/{id}/
  Future<ApiResponse<bool>> deleteCollectionDesignById(String collectionId) async {
    try {
      final id = collectionId.trim();
      if (id.isEmpty) {
        return ApiResponse.error(
          message: 'Collection id is required.',
          statusCode: 400,
        );
      }

      final token = await TokenStorageService.instance.getAccessToken();
      if (token == null || token.isEmpty) {
        return ApiResponse.error(
          message: 'Authentication required. Please login.',
          statusCode: 401,
        );
      }

      final response = await ApiService.instance.delete(
        endpoint: AppConstants.collectionByIdEndpoint(id),
        token: token,
      );

      if (response.success) {
        return ApiResponse.success(
          data: true,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.error(
        message: response.errorMessage ?? 'Failed to delete design',
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'An error occurred while deleting design: ${e.toString()}',
        statusCode: 500,
      );
    }
  }



  List<dynamic> _extractCollectionItems(Map<String, dynamic> data) {
    if (data['results'] is List) return data['results'] as List<dynamic>;
    if (data['data'] is List) return data['data'] as List<dynamic>;
    if (data['items'] is List) return data['items'] as List<dynamic>;

    // Fallback for single-object response shape.
    if (data.containsKey('id')) {
      return <dynamic>[data];
    }
    return const <dynamic>[];
  }

  /// Normalizes logo URL for generate-design payload.
  /// generate-design expects media URLs on AppConstants.baseUrl.
  /// Converts uploads URLs like /uploads/{file} to /media/logos/{file}.
  String _normalizeLogoUrlForGenerateDesign(String inputUrl) {
    final trimmed = inputUrl.trim();
    if (trimmed.isEmpty) return trimmed;

    final sourceUri = Uri.tryParse(trimmed);
    if (sourceUri == null) return trimmed;

    final appBaseUri = Uri.parse(AppConstants.baseUrl);
    final isAlreadyAppHost =
        sourceUri.host == appBaseUri.host && sourceUri.port == appBaseUri.port;
    if (isAlreadyAppHost) {
      return trimmed;
    }

    if (sourceUri.path.startsWith('/uploads/') && sourceUri.pathSegments.isNotEmpty) {
      final fileName = sourceUri.pathSegments.last;
      final normalized = appBaseUri.replace(
        path: '/media/logos/$fileName',
      );
      debugPrint('🔁 Normalized logo_url for generate-design: $trimmed -> $normalized');
      return normalized.toString();
    }

    if (trimmed.startsWith('/uploads/')) {
      final normalized = '${AppConstants.baseUrl}/media/logos/${trimmed.split('/').last}';
      debugPrint('🔁 Normalized relative logo_url for generate-design: $trimmed -> $normalized');
      return normalized;
    }

    return trimmed;
  }

}
