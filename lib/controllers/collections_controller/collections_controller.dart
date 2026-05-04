import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../models/save_collection_response_model.dart';
import '../../services/bag_design_service.dart';
import '../../services/network/network_manager.dart';


/// CollectionsController manages collections screen logic and API state.
class CollectionsController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Loading state
  final RxBool _isLoading = false.obs;
  
  /// Selected filter/category
  final RxString _selectedCategory = 'All'.obs;
  
  /// Saved images from upload (user-added designs)
  final RxList<String> _savedImages = <String>[].obs;
  
  /// Collection designs fetched from API
  final RxList<SaveCollectionResponseModel> _collectionDesigns =
      <SaveCollectionResponseModel>[].obs;

  // ============ GETTERS ============
  
  bool get isLoading => _isLoading.value;
  String get selectedCategory => _selectedCategory.value;
  List<String> get savedImages => _savedImages;
  List<SaveCollectionResponseModel> get collectionDesigns => _collectionDesigns;

  // ============ LIFECYCLE METHODS ============
  
  @override
  void onInit() {
    super.onInit();
    resetState();
    fetchCollections();
    
    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored: Auto-refreshing collections...');
          fetchCollections();
        }
      });
    }
  }

  /// Clears all in-memory collection data.
  void resetState() {
    _selectedCategory.value = 'All';
    _savedImages.clear();
    _collectionDesigns.clear();
    _isLoading.value = false;
  }
  
  // ============ PUBLIC METHODS ============
  
  /// Handles bag item tap
  void onBagTap(int index, bool isLabelBag) {
    debugPrint('Bag tapped - Index: $index, IsLabel: $isLabelBag');
  }
  
  /// Changes selected category
  void changeCategory(String category) {
    _selectedCategory.value = category;
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
    }
  }
  
  /// Calls GET /api/collections/ with Bearer token.
  Future<void> fetchCollections() async {
    _isLoading.value = true;
    try {
      final response = await BagDesignService.instance.getSavedDesigns();

      if (response.success && response.data != null) {
        _collectionDesigns
          ..clear()
          ..addAll(response.data!);
      } else {
        _collectionDesigns.clear();
        if (!_isSilentAuthError(response.errorMessage, response.statusCode)) {
          _showMessage(response.errorMessage ?? 'Failed to load collections');
        }
      }
    } catch (e) {
      _collectionDesigns.clear();
      _showMessage('Failed to load collections: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Refreshes collections data
  @override
  Future<void> refresh() async {
    await fetchCollections();
  }

  /// Calls POST /api/collections/save/ with preview_id and updates list.
  Future<bool> saveDesignToCollection(String previewId) async {
    if (previewId.trim().isEmpty) {
      _showMessage('Preview ID not available. Please generate design first.');
      return false;
    }

    _isLoading.value = true;
    try {
      final response = await BagDesignService.instance.saveDesignToCollection(previewId);
      if (response.success && response.data != null) {
        final savedItem = response.data!;

        // Prevent duplicate cards if the same preview is saved twice.
        _collectionDesigns.removeWhere((item) => item.previewId == savedItem.previewId);
        _collectionDesigns.insert(0, savedItem);

        return true;
      }

      if (_isSilentAuthError(response.errorMessage, response.statusCode)) {
        return false;
      }
      _showMessage(response.errorMessage ?? 'Failed to save to collection');
      return false;
    } catch (e) {
      _showMessage('Failed to save to collection: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  /// Adds a saved image to the collection
  void addSavedImage(String imagePath) {
    if (!_savedImages.contains(imagePath)) {
      _savedImages.add(imagePath);
    }
  }
  
  /// Removes a saved image from the collection
  void removeSavedImage(String imagePath) {
    _savedImages.remove(imagePath);
  }

  /// Removes a collection design from in-memory list by backend id.
  void removeCollectionDesignById(String id) {
    _collectionDesigns.removeWhere((item) => item.id.toString() == id);
  }
  
  // ============ PRIVATE METHODS ============
  
  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
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
}