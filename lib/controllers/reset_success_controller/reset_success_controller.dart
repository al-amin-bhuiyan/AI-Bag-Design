import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      context.go(AppPath.create);
    }
  }

  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Shows a message to the user
  void _showMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
