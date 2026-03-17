import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/token_storage_service.dart';
import '../../utils/app_constants.dart';

/// SplashController - Decides where to navigate after splash
///
/// Logic:
///   1. First time ever           → Onboarding → Login
///   2. Has token & token valid   → Create (home)
///   3. Has token & expired       → Try refresh → Create (home) or Login
///   4. No token                  → Login (seen onboarding before)
///
/// Follows 100% OOP: single responsibility, encapsulation, composition
class SplashController extends GetxController {
  // ─── Dependencies ─────────────────────────────────────────────────────────
  final TokenStorageService _tokenStorage = TokenStorageService.instance;
  final AuthService _authService = AuthService.instance;

  // ─── State ────────────────────────────────────────────────────────────────
  final RxBool _isNavigating = false.obs;
  bool get isNavigating => _isNavigating.value;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initializeSplash();
  }

  // ─── Private Methods ──────────────────────────────────────────────────────

  /// Waits for splash duration then determines navigation destination
  Future<void> _initializeSplash() async {
    if (_isNavigating.value) return;
    _isNavigating.value = true;
    await Future.delayed(SplashConfig.splashDuration);
    await _determineNavigation();
  }

  /// Always gets a fresh context reference after async gaps
  void _navigate(String path) {
    final ctx = Get.context;
    if (ctx != null && ctx.mounted) {
      ctx.go(path);
    }
  }

  /// Determines where to navigate based on auth state
  Future<void> _determineNavigation() async {
    try {
      // ── Step 1: First-time user? ─────────────────────────────────────────
      final bool seenOnboarding = await _tokenStorage.hasSeenOnboarding();
      if (!seenOnboarding) {
        debugPrint('🆕 First-time user → Onboarding');
        _navigate(AppPath.onboarding);
        return;
      }

      // ── Step 2: Any access token saved? ──────────────────────────────────
      final String? accessToken = await _tokenStorage.getAccessToken();
      final String? refreshToken = await _tokenStorage.getRefreshToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('🔓 No token → Login');
        _navigate(AppPath.login);
        return;
      }

      // ── Step 3: Verify access token ──────────────────────────────────────
      final verifyResponse = await _authService.verifyToken(token: accessToken);

      if (verifyResponse.success) {
        debugPrint('✅ Token valid → Create (home)');
        _navigate(AppPath.create);
        return;
      }

      // ── Step 4: Try refresh token ─────────────────────────────────────────
      debugPrint('🔄 Token expired — trying refresh...');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final refreshResponse =
            await _authService.refreshToken(refreshToken: refreshToken);

        if (refreshResponse.success && refreshResponse.data != null) {
          final newAccessToken =
              refreshResponse.data!['access'] as String? ?? '';

          if (newAccessToken.isNotEmpty) {
            await _tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );
            debugPrint('✅ Token refreshed → Create (home)');
            _navigate(AppPath.create);
            return;
          }
        }
      }

      // ── Step 5: All tokens invalid — clear and go to login ────────────────
      debugPrint('🔓 Tokens expired → Login');
      await _tokenStorage.clearAll();
      _navigate(AppPath.login);
    } catch (e) {
      debugPrint('❌ Splash auth check error: $e');
      _navigate(AppPath.login);
    }
  }
}