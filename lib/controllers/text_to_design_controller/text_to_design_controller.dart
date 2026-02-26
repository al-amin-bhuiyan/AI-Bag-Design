import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/ai_generation/ai_generation_screen.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/mockup_dialog.dart';

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
  
  // ============ TEXT FIELD CONTROLLER ============
  
  final TextEditingController textController = TextEditingController();
  
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
      CustomSnackBar.showError(
        context,
        message: 'Please enter a description',
      );
      return false;
    }
    
    // Check for minimum word count (5+ words)
    final wordCount = text.split(RegExp(r'\s+')).length;
    print('📊 Word count: $wordCount');
    
    if (wordCount < 5) {
      print('❌ Validation failed: Not enough words ($wordCount < 5)');
      CustomSnackBar.showError(
        context,
        message: 'Please enter at least 5 words to describe your design',
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
      
      // Navigate to full-page AI generation screen
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AIGenerationScreen(
            onGenerate: () async {
              print('🔄 onGenerate callback triggered');
              // Perform actual generation
              await _performGeneration();
            },
            onAddToDesign: () {
              print('➕ onAddToDesign callback triggered');
              // Handle add to design
              _handleAddToDesign(context);
            },
            onRegenerate: () async {
              print('🔄 onRegenerate callback triggered');
              
              // Store the context before replacing
              final currentContext = context;
              
              // Dismiss keyboard to prevent it from showing
              FocusScope.of(currentContext).unfocus();
              
              // Small delay to ensure keyboard dismissal is processed
              await Future.delayed(const Duration(milliseconds: 100));
              
              // Use pushReplacement instead of pop + push
              // This prevents the text-to-design screen from ever becoming visible
              Navigator.of(currentContext).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => AIGenerationScreen(
                    onGenerate: () async {
                      print('🔄 onGenerate callback triggered (regenerated)');
                      // Perform actual generation
                      await _performGeneration();
                    },
                    onAddToDesign: () {
                      print('➕ onAddToDesign callback triggered (regenerated)');
                      // Handle add to design
                      _handleAddToDesign(context);
                    },
                    onRegenerate: () async {
                      // Recursive regeneration using the same approach
                      print('🔄 onRegenerate callback triggered (nested)');
                      
                      final ctx = context;
                      FocusScope.of(ctx).unfocus();
                      await Future.delayed(const Duration(milliseconds: 100));
                      
                      Navigator.of(ctx).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AIGenerationScreen(
                            onGenerate: () async {
                              await _performGeneration();
                            },
                            onAddToDesign: () {
                              _handleAddToDesign(context);
                            },
                            onRegenerate: () async {
                              // Continue recursive pattern
                              final c = context;
                              FocusScope.of(c).unfocus();
                              await Future.delayed(const Duration(milliseconds: 100));
                              _navigateToAIGenerationScreen(c);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
      
      // After AI generation screen is closed, ensure keyboard stays dismissed
      FocusScope.of(context).unfocus();
      print('✅ AI generation screen closed, keyboard dismissed');
    } catch (e) {
      print('❌ Error navigating to AI generation screen: $e');
      CustomSnackBar.showError(
        context,
        message: 'Failed to open generation screen: $e',
      );
    }
  }
  
  /// Helper method to navigate to AI generation screen without initial keyboard delay
  /// Used by onRegenerate to prevent showing text-to-design screen
  Future<void> _navigateToAIGenerationScreen(BuildContext context) async {
    try {
      // Navigate to full-page AI generation screen immediately
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AIGenerationScreen(
            onGenerate: () async {
              print('🔄 onGenerate callback triggered (regenerated)');
              // Perform actual generation
              await _performGeneration();
            },
            onAddToDesign: () {
              print('➕ onAddToDesign callback triggered (regenerated)');
              // Handle add to design
              _handleAddToDesign(context);
            },
            onRegenerate: () async {
              print('🔄 onRegenerate callback triggered (nested)');
              
              // Store the context before popping
              final currentContext = context;
              
              // Dismiss keyboard to prevent it from showing
              FocusScope.of(currentContext).unfocus();
              
              // Pop current AI generation screen
              Navigator.of(currentContext).pop();
              
              // Immediately show new AI generation screen without any delay
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (currentContext.mounted) {
                  FocusScope.of(currentContext).unfocus();
                  _navigateToAIGenerationScreen(currentContext);
                }
              });
            },
          ),
        ),
      );
      
      // After AI generation screen is closed, ensure keyboard stays dismissed
      FocusScope.of(context).unfocus();
      print('✅ AI generation screen closed (regenerated), keyboard dismissed');
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
      
      // Simulate AI generation (10-20 seconds as shown in UI)
      await Future.delayed(const Duration(seconds: 3));
      
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
    print('➕ Adding generated design to user designs - Showing mockup dialog');
    
    // Show mockup dialog on top of AI generation screen
    await MockupDialog.show(
      context,
      onSaveImages: () async {
        print('💾 Saving mockup images to gallery');
        
        // Dismiss keyboard first to prevent it from appearing
        FocusScope.of(context).unfocus();
        
        // Close AI generation screen
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        
        // Small delay to ensure the pop completes
        await Future.delayed(const Duration(milliseconds: 50));
        
        // TODO: Implement save to gallery functionality
        CustomSnackBar.showSuccess(
          context,
          message: 'Mockup images saved to gallery!',
        );
      },
      onAddToCollections: () async {
        print('📁 Adding mockup to collections');
        
        // Dismiss keyboard first to prevent it from appearing
        FocusScope.of(context).unfocus();
        
        // Close AI generation screen
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        
        // Small delay to ensure the pop completes
        await Future.delayed(const Duration(milliseconds: 50));
        
        // TODO: Implement add to collections functionality
        CustomSnackBar.showSuccess(
          context,
          message: 'Mockup added to collections!',
        );
      },
    );
  }
  
  /// Calls AI service to generate design
  Future<void> _callAIService(String prompt) async {
    print('🤖 Calling AI service with prompt: $prompt');
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 3)); 
      
      // TODO: Replace with actual AI API integration
      _generatedDesignUrl.value = 'https://example.com/generated-design.png';
      
      print('✅ AI service responded successfully');
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
    _isLoading.value = false;
  }
  
  /// Gets the current word count
  int get wordCount {
    final text = textController.text.trim();
    if (text.isEmpty) return 0;
    return text.split(RegExp(r'\s+')).length;
  }
}
