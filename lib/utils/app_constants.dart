import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dimentions.dart';

/// AppConstants class holds application-wide configuration constants
/// Follows OOP principles with private constructor and organized constant classes
/// This class serves as a central configuration hub for the entire application
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  /// Application metadata constants
  static const String appName = 'Jeebz Bag Design';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
}

/// SplashConfig holds all splash screen related configurations
/// Encapsulates splash screen behavior and appearance settings
class SplashConfig {
  SplashConfig._();

  // Duration settings
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration minimumDisplayTime = Duration(seconds: 2);
  static const Duration fadeInDuration = Duration(milliseconds: 500);
  static const Duration fadeOutDuration = Duration(milliseconds: 300);

  // Color settings - References AppColors for consistency
  static Color get backgroundColor => AppColors.splashBackground;
  static Color get logoTintColor => AppColors.primary;

  // Dimension settings - References Dimentions for responsiveness
  static double get logoWidth => Dimentions.splashLogoWidth;
  static double get logoHeight => Dimentions.splashLogoHeight;
  static double get containerWidth => Dimentions.splashContainerWidth;
  static double get containerHeight => Dimentions.splashContainerHeight;

  // Asset paths
  static const String backgroundImage = 'main_background.png';
  static const String logoImage = 'splash_logo.png';

  // Layout settings
  static double get logoSpacing => Dimentions.spacingLG;
  static double get contentPadding => Dimentions.paddingLG;

  // Status bar settings
  static double get statusBarHeight => Dimentions.statusBarHeight;
  static double get statusBarPaddingHorizontal => Dimentions.statusBarPaddingHorizontal;
  static double get statusBarPaddingBottom => Dimentions.statusBarPaddingBottom;

  // Navigation bar settings
  static double get navBarHeight => Dimentions.navBarHeight;
  static double get navBarIndicatorWidth => Dimentions.navBarIndicatorWidth;
  static double get navBarIndicatorHeight => Dimentions.navBarIndicatorHeight;
  static double get navBarIndicatorRadius => Dimentions.navBarIndicatorRadius;
  static Color get navBarIndicatorColor => AppColors.textPrimary;

  // Battery indicator settings
  static double get batteryWidth => Dimentions.batteryWidth;
  static double get batteryHeight => Dimentions.batteryHeight;
  static double get batteryInnerWidth => Dimentions.batteryInnerWidth;
  static double get batteryInnerHeight => Dimentions.batteryInnerHeight;
  static double get batteryRadius => Dimentions.batteryRadius;
  static Color get batteryColor => AppColors.textPrimary;

  // Signal indicator settings
  static double get signalWidth => Dimentions.signalWidth;
  static double get signalHeight => Dimentions.signalHeight;

  // Time indicator settings
  static double get timeWidth => Dimentions.timeWidth;
  static double get timeHeight => Dimentions.timeHeight;
  static double get timeRadius => Dimentions.timeRadius;
}

/// OnboardingConfig holds all onboarding screen configurations
class OnboardingConfig {
  OnboardingConfig._();

  static const int totalPages = 3;
  static const Duration autoAdvanceDuration = Duration(seconds: 5);
  static const bool enableAutoAdvance = false;

  // Colors
  static Color get backgroundColor => AppColors.background;
  static Color get activeIndicatorColor => AppColors.primary;
  static Color get inactiveIndicatorColor => AppColors.border;

  // Dimensions
  static double get indicatorSize => Dimentions.iconSM;
  static double get indicatorSpacing => Dimentions.spacingSM;
  static double get contentPadding => Dimentions.paddingLG;
}

/// AnimationConfig holds all animation-related configurations
class AnimationConfig {
  AnimationConfig._();

  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Animation curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve linear = Curves.linear;
}

/// NetworkConfig holds API and network-related configurations
class NetworkConfig {
  NetworkConfig._();

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // API base URLs (configure based on environment)
  static const String devBaseUrl = 'https://dev-api.example.com';
  static const String stagingBaseUrl = 'https://staging-api.example.com';
  static const String prodBaseUrl = 'https://api.example.com';

  // Current environment (change based on build configuration)
  static const String currentBaseUrl = devBaseUrl;
}

/// StorageConfig holds local storage configurations
class StorageConfig {
  StorageConfig._();

  // SharedPreferences keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyUserToken = 'user_token';
  static const String keyUserId = 'user_id';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';

  // Cache settings
  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100; // in MB
}

/// ValidationConfig holds form validation configurations
class ValidationConfig {
  ValidationConfig._();

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;

  // Regex patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String usernamePattern = r'^[a-zA-Z0-9_]{3,20}$';
}

/// UIConfig holds general UI configurations
class UIConfig {
  UIConfig._();

  // Page transition duration
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  // Snackbar/Toast duration
  static const Duration snackbarDuration = Duration(seconds: 3);
  static const Duration errorSnackbarDuration = Duration(seconds: 5);

  // Dialog settings
  static double get dialogRadius => Dimentions.radiusLG;
  static double get dialogPadding => Dimentions.paddingLG;

  // Bottom sheet settings
  static double get bottomSheetRadius => Dimentions.radiusXL;
  static double get bottomSheetMaxHeight => Dimentions.height(600);

  // Shimmer settings
  static Color get shimmerBaseColor => AppColors.borderLight;
  static Color get shimmerHighlightColor => AppColors.background;
  static const Duration shimmerPeriod = Duration(milliseconds: 1500);

  // Loading indicator
  static Color get loadingIndicatorColor => AppColors.primary;
  static double get loadingIndicatorSize => Dimentions.iconLG;
}

/// FeatureFlags holds feature toggle configurations
class FeatureFlags {
  FeatureFlags._();

  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableDebugMode = true;
  static const bool enableBiometricAuth = false;
  static const bool enablePushNotifications = true;
  static const bool enableInAppPurchases = false;
}

/// AppLimits holds various application limits
class AppLimits {
  AppLimits._();

  static const int maxUploadFileSizeMB = 10;
  static const int maxImagesPerUpload = 5;
  static const int maxCharactersInDescription = 500;
  static const int maxCharactersInComment = 200;
  static const int itemsPerPage = 20;
  static const int maxSearchResults = 50;
}
