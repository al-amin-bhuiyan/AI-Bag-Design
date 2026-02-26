import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_path.dart';

/// LogInController manages login screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class LogInController extends GetxController {
  // Text editing controllers
  final TextEditingController emailController = TextEditingController(text: 'md@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: '12345678');

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxBool _rememberMe = false.obs;
  final RxBool _obscurePassword = true.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get rememberMe => _rememberMe.value;
  bool get obscurePassword => _obscurePassword.value;
  
  // Email and password getters
  String get email => emailController.text;
  String get password => passwordController.text;

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
    // Load saved email if remember me was checked
    _loadSavedCredentials();
  }

  /// Disposes text editing controllers
  void _disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  /// Toggles remember me checkbox
  void toggleRememberMe() {
    _rememberMe.value = !_rememberMe.value;
  }

  /// Toggles password visibility
  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
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
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }

  /// Validates all fields
  bool validateFields() {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    
    if (emailError != null) {
      Get.snackbar(
        'Validation Error',
        emailError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    if (passwordError != null) {
      Get.snackbar(
        'Validation Error',
        passwordError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    return true;
  }

  /// Handles sign in action
  Future<void> signIn(BuildContext context) async {
    if (!validateFields()) return;
    
    try {
      _isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implement actual sign in logic
      debugPrint('Signing in with email: $email');
      
      if (_rememberMe.value) {
        _saveCredentials();
      }
      
      // Navigate to collections screen on success
      context.push(AppPath.create);
      
      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      _isLoading.value = true;
      
      // TODO: Implement Google sign in
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Signing in with Google');
      
      Get.snackbar(
        'Info',
        'Google sign in coming soon!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Google sign in failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles sign in with Apple
  Future<void> signInWithApple() async {
    try {
      _isLoading.value = true;
      
      // TODO: Implement Apple sign in
      await Future.delayed(const Duration(seconds: 1));
      debugPrint('Signing in with Apple');
      
      Get.snackbar(
        'Info',
        'Apple sign in coming soon!',
        snackPosition: SnackPosition.BOTTOM,
      );
      
    } catch (e) {
      Get.snackbar(
        'Error',
        'Apple sign in failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigates to forgot password screen
  void forgotPassword(BuildContext context) {
    context.push(AppPath.forgotPassword);
  }

  /// Navigates to sign up screen
  void navigateToSignUp(BuildContext context) {
    context.push(AppPath.signUp);
  }

  /// Loads saved credentials
  void _loadSavedCredentials() {
    // TODO: Implement loading from secure storage
    // Example: emailController.text = await storage.read('email');
  }

  /// Saves credentials if remember me is checked
  void _saveCredentials() {
    // TODO: Implement saving to secure storage
    // Example: await storage.write('email', email);
  }
}
