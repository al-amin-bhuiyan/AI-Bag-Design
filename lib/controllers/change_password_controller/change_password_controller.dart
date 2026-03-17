import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/change_password_model.dart';
import '../../services/auth_service.dart';
import '../../services/token_storage_service.dart';

/// ChangePasswordController - Manages change password screen logic and state
/// Calls real POST /accounts/user/change-password/ API with Bearer token
/// Shows Fluttertoast for every validation error and API response
/// Follows 100% OOP: encapsulation, single responsibility, composition
class ChangePasswordController extends GetxController {
  // ─── Dependencies (Composition) ───────────────────────────────────────────
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  // ─── Form ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController     = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool isLoading               = false.obs;
  final RxBool currentPasswordObscure  = true.obs;
  final RxBool newPasswordObscure      = true.obs;
  final RxBool confirmPasswordObscure  = true.obs;

  // ─── Getters ──────────────────────────────────────────────────────────────
  String get currentPassword => currentPasswordController.text.trim();
  String get newPassword     => newPasswordController.text.trim();
  String get confirmPassword => confirmPasswordController.text.trim();

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ─── Visibility Toggles ───────────────────────────────────────────────────

  void toggleCurrentPasswordVisibility() =>
      currentPasswordObscure.value = !currentPasswordObscure.value;

  void toggleNewPasswordVisibility() =>
      newPasswordObscure.value = !newPasswordObscure.value;

  void toggleConfirmPasswordVisibility() =>
      confirmPasswordObscure.value = !confirmPasswordObscure.value;

  // ─── Validation ───────────────────────────────────────────────────────────

  /// Validates all fields — shows individual toast for each failure
  bool _validateFields() {
    // Current password
    if (currentPassword.isEmpty) {
      _showError('Current password is required');
      return false;
    }

    // New password
    if (newPassword.isEmpty) {
      _showError('New password is required');
      return false;
    }
    if (newPassword.length < 8) {
      _showError('New password must be at least 8 characters');
      return false;
    }
    if (!newPassword.contains(RegExp(r'[A-Z]'))) {
      _showError('New password must contain at least one uppercase letter');
      return false;
    }
    if (!newPassword.contains(RegExp(r'[a-z]'))) {
      _showError('New password must contain at least one lowercase letter');
      return false;
    }
    if (!newPassword.contains(RegExp(r'[0-9]'))) {
      _showError('New password must contain at least one number');
      return false;
    }
    if (newPassword == currentPassword) {
      _showError('New password must be different from current password');
      return false;
    }

    // Confirm password
    if (confirmPassword.isEmpty) {
      _showError('Please confirm your new password');
      return false;
    }
    if (confirmPassword != newPassword) {
      _showError('Passwords do not match');
      return false;
    }

    return true;
  }

  // ─── Public Methods ───────────────────────────────────────────────────────

  /// Handles change password — validates then calls real API
  Future<void> changePassword() async {
    if (!_validateFields()) return;

    isLoading.value = true;
    try {
      final String? accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        _showError('Session expired. Please log in again.');
        return;
      }

      debugPrint('📤 Changing password...');

      final ChangePasswordRequestModel request = ChangePasswordRequestModel(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmNewPassword: confirmPassword,
      );

      final ApiResponse<ChangePasswordResponseModel> response =
          await _authService.changePassword(
        accessToken: accessToken,
        request: request,
      );

      if (response.success && response.data != null) {
        final String msg = response.data!.message;
        debugPrint('✅ $msg');

        _showSuccess(msg);

        // Clear fields after success
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        _showError(response.errorMessage ?? 'Failed to change password. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ Change password error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

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