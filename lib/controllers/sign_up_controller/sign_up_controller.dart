import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/network/network_manager.dart';
import '../../widgets/dialogs/terms_and_privacy_dialog.dart';

/// SignUpController manages sign up screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class SignUpController extends GetxController {
  // Text editing controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxBool _agreeToTerms = false.obs;
  final RxBool _obscurePassword = true.obs;
  final RxBool _obscureConfirmPassword = true.obs;

  // Dependency
  final AuthService _authService = AuthService.instance;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get agreeToTerms => _agreeToTerms.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get obscureConfirmPassword => _obscureConfirmPassword.value;

  // Field value getters
  String get fullName => fullNameController.text.trim();
  String get email => emailController.text.trim();
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored on Sign Up screen.');
        }
      });
    }
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Disposes text editing controllers
  void _disposeControllers() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  /// Toggles terms and privacy agreement
  void toggleAgreeToTerms() {
    _agreeToTerms.value = !_agreeToTerms.value;
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  /// Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
  }

  /// Validates full name
  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

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

  /// Validates password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates all fields and shows toast on error
  bool _validateFields() {
    final nameError = validateFullName(fullName);
    if (nameError != null) {
      _showError(nameError);
      return false;
    }

    final emailError = validateEmail(email);
    if (emailError != null) {
      _showError(emailError);
      return false;
    }

    final passwordError = validatePassword(password);
    if (passwordError != null) {
      _showError(passwordError);
      return false;
    }

    final confirmError = validateConfirmPassword(confirmPassword);
    if (confirmError != null) {
      _showError(confirmError);
      return false;
    }

    if (!_agreeToTerms.value) {
      _showError('Please agree to terms and privacy policy');
      return false;
    }

    return true;
  }

  /// Handles sign up action - calls real API
  Future<void> signUp(BuildContext context) async {
    debugPrint('🚀 signUp() called');

    if (!_validateFields()) return;

    _isLoading.value = true;

    try {
      final response = await _authService.register(
        name: fullName,
        email: email,
        password: password,
        password2: confirmPassword,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        debugPrint('✅ Registration successful: ${data.email}');
        _showSuccess(data.message.isNotEmpty
            ? data.message
            : 'Registration successful! Please verify your email.');

        // Navigate to OTP verification screen (signup flow)
        if (context.mounted) {
          context.push(
            '${AppPath.verificationCodefromsignup}?email=${Uri.encodeComponent(email)}',
          );
        }
      } else {
        _showError(response.errorMessage ?? 'Registration failed. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ SignUp error: $e');
      _showError('Registration failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles sign up with Google
  Future<void> signUpWithGoogle() async {
    _showInfo('Google sign up coming soon!');
  }

  /// Handles sign up with Apple
  Future<void> signUpWithApple() async {
    _showInfo('Apple sign up coming soon!');
  }

  /// Navigates to sign in screen
  void navigateToSignIn(BuildContext context) {
    context.go(AppPath.login);
  }

  /// Shows Terms and Conditions as a popup dialog
  void showTermsAndPrivacy(BuildContext context) {
    TermsAndPrivacyDialog.show(context);
  }

  // ============ Toast Helpers ============

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

  void _showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
}