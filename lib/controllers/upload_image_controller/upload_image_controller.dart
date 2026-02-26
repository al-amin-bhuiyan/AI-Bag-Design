import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../your_design_controller/your_design_controller.dart';
import '../collections_controller/collections_controller.dart';
import '../../widgets/custom_assets.dart';

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
  
  // ============ DEPENDENCIES ============
  
  final ImagePicker _imagePicker = ImagePicker();
  
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
    print('📸 UploadImageController initialized');
  }
  
  /// Cleanup resources
  void _cleanup() {
    print('📸 UploadImageController disposed');
  }
  
  // ============ IMAGE PICKER METHODS ============
  
  /// Picks image from gallery
  Future<void> pickImage(BuildContext context) async {
    print('📸 Picking image from gallery');
    
    _setLoading(true);
    
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        _selectedImagePath.value = image.path;
        print('✅ Image selected: ${image.path}');
        _showMessage('Image selected successfully!');
        
        // TODO: Navigate to next screen or process image
        await _processImage(image.path);
      } else {
        print('❌ No image selected');
        _showMessage('No image selected');
      }
    } catch (e) {
      print('❌ Error picking image: $e');
      _showMessage('Failed to pick image: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  /// Processes the selected image
  Future<void> _processImage(String imagePath) async {
    print('🔄 Processing image: $imagePath');
    
    try {
      // TODO: Implement image processing logic
      // - Upload to server
      // - Apply filters
      // - Navigate to editor screen
      
      await Future.delayed(const Duration(seconds: 1));
      
      print('✅ Image processed successfully');
      // Navigate to design editor or next screen
    } catch (e) {
      print('❌ Error processing image: $e');
      _showMessage('Failed to process image: $e');
    }
  }
  
  // ============ UTILITY METHODS ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  /// Resets controller state
  void reset() {
    _selectedImagePath.value = null;
    _isLoading.value = false;
  }
  
  /// Refreshes the screen
  Future<void> refresh() async {
    print('🔄 Refreshing upload screen');
    _setLoading(true);
    
    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    reset();
    _setLoading(false);
    _showMessage('Screen refreshed');
  }
  
  /// Saves the selected image
  void saveImage() {
    if (_selectedImagePath.value != null) {
      print('💾 Saving image: ${_selectedImagePath.value}');
      
      // Get or create YourDesignController instance
      YourDesignController yourDesignController;
      
      try {
        yourDesignController = Get.find<YourDesignController>();
      } catch (e) {
        print('⚠️ YourDesignController not found, creating new instance...');
        yourDesignController = YourDesignController();
        Get.put(yourDesignController);
      }
      
      // Add the saved image to projects
      yourDesignController.addSavedImage(_selectedImagePath.value!);
      
      // Toast message will be shown in UI layer
    }
  }
  
  /// Shows bag design preview with mockup dialog
  void showBagDesign(BuildContext context) {
    if (_selectedImagePath.value != null) {
      print('👜 Showing bag design preview');
      // Show mockup dialog will be handled in UI layer
    }
  }
  
  /// Saves mockup images to device gallery
  Future<void> saveMockupImages() async {
    print('💾 Saving mockup image to gallery');
    
    try {
      // Copy the first mockup image (mockupImage1) from assets to app directory
      final ByteData imageData = await rootBundle.load(CustomAssets.mockupImage1);
      final buffer = imageData.buffer;
      
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'mockup_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      
      // Write the image to file
      await file.writeAsBytes(
        buffer.asUint8List(imageData.offsetInBytes, imageData.lengthInBytes),
      );
      
      print('✅ Mockup image saved to: ${file.path}');
      
      // Note: For actual gallery saving, you would need image_gallery_saver package
      // For now, we save to app directory which can be accessed
      _showMessage('Mockup image saved successfully!');
      
    } catch (e) {
      print('❌ Error saving mockup image: $e');
      _showMessage('Failed to save mockup image: $e');
    }
  }
  
  /// Adds first mockup image to collections
  Future<void> addMockupToCollections() async {
    print('📁 Adding mockup to collections');
    
    try {
      // Get or create CollectionsController instance
      CollectionsController collectionsController;
      
      try {
        collectionsController = Get.find<CollectionsController>();
      } catch (e) {
        print('⚠️ CollectionsController not found, creating new instance...');
        collectionsController = CollectionsController();
        Get.put(collectionsController);
      }
      
      // Add the first mockup image (mockupImage1) to collections
      collectionsController.addSavedImage(CustomAssets.mockupImage1);
      
      print('✅ Mockup added to collections');
      _showMessage('Mockup added to collections!');
      
    } catch (e) {
      print('❌ Error adding mockup to collections: $e');
      _showMessage('Failed to add mockup to collections: $e');
    }
  }
}
