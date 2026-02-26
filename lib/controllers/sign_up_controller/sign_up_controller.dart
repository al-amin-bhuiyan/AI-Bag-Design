import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../routes/app_path.dart';

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

  // Getters
  bool get isLoading => _isLoading.value;
  bool get agreeToTerms => _agreeToTerms.value;
  bool get obscurePassword => _obscurePassword.value;
  bool get obscureConfirmPassword => _obscureConfirmPassword.value;
  
  // Field value getters
  String get fullName => fullNameController.text;
  String get email => emailController.text;
  String get password => passwordController.text;
  String get confirmPassword => confirmPasswordController.text;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Initializes the controller
  void _initializeController() {
    // Any initialization logic
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
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    
    if (value.length < 2) {
      return 'Full name must be at least 2 characters';
    }
    
    return null;
  }

  /// Validates email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
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
    
    // Check for at least one uppercase, one lowercase, and one number
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
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

  /// Validates all fields
  bool validateFields() {
    debugPrint('🔍 Starting field validation...');
    
    final nameError = validateFullName(fullName);
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    final confirmPasswordError = validateConfirmPassword(confirmPassword);
    
    if (nameError != null) {
      debugPrint('❌ Name validation failed: $nameError');
      _showError(nameError);
      return false;
    }
    
    if (emailError != null) {
      debugPrint('❌ Email validation failed: $emailError');
      _showError(emailError);
      return false;
    }
    
    if (passwordError != null) {
      debugPrint('❌ Password validation failed: $passwordError');
      _showError(passwordError);
      return false;
    }
    
    if (confirmPasswordError != null) {
      debugPrint('❌ Confirm password validation failed: $confirmPasswordError');
      _showError(confirmPasswordError);
      return false;
    }
    
    if (!_agreeToTerms.value) {
      debugPrint('❌ Terms not agreed');
      _showError('Please agree to terms and privacy policy');
      return false;
    }
    
    debugPrint('✅ All validations passed!');
    return true;
  }

  /// Shows error message
  void _showError(String message) {
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

  /// Shows success message
  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  /// Handles sign up action
  Future<void> signUp(BuildContext context) async {
    debugPrint('========================================');
    debugPrint('🚀 Sign up button pressed!');
    debugPrint('Full Name: ${fullNameController.text}');
    debugPrint('Email: ${emailController.text}');
    debugPrint('Password: ${passwordController.text}');
    debugPrint('Confirm Password: ${confirmPasswordController.text}');
    debugPrint('Agree to Terms: $_agreeToTerms');
    debugPrint('========================================');
    
    if (!validateFields()) {
      debugPrint('❌ Validation FAILED - Stopping signup process');
      return;
    }
    
    debugPrint('✅ Validation PASSED - Proceeding with signup');
    
    try {
      _isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual sign up logic
      debugPrint('========================================');
      debugPrint('✅ Signing up with:');
      debugPrint('Name: $fullName');
      debugPrint('Email: $email');
      debugPrint('Password: $password');
      debugPrint('========================================');
      
      _showSuccess('Registration successful!');
      
      // Navigate to sign in screen after successful registration
      if (context.mounted) {
        debugPrint('🔄 Navigating to login screen...');
        context.push(AppPath.create);
      }
      
    } catch (e) {
      debugPrint('❌ Error during signup: ${e.toString()}');
      _showError('Registration failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles sign up with Google
  Future<void> signUpWithGoogle() async {
    try {
      _isLoading.value = true;
      
      // TODO: Implement Google sign up
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Signing up with Google');
      
      Fluttertoast.showToast(
        msg: 'Google sign up coming soon!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF2196F3),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      
    } catch (e) {
      _showError('Google sign up failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles sign up with Apple
  Future<void> signUpWithApple() async {
    try {
      _isLoading.value = true;
      
      // TODO: Implement Apple sign up
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Signing up with Apple');
      
      Fluttertoast.showToast(
        msg: 'Apple sign up coming soon!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xFF000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      
    } catch (e) {
      _showError('Apple sign up failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigates to sign in screen
  void navigateToSignIn(BuildContext context) {
    context.go(AppPath.login);
  }

  /// Shows terms and privacy dialog
  void showTermsAndPrivacy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Terms and Privacy'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms and Privacy Policy\n\n'
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
            'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\n\n'
            'Please read and accept our terms to continue.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              toggleAgreeToTerms();
              Get.back();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}
