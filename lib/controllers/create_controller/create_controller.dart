import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/bag_type_mapper.dart';
import '../../widgets/product_selection_dialog.dart';

/// CreateController manages the create screen state and business logic
/// Follows OOP principles with clear separation of concerns
class CreateController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Loading state
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  
  /// Selected creation option
  final _selectedOption = Rx<CreationOption?>(null);
  CreationOption? get selectedOption => _selectedOption.value;
  
  /// Check if full graphic bag is selected
  bool get isFullGraphicSelected => _selectedOption.value == CreationOption.fullGraphic;
  
  /// Check if label bag is selected
  bool get isLabelSelected => _selectedOption.value == CreationOption.label;
  
  /// Animation states
  final _isUploadAnimating = false.obs;
  bool get isUploadAnimating => _isUploadAnimating.value;
  
  final _isGenerateAnimating = false.obs;
  bool get isGenerateAnimating => _isGenerateAnimating.value;
  
  /// Selected product row (0-2 for three rows)
  final _selectedProductRow = Rx<int?>(null);
  int? get selectedProductRow => _selectedProductRow.value;
  
  /// Check if specific row is selected
  bool isRowSelected(int row) => _selectedProductRow.value == row;

  /// Resolves the API bag_type string based on current UI selection.
  /// Uses BagTypeMapper to map (isFullGraphic + productRow) → API value.
  /// Returns default 'gusset_fullwrap' if nothing is selected.
  String get resolvedBagType {
    final row = _selectedProductRow.value;
    if (row == null) return BagTypeMapper.defaultBagType;
    final bagType = BagTypeMapper.resolve(
      isFullGraphic: _selectedOption.value == CreationOption.fullGraphic,
      productRow: row,
    );
    print('🎒 Resolved bag_type: $bagType (${BagTypeMapper.describe(bagType)})');
    return bagType;
  }
  
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
    // Initialize any required data
  }
  
  /// Cleanup resources
  void _cleanup() {
    // Clean up any resources
  }
  
  // ============ NAVIGATION METHODS ============
  
  /// Handles full graphic bag creation
  void createFullGraphicBag() {
    // ✅ Toggle: if already selected, deselect
    if (_selectedOption.value == CreationOption.fullGraphic) {
      _selectedOption.value = null;
      _isUploadAnimating.value = false;
      _isGenerateAnimating.value = false;
      _selectedProductRow.value = null;
    } else {
      _selectedOption.value = CreationOption.fullGraphic;
    }
  }

  /// Handles label bag creation
  void createLabelBag() {
    // ✅ Toggle: if already selected, deselect
    if (_selectedOption.value == CreationOption.label) {
      _selectedOption.value = null;
      _isUploadAnimating.value = false;
      _isGenerateAnimating.value = false;
      _selectedProductRow.value = null;
    } else {
      _selectedOption.value = CreationOption.label;
    }
  }
  
  // ============ CREATION OPTION METHODS ============
  
  /// Handles upload image/logo option tap
  void onUploadTap(BuildContext context) {
    print('🔵 onUploadTap called');
    print('🔵 Selected option: ${_selectedOption.value}');
    
    // Check if bag type is selected first
    if (_selectedOption.value == null) {
      print('❌ No bag type selected');
      _showMessage('Please select Create Label Bag or Create Full Graphics Bag first');
      return;
    }
    
    // Toggle animation state
    _isUploadAnimating.value = !_isUploadAnimating.value;
    print('🔵 isUploadAnimating: ${_isUploadAnimating.value}');
    
    // Show popup only when activating (turning true) AND bag type is selected
    if (_isUploadAnimating.value && _selectedOption.value != null) {
      print('✅ Showing popup after delay');
      // Deactivate the other option
      _isGenerateAnimating.value = false;
      
      // Show popup after animation
      Future.delayed(const Duration(milliseconds: 400), () {
        print('🚀 Calling _showProductSelectionPopup');
        _showProductSelectionPopup(context);
      });
    }
  }
  
  /// Handles generate with AI option tap
  void onGenerateAITap(BuildContext context) {
    // Check if bag type is selected first
    if (_selectedOption.value == null) {
      _showMessage('Please select Create Label Bag or Create Full Graphics Bag first');
      return;
    }
    
    // Toggle animation state
    _isGenerateAnimating.value = !_isGenerateAnimating.value;
    
    // Show popup only when activating (turning true) AND bag type is selected
    if (_isGenerateAnimating.value && _selectedOption.value != null) {
      // Deactivate the other option
      _isUploadAnimating.value = false;
      
      // Show popup after animation
      Future.delayed(const Duration(milliseconds: 400), () {
        _showProductSelectionPopup(context);
      });
    }
  }
  
  // ============ POPUP METHODS ============
  
  /// Shows product selection popup
  void _showProductSelectionPopup(BuildContext context) {
    print('📱 _showProductSelectionPopup called');
    try {
      print('📱 About to call showDialog');
      
      // Check if context is valid
      if (!context.mounted) {
        print('❌ Context is not mounted');
        _showMessage('Navigation context not available');
        return;
      }
      
      // Determine if full graphic is selected
      final isFullGraphic = _selectedOption.value == CreationOption.fullGraphic;
      
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return ProductSelectionDialog(
            controller: this,
            onProductSelected: () => _handleProductSelection(context),
            isFullGraphic: isFullGraphic,
          );
        },
      );
      
      print('✅ Dialog shown successfully');
    } catch (e, stackTrace) {
      print('❌ Error showing dialog: $e');
      print('❌ Stack trace: $stackTrace');
      _showMessage('Error showing popup: $e');
    }
  }
  
  /// Handles product row selection
  void selectProductRow(int row) {
    _selectedProductRow.value = row;
  }
  
  // ============ ACTION HANDLERS ============
  
  /// Handles product selection
  Future<void> _handleProductSelection(BuildContext context) async {
    if (_selectedProductRow.value == null) {
      _showMessage('Please select a product');
      return;
    }
    
    _setLoading(true);
    try {
      // Close dialog using Navigator with the passed context
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      
      // Wait for dialog close animation
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Navigate to appropriate screen based on selection type
      if (_isUploadAnimating.value) {
        // User selected Upload Image option
        print('📸 Navigating to Upload Image Screen');
        context.push('/upload-image');
      } else if (_isGenerateAnimating.value) {
        // User selected Generate with AI option
        print('🎨 Navigating to Text to Design Screen');
        context.push('/text-to-design');
      }
      
      _showSuccess('Product selected successfully!');
      
      // Reset animation states (but keep product selection)
      _isUploadAnimating.value = false;
      _isGenerateAnimating.value = false;
    } catch (e) {
      _showMessage('Navigation failed: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ UTILITY METHODS ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Shows an error/warning message to the user
  void _showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336), // Red for error/warning
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
  
  /// Shows a success message to the user
  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50), // Green for success
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
  
  /// Resets selected option and all states
  void resetSelection() {
    _selectedOption.value = null;
    _selectedProductRow.value = null;
    _isUploadAnimating.value = false;
    _isGenerateAnimating.value = false;
  }
}

/// Enum for creation options
enum CreationOption {
  fullGraphic,
  label,
}

/// Extension for CreationOption display names
extension CreationOptionExtension on CreationOption {
  String get displayName {
    switch (this) {
      case CreationOption.fullGraphic:
        return 'Full Graphic Bag';
      case CreationOption.label:
        return 'Label Bag';
    }
  }
}