import 'package:flutter/foundation.dart';
import '../models/api_response_model.dart';
import 'auth_service.dart';
import 'token_storage_service.dart';

/// AuthState - Represents the possible authentication states of the app
/// Used by GoRouter redirect to decide where to send the user
enum AuthState {
  /// User has never opened the app before — show onboarding
  firstLaunch,

  /// User has seen onboarding but is not logged in — show login
  unauthenticated,

  /// User is logged in with a valid token — show home
  authenticated,
}

/// AuthStateService - Determines the user's authentication state on app start
/// This is the single source of truth for auth-based navigation decisions
///
/// Real-life flow (Instagram / YouTube pattern):
///   Install fresh         → firstLaunch   → Onboarding → Login
///   Logged out previously → unauthenticated → Login
///   Logged in, token OK   → authenticated  → Home (create)
///   Logged in, expired    → try refresh    → authenticated or unauthenticated
///
/// Follows 100% OOP: singleton, encapsulation, single responsibility
class AuthStateService {
  // ─── Singleton ────────────────────────────────────────────────────────────
  AuthStateService._();
  static final AuthStateService _instance = AuthStateService._();
  static AuthStateService get instance => _instance;

  // ─── Dependencies (Composition) ───────────────────────────────────────────
  final TokenStorageService _tokenStorage = TokenStorageService.instance;
  final AuthService _authService = AuthService.instance;

  // ─── Cached state — resolved once on startup ──────────────────────────────
  AuthState? _cachedState;

  /// Whether auth state has been resolved yet
  bool get isResolved => _cachedState != null;

  /// The resolved auth state (null if not yet determined)
  AuthState? get state => _cachedState;

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Resolves the auth state once on app startup and caches it.
  /// Subsequent calls return the cached value immediately.
  Future<AuthState> resolve() async {
    if (_cachedState != null) return _cachedState!;

    _cachedState = await _determineAuthState();
    debugPrint('🔐 AuthState resolved: $_cachedState');
    return _cachedState!;
  }

  /// Resets cached state — call this after login/logout so next
  /// resolution re-checks storage (e.g., after logout redirect)
  void reset() {
    _cachedState = null;
    debugPrint('🔄 AuthState cache cleared');
  }

  /// Forces a specific state — used after successful login/logout
  void setAuthenticated() {
    _cachedState = AuthState.authenticated;
  }

  void setUnauthenticated() {
    _cachedState = AuthState.unauthenticated;
  }

  // ─── Private Logic ────────────────────────────────────────────────────────

  /// Core logic that determines AuthState from storage + API
  Future<AuthState> _determineAuthState() async {
    try {
      // ── Step 1: First-time install? ───────────────────────────────────────
      final bool seenOnboarding = await _tokenStorage.hasSeenOnboarding();
      if (!seenOnboarding) {
        debugPrint('🆕 No onboarding seen → firstLaunch');
        return AuthState.firstLaunch;
      }

      // ── Step 2: Any token stored? ─────────────────────────────────────────
      final String? accessToken = await _tokenStorage.getAccessToken();
      final String? refreshToken = await _tokenStorage.getRefreshToken();

      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('🔓 No token stored → unauthenticated');
        return AuthState.unauthenticated;
      }

      // ── Step 3: Verify access token with API ──────────────────────────────
      final ApiResponse<Map<String, dynamic>> verifyResponse =
          await _authService.verifyToken(token: accessToken);

      if (verifyResponse.success) {
        debugPrint('✅ Token valid → authenticated');
        return AuthState.authenticated;
      }

      // ── Step 4: Access token expired — try refresh ────────────────────────
      debugPrint('🔄 Token expired — trying refresh...');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final ApiResponse<Map<String, dynamic>> refreshResponse =
            await _authService.refreshToken(refreshToken: refreshToken);

        if (refreshResponse.success && refreshResponse.data != null) {
          final String newAccessToken =
              refreshResponse.data!['access'] as String? ?? '';

          if (newAccessToken.isNotEmpty) {
            // Save new access token and keep using app
            await _tokenStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: refreshToken,
            );
            debugPrint('✅ Token refreshed → authenticated');
            return AuthState.authenticated;
          }
        }
      }

      // ── Step 5: Both tokens invalid or expired — try auto login ───────────
      final bool isRememberMe = await _tokenStorage.getRememberMe();
      if (isRememberMe) {
        final String? email = await _tokenStorage.getUserEmail();
        final String? password = await _tokenStorage.getUserPassword();

        if (email != null && email.isNotEmpty && password != null && password.isNotEmpty) {
          debugPrint('🔄 Tokens expired but Remember Me is active. Attempting silent auto-login...');
          final loginResponse = await _authService.login(email: email, password: password);

          if (loginResponse.success && loginResponse.data != null &&
              loginResponse.data!.accessToken.isNotEmpty &&
              loginResponse.data!.refreshToken.isNotEmpty) {

            // Persist new tokens and user info
            await _tokenStorage.saveTokens(
              accessToken: loginResponse.data!.accessToken,
              refreshToken: loginResponse.data!.refreshToken,
            );
            await _tokenStorage.saveUserInfo(
              id: loginResponse.data!.user.id,
              email: loginResponse.data!.user.email,
              name: loginResponse.data!.user.name,
              image: loginResponse.data!.user.image,
            );

            debugPrint('✅ Silent auto-login successful → authenticated');
            return AuthState.authenticated;
          }
        }
      }

      // ── Step 6: All attempts failed — clear and send to login ─────────────
      debugPrint('🔓 All tokens invalid and auto-login failed/disabled → unauthenticated');
      // Notice we do NOT pass isManualLogout: true so email is remembered
      await _tokenStorage.clearAll();
      return AuthState.unauthenticated;
    } catch (e) {
      // Network errors etc. — default to login (safe fallback)
      debugPrint('❌ AuthState error: $e → unauthenticated');
      return AuthState.unauthenticated;
    }
  }
}
