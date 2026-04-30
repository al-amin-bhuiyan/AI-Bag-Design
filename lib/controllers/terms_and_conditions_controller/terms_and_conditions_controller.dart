import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';

/// TermsAndConditionsController manages terms & conditions screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class TermsAndConditionsController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Page control state
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  
  /// Loading state
  final RxBool _isLoading = false.obs;
  
  /// Mode state
  final RxBool isFromOnboarding = false.obs;
  final RxList<int> _expandedIndices = <int>[].obs;
  
  // ============ GETTERS ============
  
  bool get isLoading => _isLoading.value;
  bool get isLastPage => currentPage.value == termsSections.length - 1;
  bool isExpanded(int index) => _expandedIndices.contains(index);
  
  // ============ LIFECYCLE METHODS ============
  
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
  
  // ============ INITIALIZATION ============
  
  /// Initializes the controller
  void _initialize() {
    // Check if we arrived from onboarding via route parameters or arguments
    final args = Get.arguments;
    if (args is Map<String, dynamic> && args['onboarding'] == true) {
      isFromOnboarding.value = true;
    } else if (Get.parameters['onboarding'] == 'true') {
      isFromOnboarding.value = true;
    }
    
    _loadTermsAndConditions();
  }
  
  /// Loads terms and conditions data
  Future<void> _loadTermsAndConditions() async {
    _setLoading(true);
    try {
      // TODO: Load terms and conditions from API or local storage
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleError('Failed to load terms and conditions: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ PUBLIC METHODS ============
  
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void toggleSection(int index) {
    if (_expandedIndices.contains(index)) {
      _expandedIndices.remove(index);
    } else {
      _expandedIndices.add(index);
    }
  }

  void nextPage() {
    if (currentPage.value < termsSections.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void agreeAndContinue(BuildContext context) {
    // Navigate to home/create after agreeing
    if (context.mounted) {
      context.go(AppPath.create);
    }
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
      print('🔵 Navigated back from Terms & Conditions');
    }
  }
  
  // ============ PRIVATE METHODS ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Handles errors
  void _handleError(String message) {
    debugPrint('❌ Error: $message');
    _showMessage(message);
  }
  
  /// Cleanup resources
  void _cleanup() {
    // No cleanup required for page states other than controller disposal
  }
  
  // ============ UTILITY METHODS ============
  
  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Refreshes terms and conditions data
  @override
  Future<void> refresh() async {
    await _loadTermsAndConditions();
  }
  
  // ============ DATA METHODS ============
  
  /// Returns terms and conditions sections list
  List<TermsSection> _getTermsSections() {
    return [
      TermsSection(
        title: '1. Acceptance of Terms',
        content: 'By accessing or using this application, you agree to comply with and be bound by these Terms & Conditions.\n\n'
            'If you do not agree, please do not use the app.',
      ),
      TermsSection(
        title: '2. Service Description',
        content: 'This app provides tools to create, customize, preview, and manage label and packaging designs for various products.\n\n'
            'All design previews and mockups are for visual and creative purposes only. Final printed results may vary depending on printing materials and methods.',
      ),
      TermsSection(
        title: '3. User Responsibilities',
        content: 'By using this app, you agree to:\n'
            '• Provide accurate account information\n'
            '• Upload only content you own or have rights to use\n'
            '• Ensure your designs do not violate copyright, trademark, or legal regulations\n'
            '• Use the app only for lawful purposes\n'
            '• Not attempt to misuse, hack, or disrupt the platform\n\n'
            'You are solely responsible for any content (logos, images, text, designs) you upload or create within the app.',
      ),
      TermsSection(
        title: '4. Intellectual Property',
        content: 'All logos, images, and design elements uploaded by users remain the property of their respective owners.\n\n'
            'By uploading content, you confirm that you have full rights or permission to use it.\n\n'
            'We are not responsible for any copyright or trademark violations caused by user-uploaded content.',
      ),
      TermsSection(
        title: '5. Orders, Downloads & Usage',
        content: 'Once a design is finalized or exported, it is the user\'s responsibility to review all details carefully.\n\n'
            'We are not responsible for printing errors caused by incorrect files or designs submitted by users.\n\n'
            'Design previews shown in the app are for demonstration purposes and may vary slightly in final production.',
      ),
      TermsSection(
        title: '6. Account Termination',
        content: 'We reserve the right to suspend or terminate any account that:\n'
            '• Violates these Terms\n'
            '• Uploads harmful, illegal, or copyrighted content without permission\n'
            '• Misuses the platform or disrupts services',
      ),
      TermsSection(
        title: '7. Limitation of Liability',
        content: 'We are not liable for any direct, indirect, or incidental damages resulting from:\n'
            '• Use or inability to use the app\n'
            '• Design or printing outcomes\n'
            '• User-uploaded content\n'
            '• Third-party service interruptions\n\n'
            'Use of the app is at your own risk.',
      ),
      TermsSection(
        title: '8. Updates to Terms',
        content: 'We may update these Terms & Conditions at any time.\n\n'
            'Continued use of the app after updates indicates your acceptance of the revised Terms.',
      ),
    ];
  }
  
  /// Public getter for terms sections
  List<TermsSection> get termsSections => _getTermsSections();
}

/// Terms Section Model - Encapsulates section data structure
/// Follows OOP principles with data encapsulation
class TermsSection {
  final String title;
  final String content;
  
  const TermsSection({
    required this.title,
    required this.content,
  });
  
  /// Factory constructor from JSON
  factory TermsSection.fromJson(Map<String, dynamic> json) {
    return TermsSection(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
  
  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
  
  /// Creates a copy with modified fields
  TermsSection copyWith({
    String? title,
    String? content,
  }) {
    return TermsSection(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}