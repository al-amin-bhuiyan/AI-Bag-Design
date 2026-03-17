/// AppPath class defines all application route paths
/// Follows OOP principles with private constructor and constant route definitions
/// This ensures type-safety and prevents magic strings throughout the app
class AppPath {
  // Private constructor to prevent instantiation
  AppPath._();

  // Route path constants
  static const String splash = '/';
  static const String authGuard = '/';   // Initial route — resolves auth state
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verificationCode = '/verification-code';
  static const String changePassword = '/change-password';
  static const String setNewPassword = '/set-new-password';
  static const String resetSuccess = '/reset-success';
  static const String create = '/create';
  static const String collection = '/collection';
  static const String editProfile = '/edit-profile';
 // static const String collection = '/collection';
  static const String yourdesign = '/your-design';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String security = '/security';
  static const String helpSupport = '/help-support';
  static const String faqsHelpCenter = '/faqs-help-center';
  static const String contactSupport = '/contact-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String verificationCodefromsignup = '/verification-Code-from-signup';
  
  // Add more route paths here as the application grows

  /// Returns a list of all available routes
  /// Useful for debugging and route validation
  static List<String> get allRoutes => [
        splash,
        onboarding,
        login,
        signUp,
        forgotPassword,
        verificationCode,
        changePassword,
        resetSuccess,
        create,
        editProfile,
        collection,
        yourdesign,
        profile,
        settings,
        security,
        helpSupport,
        faqsHelpCenter,
        contactSupport,
        privacyPolicy,
        termsAndConditions,
    verificationCodefromsignup,
        // Add new routes to this list as they are created
      ];

  /// Validates if a given path is a registered route
  static bool isValidRoute(String path) {
    return allRoutes.contains(path);
  }
}