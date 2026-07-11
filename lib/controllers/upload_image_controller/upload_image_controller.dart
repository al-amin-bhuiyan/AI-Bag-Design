import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../your_design_controller/your_design_controller.dart';
import '../collections_controller/collections_controller.dart';
import '../../services/bag_design_service.dart';

/// UploadImageController - Manages upload image screen state and business logic
/// Follows OOP principles with clear separation of concerns
class UploadImageController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============

  /// Loading state
  final _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  /// Selected image path
  final _selectedImagePath = Rx<String?>(null);
  String? get selectedImagePath => _selectedImagePath.value;

  /// Generated design preview URL (from API response → preview_url)
  final _previewUrl = Rx<String?>(null);
  String? get previewUrl => _previewUrl.value;

  /// Generated design dieline URL (from API response → dieline_url)
  final _dielineUrl = Rx<String?>(null);
  String? get dielineUrl => _dielineUrl.value;

  /// Generated preview ID (from API response → preview_id)
  final _generatedPreviewId = Rx<String?>(null);
  String? get generatedPreviewId => _generatedPreviewId.value;

  /// Whether generated images are available from network URLs.
  final _hasGeneratedImages = false.obs;
  bool get hasGeneratedImages => _hasGeneratedImages.value;

  // ============ DEPENDENCIES ============

  final ImagePicker _imagePicker = ImagePicker();
  final BagDesignService _bagDesignService = BagDesignService.instance;

  // ============ LIFECYCLE METHODS ============

  @override
  void onInit() {
    super.onInit();
    print('📸 UploadImageController initialized');
  }

  @override
  void onClose() {
    print('📸 UploadImageController disposed');
    super.onClose();
  }

  // ============ IMAGE PICKER METHODS ============

  /// Picks image from gallery
  Future<void> pickImage(BuildContext context) async {
    print('📸 Picking image from gallery');
    _setLoading(true);
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (image != null) {
        _selectedImagePath.value = image.path;
        _previewUrl.value = null;
        _dielineUrl.value = null;
        _generatedPreviewId.value = null;
        _hasGeneratedImages.value = false;
        print('✅ Image selected: ${image.path}');
      } else {
        print('❌ No image selected');
        _showToast('No image selected', isError: false);
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      _showToast('Failed to pick image', isError: true);
    } finally {
      _setLoading(false);
    }
  }

  // ============ CORE API METHOD ============

  /// Uploads the selected logo and generates bag design via API.
  /// [bagType] should match the API value e.g. 'gusset_fullwrap'
  /// Returns true on success, false on failure.
  Future<bool> generateBagDesign({String bagType = 'gusset_fullwrap'}) async {
    if (_selectedImagePath.value == null) {
      _showToast('Please select an image first', isError: true);
      return false;
    }

    final logoFile = File(_selectedImagePath.value!);

    print('🚀 Starting upload + generate for bagType: $bagType');

    try {
      final response = await _bagDesignService.uploadLogoAndGenerateDesign(
        logoFile: logoFile,
        bagType: bagType,
      );

      if (response.success && response.data != null) {
        _previewUrl.value = response.data!.previewUrl;
        _dielineUrl.value = response.data!.dielineUrl;
        _generatedPreviewId.value = response.data!.previewId;
        _hasGeneratedImages.value = true;
        print('✅ Design generated → preview: ${_previewUrl.value}');
        print('✅ Design generated → dieline: ${_dielineUrl.value}');
        print('✅ Design generated → preview_id: ${_generatedPreviewId.value}');
        return true;
      } else {
        _previewUrl.value = null;
        _dielineUrl.value = null;
        _generatedPreviewId.value = null;
        _hasGeneratedImages.value = false;
        print('❌ API error: ${response.errorMessage}');
        if (!_isSilentAuthError(response.errorMessage, response.statusCode)) {
          _showToast('Bag design deos not successfull', isError: true);
        }
        return false;
      }
    } catch (e) {
      _previewUrl.value = null;
      _dielineUrl.value = null;
      _generatedPreviewId.value = null;
      _hasGeneratedImages.value = false;
      print('❌ Exception during generation: $e');
      _showToast('Bag design deos not successfull', isError: true);
      return false;
    }
  }

  // ============ UTILITY METHODS ============

  /// Returns generated mockup image URLs for MockupDialog.
  List<String> get mockupImages {
    if (_hasGeneratedImages.value &&
        _previewUrl.value != null &&
        _dielineUrl.value != null) {
      return [_previewUrl.value!, _dielineUrl.value!];
    }
    return <String>[];
  }

  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Shows a fluttertoast message
  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? const Color(0xFFF44336) : const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  bool _isSilentAuthError(String? message, int? statusCode) {
    if (statusCode == 401 || statusCode == 403) return true;
    final text = (message ?? '').toLowerCase();
    return text.contains('authentication required') ||
        text.contains('authentication failed') ||
        text.contains('please login') ||
        text.contains('please log in') ||
        text.contains('unauthorized');
  }

  /// Resets controller state
  void reset() {
    _selectedImagePath.value = null;
    _previewUrl.value = null;
    _dielineUrl.value = null;
    _generatedPreviewId.value = null;
    _hasGeneratedImages.value = false;
    _isLoading.value = false;
  }

  /// Refreshes the screen
  Future<void> refresh() async {
    print('🔄 Refreshing upload screen');
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    reset();
    _setLoading(false);
  }

  /// Saves the selected image to YourDesign
  void saveImage() {
    if (_selectedImagePath.value != null) {
      print('💾 Saving image: ${_selectedImagePath.value}');
      YourDesignController yourDesignController;
      try {
        yourDesignController = Get.find<YourDesignController>();
      } catch (e) {
        yourDesignController = YourDesignController();
        Get.put(yourDesignController);
      }
      yourDesignController.addSavedImage(_selectedImagePath.value!);
    }
  }

  /// Called when Show Bag Design button is tapped (for logging only)
  void showBagDesign(BuildContext context) {
    print('👜 Show Bag Design tapped');
  }

  /// Saves generated design to server collection and injects response into Your Design.
  Future<bool> saveGeneratedLogoToYourDesign() async {
    if (_generatedPreviewId.value == null || _generatedPreviewId.value!.isEmpty) {
      _showToast('Preview ID not available. Please generate design first.', isError: true);
      return false;
    }

    _setLoading(true);

    try {
      // Save to backend using /api/collections/save/ and update Your Design list.
      final yourDesignController = Get.isRegistered<YourDesignController>()
          ? Get.find<YourDesignController>()
          : Get.put(YourDesignController());

      final isSaved = await yourDesignController.saveDesignToCollection(
        _generatedPreviewId.value!,
      );
      return isSaved;
    } catch (e) {
      _showToast('Failed to save image. Please try again.', isError: true);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Adds first mockup image to collections
  Future<bool> addMockupToCollections() async {
    print('📁 Adding generated design to collections');

    if (_generatedPreviewId.value == null || _generatedPreviewId.value!.isEmpty) {
      _showToast('Preview ID not available. Please generate design first.', isError: true);
      return false;
    }

    try {
      CollectionsController collectionsController;
      try {
        collectionsController = Get.find<CollectionsController>();
      } catch (e) {
        collectionsController = CollectionsController();
        Get.put(collectionsController);
      }

      final isSaved = await collectionsController.saveDesignToCollection(
        _generatedPreviewId.value!,
      );

      if (isSaved) {
        print('✅ Design saved to collections API');
      }

      return isSaved;
    } catch (e) {
      print('❌ Error adding mockup to collections: $e');
      _showToast('Failed to add mockup to collections', isError: true);
      return false;
    }
  }
}