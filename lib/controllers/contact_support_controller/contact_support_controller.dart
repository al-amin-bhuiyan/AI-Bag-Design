import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// ContactSupportController manages contact support screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class ContactSupportController extends GetxController {
  // ============ FORM CONTROLLERS ============
  
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  // ============ FOCUS NODES ============
  
  final FocusNode subjectFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode messageFocusNode = FocusNode();
  
  // ============ OBSERVABLE PROPERTIES ============
  
  /// Loading state for form submission
  final RxBool _isLoading = false.obs;
  
  /// Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // ============ GETTERS ============
  
  bool get isLoading => _isLoading.value;
  String get subject => subjectController.text;
  String get email => emailController.text;
  String get message => messageController.text;
  
  // ============ LIFECYCLE METHODS ============
  
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }
  
  // ============ INITIALIZATION ============
  
  /// Initializes the controller
  void _initialize() {
    // Load user email if available
    _loadUserEmail();
  }
  
  /// Loads user email from storage or profile
  void _loadUserEmail() {
    // TODO: Load from user profile or storage
    // emailController.text = 'user@example.com';
  }
  
  // ============ VALIDATION METHODS ============
  
  /// Validates subject field
  String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Subject is required';
    }
    
    if (value.trim().length < 3) {
      return 'Subject must be at least 3 characters';
    }
    
    if (value.trim().length > 100) {
      return 'Subject must not exceed 100 characters';
    }
    
    return null;
  }
  
  /// Validates email field
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  /// Validates message field
  String? validateMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message is required';
    }
    
    if (value.trim().length < 10) {
      return 'Message must be at least 10 characters';
    }
    
    if (value.trim().length > 1000) {
      return 'Message must not exceed 1000 characters';
    }
    
    return null;
  }
  
  /// Validates all fields
  bool _validateFields() {
    final subjectError = validateSubject(subject);
    final emailError = validateEmail(email);
    final messageError = validateMessage(message);
    
    if (subjectError != null) {
      _showError(subjectError);
      return false;
    }
    
    if (emailError != null) {
      _showError(emailError);
      return false;
    }
    
    if (messageError != null) {
      _showError(messageError);
      return false;
    }
    
    return true;
  }
  
  // ============ PUBLIC METHODS ============
  
  /// Handles send message action
  Future<void> sendMessage(BuildContext context) async {
    print('🔵 sendMessage called');
    
    // Unfocus all fields
    _unfocusAll();
    
    // Validate fields
    if (!_validateFields()) {
      print('❌ Validation failed');
      return;
    }
    
    print('✅ Validation passed');
    _setLoading(true);
    
    try {
      print('⏳ Sending message...');
      
      // TODO: Implement actual API call
      await _sendSupportMessage(
        subject: subject,
        email: email,
        message: message,
      );
      
      print('✅ Message sent successfully');
      
      if (context.mounted) {
        _showSuccess('Your message has been sent successfully!');
        
        // Clear form
        _clearForm();
        
        // Navigate back after short delay
        await Future.delayed(const Duration(seconds: 2));
        if (context.mounted) {
          context.pop();
          print('🔵 Navigated back after success');
        }
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      _showError('Failed to send message. Please try again.');
    } finally {
      _setLoading(false);
      print('🔵 Loading state set to false');
    }
  }
  
  /// Clears all form fields
  void clearForm() {
    _clearForm();
    _showMessage('Form cleared');
  }
  
  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    _unfocusAll();
    if (context.mounted) {
      context.pop();
      print('🔵 Navigated back from Contact Support');
    }
  }
  
  // ============ PRIVATE METHODS ============
  
  /// API call to send support message (placeholder)
  Future<void> _sendSupportMessage({
    required String subject,
    required String email,
    required String message,
  }) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate API response
    print('📧 Support message sent:');
    print('  Subject: $subject');
    print('  Email: $email');
    print('  Message: ${message.substring(0, message.length > 50 ? 50 : message.length)}...');
  }
  
  /// Clears all form fields
  void _clearForm() {
    subjectController.clear();
    emailController.clear();
    messageController.clear();
    print('✅ Form cleared');
  }
  
  /// Unfocuses all input fields
  void _unfocusAll() {
    subjectFocusNode.unfocus();
    emailFocusNode.unfocus();
    messageFocusNode.unfocus();
  }
  
  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }
  
  /// Disposes all controllers and focus nodes
  void _disposeControllers() {
    subjectController.dispose();
    emailController.dispose();
    messageController.dispose();
    
    subjectFocusNode.dispose();
    emailFocusNode.dispose();
    messageFocusNode.dispose();
    
    print('✅ Controllers and focus nodes disposed');
  }
  
  // ============ UTILITY METHODS ============
  
  /// Shows error message
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Shows success message
  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Shows info message
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
