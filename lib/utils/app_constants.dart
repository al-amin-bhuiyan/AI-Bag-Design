/// AppConstants - Centralized application constants
/// Follows OOP principles with private constructor and static members
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ─── Base URL ───────────────────────────────────────────────────────────────
  static const String baseUrl = 'http://18.233.192.169:8000';

  // ─── API Endpoints ──────────────────────────────────────────────────────────
  static const String registerEndpoint = '/accounts/user/register/';
  static const String verifyOtpSignupEndpoint = '/accounts/user/verify-otp/';
  static const String loginEndpoint = '/accounts/user/login/';
  static const String forgotPasswordEndpoint = '/accounts/user/forgot-password/';
  static const String sendResetPasswordEmailEndpoint = '/accounts/user/send-reset-password-email/';
  static const String resetPasswordOtpEndpoint = '/accounts/user/reset-password-otp/';
  static const String setNewPasswordEndpoint = '/accounts/user/set-new-password/';
  static const String verifyOtpForgotEndpoint = '/accounts/user/verify-otp-forgot/';
  static const String changePasswordEndpoint = '/accounts/user/change-password/';
  static const String resendOtpEndpoint = '/accounts/user/resend-otp/';
  static const String profileEndpoint = '/accounts/user/profile/';
  static const String deleteAccountEndpoint = '/accounts/user/delete-account/';
  static const String tokenRefreshEndpoint = '/accounts/user/token/refresh/';
  static const String tokenVerifyEndpoint = '/accounts/user/token/verify/';
  
  // ─── Bag Design API Endpoints ───────────────────────────────────────────────
  static const String uploadLogoEndpoint = '/api/upload-logo/';
  static const String generateDesignEndpoint = '/api/generate-design/';
  static const String generateLogoEndpoint = '/api/generate-logo/';
  static const String saveCollectionEndpoint = '/api/collections/save/';
  static const String collectionsListEndpoint = '/api/collections/';
  static String collectionByIdEndpoint(String id) => '/api/collections/$id/';

  // ─── Timeouts ────────────────────────────────────────────────────────────────
  static const int connectTimeoutSeconds = 30;
  static const int receiveTimeoutSeconds = 30;

  // ─── AI Generation Timeout ────────────────────────────────────────────────
  // AI design generation can take up to several minutes — allow 10 minutes
  static const int aiGenerationTimeoutSeconds = 600; // 10 minutes

  // ─── App Info ────────────────────────────────────────────────────────────────
  static const String appName = 'AI Bag Design';
}

/// SplashConfig - Splash screen timing configuration
class SplashConfig {
  SplashConfig._();

  /// Duration the splash screen is shown before navigating
  static const Duration splashDuration = Duration(seconds: 3);
}