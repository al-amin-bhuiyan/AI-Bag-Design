import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../create_controller/create_controller.dart';
import '../collections_controller/collections_controller.dart';
import '../../services/bag_design_service.dart';
import '../your_design_controller/your_design_controller.dart';
import '../../views/ai_generation/ai_generation_screen.dart';
import '../../widgets/mockup_dialog.dart';
import '../../widgets/ai_generation_loading_widget.dart';

/// TextToDesignController - Manages AI text-to-design screen state and business logic
/// Follows OOP principles with clear separation of concerns
class TextToDesignController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Loading state
  final _isLoading = false.obs;
  RxBool get isLoading => _isLoading;
  
  /// Generated design URL
  final _generatedDesignUrl = Rx<String?>(null);
  String? get generatedDesignUrl => _generatedDesignUrl.value;
  
  /// Generated design preview ID (from backend API response)
  final _generatedDesignPreviewId = Rx<String?>(null);
  String? get generatedDesignPreviewId => _generatedDesignPreviewId.value;

  /// Generated bag mockup URLs from /api/generate-design/
  final _generatedPreviewUrl = Rx<String?>(null);
  final _generatedDielineUrl = Rx<String?>(null);
  
  // ============ TEXT FIELD CONTROLLER ============
  
  final TextEditingController textController = TextEditingController();
  final BagDesignService _bagDesignService = BagDesignService.instance;
  
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
    print('🎨 TextToDesignController initialized');
  }
  
  /// Cleanup resources
  void _cleanup() {
    textController.dispose();
    print('🎨 TextToDesignController disposed');
  }
  
  // ============ VALIDATION METHODS ============
  
  /// Validates the text input
  bool _validateInput(BuildContext context) {
    final text = textController.text.trim();
    
    print('🔍 Validating input: "$text"');
    
    if (text.isEmpty) {
      print('❌ Validation failed: Text is empty');
      Fluttertoast.showToast(
        msg: 'Please enter a description',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return false;
    }
    
    // Check for minimum word count (5+ words)
    final wordCount = text.split(RegExp(r'\s+')).length;
    print('📊 Word count: $wordCount');
    
    if (wordCount < 5) {
      print('❌ Validation failed: Not enough words ($wordCount < 5)');
      Fluttertoast.showToast(
        msg: 'Please enter at least 5 words to describe your design',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return false;
    }
    
    print('✅ Validation passed');
    return true;
  }
  
  // ============ AI GENERATION METHODS ============
  
  /// Generates design using AI
  Future<void> generateDesign(BuildContext context) async {
    print('🎨 ========== GENERATE DESIGN CALLED ==========');
    print('🎨 Current text: "${textController.text}"');
    
    if (!_validateInput(context)) {
      print('❌ Validation failed, stopping generation');
      return;
    }
    
    print('✅ Validation passed, navigating to AI generation screen...');
    
    try {
      // Dismiss keyboard before navigating
      FocusScope.of(context).unfocus();
      
      // Small delay to ensure keyboard is dismissed
      await Future.delayed(const Duration(milliseconds: 150));

      if (!context.mounted) return;
      
      await _navigateToAIGenerationScreen(context, replaceCurrent: false);

      if (!context.mounted) return;
      
      // After AI generation screen is closed, ensure keyboard stays dismissed
      FocusScope.of(context).unfocus();
      print('✅ AI generation screen closed, keyboard dismissed');
    } catch (e) {
      print('❌ Error navigating to AI generation screen: $e');
      Fluttertoast.showToast(
        msg: 'Failed to open generation screen',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }
  
  /// Helper method to navigate to AI generation screen without initial keyboard delay
  /// Used by onRegenerate to prevent showing text-to-design screen
  Future<void> _navigateToAIGenerationScreen(
    BuildContext context, {
    required bool replaceCurrent,
  }) async {
    try {
      final route = MaterialPageRoute(
        builder: (routeContext) => AIGenerationScreen(
          onGenerate: _performGeneration,
          getGeneratedImageUrl: () => _generatedDesignUrl.value,
          onAddToDesign: () => _handleAddToDesign(routeContext),
          onRegenerate: () async {
            FocusScope.of(routeContext).unfocus();
            await Future.delayed(const Duration(milliseconds: 100));
            if (routeContext.mounted) {
              await _navigateToAIGenerationScreen(
                routeContext,
                replaceCurrent: true,
              );
            }
          },
        ),
      );

      if (replaceCurrent) {
        await Navigator.of(context).pushReplacement(route);
      } else {
        await Navigator.of(context).push(route);
      }

      if (!context.mounted) return;
      
      // After AI generation screen is closed, ensure keyboard stays dismissed
      FocusScope.of(context).unfocus();
      print('✅ AI generation screen closed, keyboard dismissed');
    } catch (e) {
      print('❌ Error navigating to AI generation screen: $e');
    }
  }
  
  /// Performs the actual AI generation
  Future<void> _performGeneration() async {
    _setLoading(true);
    
    try {
      final prompt = textController.text.trim();
      print('📝 Prompt: $prompt');

      _generatedDesignUrl.value = null;
      _generatedPreviewUrl.value = null;
      _generatedDielineUrl.value = null;
      _generatedDesignPreviewId.value = null;
      
      // Call AI service
      await _callAIService(prompt);
      
      print('✅ Design generated successfully');
      
    } catch (e) {
      print('❌ Error generating design: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
  
  /// Handles adding generated design to user's designs
  void _handleAddToDesign(BuildContext context) async {
    print('➕ Add image to your design tapped');

    final logoUrl = _generatedDesignUrl.value?.trim() ?? '';
    if (logoUrl.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please generate a logo first.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return;
    }

    // Capture the resolved bagType immediately using GetX
    final bagType = _resolveBagType();
    print('🎒 Saving generated design using bag_type: $bagType');
    
    var generationSucceeded = false;

    // Show full-screen loading animation immediately, similar to UploadImage logic
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AIGenerationLoadingWidget(
          onGenerate: () async {
            // REAL API CALL with resolved bag_type and generated AI logo
            try {
              final response = await _bagDesignService.generateDesign(
                bagType: bagType,
                logoUrl: logoUrl,
              );

              if (response.success && response.data != null) {
                _generatedPreviewUrl.value = response.data!.previewUrl;
                _generatedDielineUrl.value = response.data!.dielineUrl;
                _generatedDesignPreviewId.value = response.data!.previewId;
                generationSucceeded = true;
              } else {
                Fluttertoast.showToast(
                  msg: response.errorMessage ?? 'Failed to generate bag design',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 15.0,
                );
              }
            } catch (e) {
              Fluttertoast.showToast(
                msg: 'Error: $e',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 15.0,
              );
            }
          },
          onClose: () {
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
    );

    if (!context.mounted) return;
    
    // Only continue if creation was successful and we actually have paths
    if (!generationSucceeded || _generatedPreviewUrl.value == null || _generatedDielineUrl.value == null) {
      return;
    }

    // Now securely pass those URLs directly into the Mockup Dialog component
    await MockupDialog.show(
      context,
      images: [_generatedPreviewUrl.value!, _generatedDielineUrl.value!],
      isNetworkImage: true,
      onSaveImages: _saveToYourDesign,
      onAddToCollections: _addToCollections,
    );
  }
  
  /// Calls AI service to generate design
  Future<void> _callAIService(String prompt) async {
    print('🤖 Calling AI service with prompt: $prompt');
    
    try {
      final response = await _bagDesignService.generateLogo(prompt: prompt);
      if (!response.success || response.data == null) {
        throw Exception(response.errorMessage ?? 'Failed to generate image');
      }

      _generatedDesignUrl.value = response.data!.fullLogoUrl;
      _generatedPreviewUrl.value = null;
      _generatedDielineUrl.value = null;
      _generatedDesignPreviewId.value = null;
      
      print('✅ AI service responded successfully');
      print('🖼️ Generated logo URL: ${_generatedDesignUrl.value}');
    } catch (e) {
      print('❌ AI service error: $e');
      rethrow;
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
    textController.clear();
    _generatedDesignUrl.value = null;
    _generatedPreviewUrl.value = null;
    _generatedDielineUrl.value = null;
    _generatedDesignPreviewId.value = null;
    _isLoading.value = false;
  }

  String _resolveBagType() {
    try {
      final bagType = Get.find<CreateController>().resolvedBagType;
      print('🎒 Text-to-design using bag_type: $bagType');
      return bagType;
    } catch (_) {
      print('🎒 CreateController not found, fallback bag_type: gusset_fullwrap');
      return 'gusset_fullwrap';
    }
  }

  bool _hasPreviewId() {
    final previewId = _generatedDesignPreviewId.value;
    if (previewId == null || previewId.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Preview ID not available. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return false;
    }
    return true;
  }

  Future<bool> _saveToYourDesign() async {
    if (!_hasPreviewId()) return false;

    try {
      final yourDesignController = Get.isRegistered<YourDesignController>()
          ? Get.find<YourDesignController>()
          : Get.put(YourDesignController());

      return await yourDesignController
          .saveDesignToCollection(_generatedDesignPreviewId.value!);
    } catch (_) {
      Fluttertoast.showToast(
        msg: 'Failed to save design',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return false;
    }
  }

  Future<bool> _addToCollections() async {
    if (!_hasPreviewId()) return false;

    try {
      final collectionsController = Get.isRegistered<CollectionsController>()
          ? Get.find<CollectionsController>()
          : Get.put(CollectionsController());

      return await collectionsController
          .saveDesignToCollection(_generatedDesignPreviewId.value!);
    } catch (_) {
      Fluttertoast.showToast(
        msg: 'Failed to save design to collection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      return false;
    }
  }
  
  /// Gets the current word count
  int get wordCount {
    final text = textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }
}