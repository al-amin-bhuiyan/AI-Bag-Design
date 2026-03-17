import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/set_new_password_model.dart';
import '../../services/auth_service.dart';
/// ResetPasswordController - Manages set-new-password screen after OTP verification
/// Calls POST /accounts/user/set-new-password/ with reset_token
/// On success: sets isSuccess = true -> view handles navigation via Get.offAll
/// This avoids GoRouter "no routes" exception after OTP push chain
/// Follows 100% OOP: encapsulation, single responsibility, composition
class ResetPasswordController extends GetxController {
  // Dependencies
  final AuthService _authService = AuthService.instance;
  // Form and Text Controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController     = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  // Observable State
  final RxBool isLoading              = false.obs;
  final RxBool newPasswordObscure     = true.obs;
  final RxBool confirmPasswordObscure = true.obs;
  final RxBool isSuccess              = false.obs;
  final RxString _resetToken          = ''.obs;
  // Getters
  String get newPassword     => newPasswordController.text.trim();
  String get confirmPassword => confirmPasswordController.text.trim();
  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  void setResetToken(String token) {
    _resetToken.value = token;
    debugPrint('Key ResetPassword: reset_token set');
  }
  void toggleNewPasswordVisibility() =>
      newPasswordObscure.value = !newPasswordObscure.value;
  void toggleConfirmPasswordVisibility() =>
      confirmPasswordObscure.value = !confirmPasswordObscure.value;
  Future<void> resetPassword() async {
    if (!_validateFields()) return;
    isLoading.value = true;
    try {
      debugPrint('Sending new password...');
      final request = SetNewPasswordRequestModel(
        resetToken: _resetToken.value,
        newPassword: newPassword,
        newPassword2: confirmPassword,
      );
      final ApiResponse<SetNewPasswordResponseModel> response =
          await _authService.setNewPassword(request: request);
      if (response.success && response.data != null) {
        final String msg = response.data!.message;
        debugPrint('Success: $msg');
        _showSuccess(msg);
        await Future.delayed(const Duration(milliseconds: 600));
        // Signal view to navigate
        isSuccess.value = true;
      } else {
        _showError(response.errorMessage ?? 'Failed to reset password. Please try again.');
      }
    } catch (e) {
      debugPrint('Error ResetPassword: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
  void navigateBack(BuildContext context) {
    if (context.mounted) Navigator.of(context).pop();
  }
  bool _validateFields() {
    if (_resetToken.value.isEmpty) { _showError('Reset token missing. Please restart the process.'); return false; }
    if (newPassword.isEmpty) { _showError('New password is required'); return false; }
    if (newPassword.length < 8) { _showError('Password must be at least 8 characters'); return false; }
    if (!newPassword.contains(RegExp(r'[A-Z]'))) { _showError('Password must contain at least one uppercase letter'); return false; }
    if (!newPassword.contains(RegExp(r'[a-z]'))) { _showError('Password must contain at least one lowercase letter'); return false; }
    if (!newPassword.contains(RegExp(r'[0-9]'))) { _showError('Password must contain at least one number'); return false; }
    if (confirmPassword.isEmpty) { _showError('Please confirm your password'); return false; }
    if (confirmPassword != newPassword) { _showError('Passwords do not match'); return false; }
    return true;
  }
  void _showError(String message) => Fluttertoast.showToast(
    msg: message, toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color(0xFFF44336),
    textColor: Colors.white, fontSize: 15.0,
  );
  void _showSuccess(String message) => Fluttertoast.showToast(
    msg: message, toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: const Color(0xFF4CAF50),
    textColor: Colors.white, fontSize: 15.0,
  );
}
