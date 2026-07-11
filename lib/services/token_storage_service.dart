import 'package:shared_preferences/shared_preferences.dart';

/// TokenStorageService - Persists JWT tokens and user info in SharedPreferences
/// Follows OOP principles: singleton, encapsulation, single responsibility
class TokenStorageService {
  // Private constructor - singleton pattern
  TokenStorageService._();
  static final TokenStorageService _instance = TokenStorageService._();

  /// Singleton accessor
  static TokenStorageService get instance => _instance;

  // ─── Storage Keys ─────────────────────────────────────────────────────────
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';
  static const String _userImageKey = 'user_image';
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _rememberMeKey = 'remember_me';
  static const String _userPasswordKey = 'user_password';

  // ─── Save ─────────────────────────────────────────────────────────────────

  /// Saves both access and refresh tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Saves user info after login or signup OTP verification
  Future<void> saveUserInfo({
    required int id,
    required String email,
    required String name,
    String image = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, id);
    await prefs.setString(_userEmailKey, email);
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userImageKey, image);
  }

  /// Marks onboarding as seen — called after user finishes onboarding
  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasSeenOnboardingKey, true);
  }

  /// Saves remember me status and password securely (for auto-login)
  Future<void> saveRememberMe({required bool rememberMe, String password = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);
    if (rememberMe && password.isNotEmpty) {
      await prefs.setString(_userPasswordKey, password);
    } else {
      await prefs.remove(_userPasswordKey);
    }
  }

  // ─── Read ─────────────────────────────────────────────────────────────────

  /// Returns saved access token or null
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Returns saved refresh token or null
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Returns saved user email or null
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Returns saved user name or null
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Returns saved user id or null
  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Returns saved user image URL or null
  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userImageKey);
  }

  /// Returns true if user has seen onboarding
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasSeenOnboardingKey) ?? false;
  }

  /// Returns true if an access token is stored (user is logged in)
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Returns if remember me is checked
  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Returns saved user password or null
  Future<String?> getUserPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPasswordKey);
  }

  // ─── Clear ────────────────────────────────────────────────────────────────

  /// Clears tokens and user info (logout) — keeps onboarding flag
  Future<void> clearAll({bool isManualLogout = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userImageKey);

    // If it's a manual logout, clear remember me data too.
    // Otherwise, keep email and password so auto-login can trigger.
    if (isManualLogout) {
      await prefs.remove(_userEmailKey);
      await prefs.remove(_rememberMeKey);
      await prefs.remove(_userPasswordKey);
    }
  }
}
