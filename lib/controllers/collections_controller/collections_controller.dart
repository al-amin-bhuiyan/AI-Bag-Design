import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// CollectionsController manages collections screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class CollectionsController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Loading state
  final RxBool _isLoading = false.obs;
  
  /// Selected filter/category
  final RxString _selectedCategory = 'All'.obs;
  
  /// Saved images from upload (user-added designs)
  final RxList<String> _savedImages = <String>[].obs;
  
  // ============ GETTERS ============
  
  bool get isLoading => _isLoading.value;
  String get selectedCategory => _selectedCategory.value;
  List<String> get savedImages => _savedImages;
  
  // ============ LIFECYCLE METHODS ============
  
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  @override
  void onClose() {
    _cleanup();
    super.onClose();
  }
  
  // ============ INITIALIZATION ============
  
  /// Initializes the controller
  void _initialize() {
    _loadCollections();
  }
  
  /// Loads collection data
  Future<void> _loadCollections() async {
    _setLoading(true);
    try {
      // TODO: Load collections from API or local storage
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleError('Failed to load collections: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ PUBLIC METHODS ============
  
  /// Handles bag item tap
  void onBagTap(int index, bool isLabelBag) {
    print('🔵 Bag tapped - Index: $index, IsLabel: $isLabelBag');
    // TODO: Navigate to bag detail screen
    _showMessage('Bag ${index + 1} selected');
  }
  
  /// Changes selected category
  void changeCategory(String category) {
    _selectedCategory.value = category;
    print('🔵 Category changed to: $category');
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
      print('🔵 Navigated back from Collections');
    }
  }
  
  /// Refreshes collections data
  Future<void> refresh() async {
    await _loadCollections();
  }
  
  /// Adds a saved image to the collection
  void addSavedImage(String imagePath) {
    if (!_savedImages.contains(imagePath)) {
      _savedImages.add(imagePath);
      print('✅ Image added to collections: $imagePath');
      _showMessage('Design saved to collections!');
    } else {
      print('⚠️ Image already exists in collections');
      _showMessage('Design already in collections');
    }
  }
  
  /// Removes a saved image from the collection
  void removeSavedImage(String imagePath) {
    if (_savedImages.contains(imagePath)) {
      _savedImages.remove(imagePath);
      print('🗑️ Image removed from collections: $imagePath');
      _showMessage('Design removed from collections');
    }
  }
  
  // ============ PRIVATE METHODS ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Handles errors
  void _handleError(String message) {
    print('❌ Error: $message');
    _showMessage(message);
  }
  
  /// Cleanup resources
  void _cleanup() {
    // Clean up any resources if needed
  }
  
  // ============ UTILITY METHODS ============
  
  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  // ============ DATA METHODS ============
  
  /// Returns list of label bag images
  List<String> getLabelBagImages() {
    return [
      'assets/images/label_bag_1.png',
      'assets/images/label_bag_2.png',
      'assets/images/label_bag_3.png',
      'assets/images/label_bag_4.png',
      'assets/images/label_bag_5.png',
      'assets/images/label_bag_6.png',
    ];
  }
  
  /// Returns list of full graphic bag images
  List<String> getFullGraphicBagImages() {
    return [
      'assets/images/full_graphic_bag_1.png',
      'assets/images/full_graphic_bag_2.png',
      'assets/images/full_graphic_bag_3.png',
      'assets/images/full_graphic_bag_4.png',
      'assets/images/full_graphic_bag_5.png',
      'assets/images/full_graphic_bag_6.png',
    ];
  }
  
  /// Returns combined collection of bags (alternating label and full graphic)
  List<CollectionBagItem> getCollectionItems() {
    final labelBags = getLabelBagImages();
    final fullGraphicBags = getFullGraphicBagImages();
    final items = <CollectionBagItem>[];
    
    // Create alternating pattern: Label, Full Graphic, Label, Full Graphic...
    for (int i = 0; i < 6; i++) {
      items.add(CollectionBagItem(
        imagePath: labelBags[i],
        isLabelBag: true,
        index: i,
      ));
      items.add(CollectionBagItem(
        imagePath: fullGraphicBags[i],
        isLabelBag: false,
        index: i,
      ));
    }
    
    return items;
  }
}

/// Collection Bag Item Model - Encapsulates bag item data
/// Follows OOP principles with data encapsulation
class CollectionBagItem {
  final String imagePath;
  final bool isLabelBag;
  final int index;
  
  const CollectionBagItem({
    required this.imagePath,
    required this.isLabelBag,
    required this.index,
  });
  
  /// Returns bag type name
  String get bagType => isLabelBag ? 'Label Bag' : 'Full Graphic Bag';
}
