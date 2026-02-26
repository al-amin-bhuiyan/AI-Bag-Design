import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';

/// ForgotPasswordController manages forgot password screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class ForgotPasswordController extends GetxController {
  // Observable state
  final RxBool _isLoading = false.obs;
  final RxBool _isEmailSelected = true.obs;
  final RxString _maskedEmail = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isEmailSelected => _isEmailSelected.value;
  String get maskedEmail => _maskedEmail.value;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  /// Initializes the controller
  void _initializeController() {
    _loadUserEmail();
  }

  /// Loads user email from login controller or storage
  void _loadUserEmail() {
    // TODO: Get email from login controller or shared preferences
    // For now, using a placeholder
    final email = _getStoredEmail();
    _maskedEmail.value = _maskEmail(email);
  }

  /// Gets stored email (placeholder implementation)
  String _getStoredEmail() {
    // TODO: Implement actual email retrieval from storage or login controller
    // This could be from GetX controller or shared preferences
    return 'mustakim@gmail.com';
  }

  /// Masks email for display (e.g., mu***@gmail.com)
  String _maskEmail(String email) {
    if (email.isEmpty) return '';
    
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) {
      return '$username***@$domain';
    }
    
    final visiblePart = username.substring(0, 2);
    return '$visiblePart***@$domain';
  }

  /// Toggles email selection
  void toggleEmailSelection() {
    _isEmailSelected.value = !_isEmailSelected.value;
  }

  /// Handles continue button press
  Future<void> handleContinue(BuildContext context) async {
    if (!_isEmailSelected.value) {
      _showMessage('Please select a recovery method');
      return;
    }

    _setLoading(true);

    try {
      // Simulate API call
      await _sendPasswordResetEmail();
      
      if (context.mounted) {
        // Navigate to verification code screen
        final email = _getStoredEmail();
        context.push('${AppPath.verificationCode}?email=$email');
      }
    } catch (e) {
      _showMessage('Failed to send reset link. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Sends password reset email (API call placeholder)
  Future<void> _sendPasswordResetEmail() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
  }

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
      duration: const Duration(seconds: 3),
    );
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
    }
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
