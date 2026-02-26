import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// PrivacyPolicyController manages privacy policy screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class PrivacyPolicyController extends GetxController {
  // ============ OBSERVABLE PROPERTIES ============
  
  /// List of expanded section indices
  final RxList<int> _expandedIndices = <int>[].obs;
  
  /// Loading state
  final RxBool _isLoading = false.obs;
  
  // ============ GETTERS ============
  
  List<int> get expandedIndices => _expandedIndices;
  bool get isLoading => _isLoading.value;
  
  /// Checks if a specific section is expanded
  bool isExpanded(int index) => _expandedIndices.contains(index);
  
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
    _loadPrivacyPolicy();
  }
  
  /// Loads privacy policy data
  Future<void> _loadPrivacyPolicy() async {
    _setLoading(true);
    try {
      // TODO: Load privacy policy from API or local storage
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      _handleError('Failed to load privacy policy: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // ============ PUBLIC METHODS ============
  
  /// Toggles section expansion state
  void toggleSection(int index) {
    if (_expandedIndices.contains(index)) {
      _expandedIndices.remove(index);
      print('🔵 Collapsed section at index: $index');
    } else {
      _expandedIndices.add(index);
      print('🔵 Expanded section at index: $index');
    }
  }
  
  /// Expands all sections
  void expandAll() {
    _expandedIndices.clear();
    for (int i = 0; i < _getPrivacyPolicySections().length; i++) {
      _expandedIndices.add(i);
    }
    print('✅ Expanded all sections');
  }
  
  /// Collapses all sections
  void collapseAll() {
    _expandedIndices.clear();
    print('✅ Collapsed all sections');
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
      print('🔵 Navigated back from Privacy Policy');
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
    _expandedIndices.clear();
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
  
  /// Refreshes privacy policy data
  Future<void> refresh() async {
    await _loadPrivacyPolicy();
  }
  
  // ============ DATA METHODS ============
  
  /// Returns privacy policy sections list
  List<PrivacyPolicySection> _getPrivacyPolicySections() {
    return [
      PrivacyPolicySection(
        title: '1. Introduction',
        content: 'We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our label and packaging design application.\n\n'
            'By using the app, you agree to the collection and use of information in accordance with this policy.',
      ),
      PrivacyPolicySection(
        title: '2. Information We Collect',
        content: 'Account Information:\n'
            '• Name\n'
            '• Email address\n'
            '• Login credentials\n'
            '• Profile details\n\n'
            'Design & Project Data:\n'
            '• Uploaded images, logos, and design files\n'
            '• Saved templates and projects\n'
            '• Custom label and packaging designs\n'
            '• App preferences and settings\n\n'
            'Usage Data:\n'
            '• App interactions and feature usage\n'
            '• Design activity and saved drafts\n'
            '• Device and performance data\n'
            '• Crash and error reports',
      ),
      PrivacyPolicySection(
        title: '3. How We Use Your Information',
        content: 'We use your information to:\n'
            '• Provide and improve design tools and features\n'
            '• Save and manage your projects and templates\n'
            '• Enable design editing and downloads\n'
            '• Improve app performance and user experience\n'
            '• Provide customer support\n'
            '• Send important updates related to your account or designs\n\n'
            'We do not sell your personal information to third parties.',
      ),
      PrivacyPolicySection(
        title: '4. Data Security',
        content: 'We implement appropriate technical and organizational measures to protect your information from unauthorized access, loss, misuse, or disclosure.\n\n'
            'Your design files and personal data are stored securely and only accessible when needed to provide our services.',
      ),
      PrivacyPolicySection(
        title: '5. Third-Party Services',
        content: 'We may use trusted third-party services for:\n'
            '• Cloud storage and file hosting\n'
            '• Analytics and performance monitoring\n'
            '• Payment processing (if premium features are used)\n\n'
            'These providers are required to keep your information secure and confidential.',
      ),
      PrivacyPolicySection(
        title: '6. Your Rights',
        content: 'You have the right to:\n'
            '• Update or edit your profile information\n'
            '• Delete your account and associated data\n'
            '• Request removal of your saved designs\n'
            '• Contact us regarding privacy concerns\n\n'
            'To make any request, please contact our support team.',
      ),
      PrivacyPolicySection(
        title: '7. Updates to This Policy',
        content: 'We may update this Privacy Policy from time to time. Any changes will be reflected within the app.\n\n'
            'Continued use of the app after updates means you accept the revised policy.',
      ),
    ];
  }
  
  /// Public getter for privacy policy sections
  List<PrivacyPolicySection> get policySections => _getPrivacyPolicySections();
}

/// Privacy Policy Section Model - Encapsulates section data structure
/// Follows OOP principles with data encapsulation
class PrivacyPolicySection {
  final String title;
  final String content;
  
  const PrivacyPolicySection({
    required this.title,
    required this.content,
  });
  
  /// Factory constructor from JSON
  factory PrivacyPolicySection.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicySection(
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
  PrivacyPolicySection copyWith({
    String? title,
    String? content,
  }) {
    return PrivacyPolicySection(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}
