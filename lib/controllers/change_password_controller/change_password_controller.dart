import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// ChangePasswordController manages change password screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class ChangePasswordController extends GetxController {
  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Text editing controllers
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool currentPasswordObscure = true.obs;
  final RxBool newPasswordObscure = true.obs;
  final RxBool confirmPasswordObscure = true.obs;

  // Getters
  String get currentPassword => currentPasswordController.text;
  String get newPassword => newPasswordController.text;
  String get confirmPassword => confirmPasswordController.text;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Toggles current password visibility
  void toggleCurrentPasswordVisibility() {
    currentPasswordObscure.value = !currentPasswordObscure.value;
  }

  /// Toggles new password visibility
  void toggleNewPasswordVisibility() {
    newPasswordObscure.value = !newPasswordObscure.value;
  }

  /// Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    confirmPasswordObscure.value = !confirmPasswordObscure.value;
  }

  /// Validates new password
  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'New password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }

    if (value != newPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates all fields
  bool validateFields() {
    if (currentPassword.isEmpty) {
      _showMessage('Current password is required');
      return false;
    }

    final newPasswordError = validateNewPassword(newPassword);
    final confirmPasswordError = validateConfirmPassword(confirmPassword);

    if (newPasswordError != null) {
      _showMessage(newPasswordError);
      return false;
    }

    if (confirmPasswordError != null) {
      _showMessage(confirmPasswordError);
      return false;
    }

    return true;
  }

  /// Handles change password action
  Future<void> changePassword(BuildContext context) async {
    print('🔵 changePassword called');
    
    if (!validateFields()) {
      print('❌ Validation failed');
      return;
    }

    print('✅ Validation passed');
    isLoading.value = true;

    try {
      print('⏳ Calling API...');
      // Simulate API call
      await _changePasswordAPI(currentPassword, newPassword);
      print('✅ API call successful');

      if (context.mounted) {
        print('🔵 Context is mounted, showing success and navigating back');
        _showMessage('Password changed successfully!');
        // Navigate back to security/profile screen
        context.pop();
        print('✅ Navigation back successful');
      } else {
        print('❌ Context not mounted!');
      }
    } catch (e) {
      print('❌ Error: $e');
      _showMessage('Failed to change password. Please try again.');
    } finally {
      isLoading.value = false;
      print('🔵 Loading state set to false');
    }
  }

  /// API call to change password (placeholder)
  Future<void> _changePasswordAPI(String currentPass, String newPass) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
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

  /// Disposes all controllers
  void _disposeControllers() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }
}
