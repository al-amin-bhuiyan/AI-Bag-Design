import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/api_response_model.dart';
import '../../models/login_model.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/auth_state_service.dart';
import '../../services/network/network_manager.dart';
import '../../services/session_data_isolation_service.dart';
import '../../services/token_storage_service.dart';
import '../../services/user_session_service.dart';

/// LogInController manages login screen logic and state
/// Calls real login API, persists JWT tokens, and navigates to create screen
/// Follows 100% OOP: encapsulation, single responsibility, composition
class LogInController extends GetxController {
  // ─── Dependencies (Composition) ───────────────────────────────────────────
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  // ─── Text Editing Controllers ─────────────────────────────────────────────
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ─── Observable state ────────────────────────────────────────────────────
  final RxBool _isLoading = false.obs;
  final RxBool _rememberMe = false.obs;
  final RxBool _obscurePassword = true.obs;

  // ─── Public Getters ───────────────────────────────────────────────────────
  bool get isLoading => _isLoading.value;
  bool get rememberMe => _rememberMe.value;
  bool get obscurePassword => _obscurePassword.value;
  String get email => emailController.text.trim();
  String get password => passwordController.text;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadSavedEmail();

    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored on Login screen.');
        }
      });
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ─── Public Methods ───────────────────────────────────────────────────────

  /// Toggles remember me checkbox
  void toggleRememberMe() => _rememberMe.value = !_rememberMe.value;

  /// Toggles password visibility
  void togglePasswordVisibility() =>
      _obscurePassword.value = !_obscurePassword.value;

  /// Validates email format
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validates password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /// Handles sign in action — calls real API
  Future<void> signIn(BuildContext context) async {
    // Validate fields and show toast on error
    final emailError = validateEmail(email);
    if (emailError != null) { _showError(emailError); return; }

    final passwordError = validatePassword(password);
    if (passwordError != null) { _showError(passwordError); return; }

    _isLoading.value = true;

    try {
      debugPrint('🔑 Logging in: $email');

      final ApiResponse<LoginResponseModel> response =
          await _authService.login(email: email, password: password);

      if (response.success && response.data != null) {
        final LoginResponseModel data = response.data!;

        if (data.accessToken.trim().isEmpty || data.refreshToken.trim().isEmpty) {
          _showError('Login failed. Please check your credentials.');
          return;
        }

        debugPrint('✅ Login success: ${data.user.name}');

        // Ensure old in-memory user data/controllers are removed on account switch.
        SessionDataIsolationService.instance.clearUserScopedState();

        // Persist tokens and user info
        await _tokenStorage.saveTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _tokenStorage.saveUserInfo(
          id: data.user.id,
          email: data.user.email,
          name: data.user.name,
          image: data.user.image,
        );

        // Save remember me and password for auto-login on token expiry
        await _tokenStorage.saveRememberMe(
          rememberMe: _rememberMe.value,
          password: _rememberMe.value ? password : '',
        );

        // Populate UserSessionService (single source of truth)
        // so ProfileCard, NavBar etc. show real data instantly without re-fetching
        UserSessionService.instance.id.value       = data.user.id;
        UserSessionService.instance.name.value     = data.user.name;
        UserSessionService.instance.email.value    = data.user.email;
        UserSessionService.instance.imageUrl.value =
            data.user.image.startsWith('http')
                ? data.user.image
                : 'http://18.233.192.169:8000${data.user.image}';
        UserSessionService.instance.isLoaded.value = true;

        // Mark auth state as authenticated
        AuthStateService.instance.setAuthenticated();

        _showSuccess('Welcome back, ${data.user.name}! 👋');

        // Small delay so toast is visible
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate to create screen — replace entire stack
        if (context.mounted) context.go(AppPath.create);
      } else {
        _showError(_normalizeLoginErrorMessage(response.errorMessage));
      }
    } catch (e) {
      debugPrint('❌ Login error: $e');
      _showError('Login failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Handles Google sign in (placeholder)
  Future<void> signInWithGoogle() async {
    _showInfo('Google sign in coming soon!');
  }

  /// Handles Apple sign in (placeholder)
  Future<void> signInWithApple() async {
    _showInfo('Apple sign in coming soon!');
  }

  /// Navigates to forgot password screen
  void forgotPassword(BuildContext context) {
    context.push(AppPath.forgotPassword);
  }

  /// Navigates to sign up screen
  void navigateToSignUp(BuildContext context) {
    context.push(AppPath.signUp);
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  /// Pre-fills email if remembered
  Future<void> _loadSavedEmail() async {
    final savedEmail = await _tokenStorage.getUserEmail();
    final isRememberMe = await _tokenStorage.getRememberMe();
    final savedPassword = await _tokenStorage.getUserPassword();

    if (savedEmail != null && savedEmail.isNotEmpty && isRememberMe) {
      emailController.text = savedEmail;
      _rememberMe.value = true;
      if (savedPassword != null && savedPassword.isNotEmpty) {
        passwordController.text = savedPassword;
      }
    }
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

  String _normalizeLoginErrorMessage(String? message) {
    final raw = (message ?? '').trim();
    if (raw.isEmpty) return 'Login failed. Please check your email and password.';

    final lower = raw.toLowerCase();
    if (lower.contains('authentication failed') ||
        lower.contains('please login') ||
        lower.contains('please log in') ||
        lower.contains('credentials')) {
      return 'Invalid email or password.';
    }

    return raw;
  }
}
