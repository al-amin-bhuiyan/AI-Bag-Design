import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/reset_password_model.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';

/// ForgotPasswordController - Manages forgot password screen logic and state
/// Calls real POST /accounts/user/send-reset-password-email/ API
/// Follows 100% OOP: encapsulation, single responsibility, composition
class ForgotPasswordController extends GetxController {
  // ─── Dependencies ─────────────────────────────────────────────────────────
  final AuthService _authService = AuthService.instance;

  // ─── Email TextField controller ───────────────────────────────────────────
  final TextEditingController emailController = TextEditingController();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool _isLoading = false.obs;

  // ─── Public Getters ───────────────────────────────────────────────────────
  bool get isLoading => _isLoading.value;
  String get email => emailController.text.trim();

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // ─── Validation ───────────────────────────────────────────────────────────

  /// Validates email format
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // ─── Public Methods ───────────────────────────────────────────────────────

  /// Handles continue button press — validates then calls real API
  Future<void> handleContinue(BuildContext context) async {
    final error = validateEmail(email);
    if (error != null) {
      _showError(error);
      return;
    }

    _isLoading.value = true;

    try {
      debugPrint('📤 Sending reset password OTP to: $email');

      final ApiResponse<SendResetPasswordEmailResponseModel> response =
          await _authService.sendResetPasswordEmail(email: email);

      if (response.success && response.data != null) {
        final String msg = response.data!.message;
        debugPrint('✅ $msg');

        _showSuccess(msg);

        await Future.delayed(const Duration(milliseconds: 600));

        if (context.mounted) {
          context.push(
            '${AppPath.verificationCode}?email=${Uri.encodeComponent(email)}',
          );
        }
      } else {
        _showError(response.errorMessage ??
            'Failed to send reset email. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ ForgotPassword error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) context.pop();
  }

  // ─── Toast Helpers ────────────────────────────────────────────────────────

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
}