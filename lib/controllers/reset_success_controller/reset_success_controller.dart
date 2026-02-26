import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';

/// ResetSuccessController manages reset success screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class ResetSuccessController extends GetxController {
  // Observable state
  final RxBool _isLoading = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  /// Initializes the controller
  void _initializeController() {
    // Any initialization logic here
  }

  /// Handles continue button press
  Future<void> handleContinue(BuildContext context) async {
    _setLoading(true);

    try {
      // Small delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      if (context.mounted) {
        // Navigate to login screen
        context.go(AppPath.login);
      }
    } catch (e) {
      _showMessage('Navigation failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.go(AppPath.login);
    }
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
}
