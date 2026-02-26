import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Dimentions class manages all application dimension constants
/// Follows OOP principles with organized spacing, sizing, and layout values
class Dimentions {
  // Private constructor to prevent instantiation
  Dimentions._();

  // Design base dimensions
  static const double _designWidth = 393.0;
  static const double _designHeight = 852.0;

  /// Gets the design base width
  static double get designWidth => _designWidth;

  /// Gets the design base height
  static double get designHeight => _designHeight;

  // Spacing constants (Responsive)
  static double get spacingXXS => 2.h;
  static double get spacingXS => 4.h;
  static double get spacingSM => 8.h;
  static double get spacingMD => 16.h;
  static double get spacingLG => 24.h;
  static double get spacingXL => 32.h;
  static double get spacingXXL => 48.h;
  static double get spacingXXXL => 64.h;

  // Padding constants
  static double get paddingXS => 4.w;
  static double get paddingSM => 8.w;
  static double get paddingMD => 16.w;
  static double get paddingLG => 24.w;
  static double get paddingXL => 32.w;

  // Margin constants
  static double get marginXS => 4.w;
  static double get marginSM => 8.w;
  static double get marginMD => 16.w;
  static double get marginLG => 24.w;
  static double get marginXL => 32.w;

  // Border radius constants
  static double get radiusXS => 2.r;
  static double get radiusSM => 4.r;
  static double get radiusMD => 8.r;
  static double get radiusLG => 12.r;
  static double get radiusXL => 16.r;
  static double get radiusXXL => 24.r;
  static double get radiusCircular => 100.r;

  // Icon sizes
  static double get iconXS => 16.sp;
  static double get iconSM => 20.sp;
  static double get iconMD => 24.sp;
  static double get iconLG => 32.sp;
  static double get iconXL => 48.sp;
  static double get iconXXL => 64.sp;

  // Font sizes
  static double get fontXS => 10.sp;
  static double get fontSM => 12.sp;
  static double get fontMD => 14.sp;
  static double get fontLG => 16.sp;
  static double get fontXL => 18.sp;
  static double get fontXXL => 20.sp;
  static double get fontH1 => 32.sp;
  static double get fontH2 => 28.sp;
  static double get fontH3 => 24.sp;
  static double get fontH4 => 20.sp;
  static double get fontH5 => 18.sp;
  static double get fontH6 => 16.sp;

  // Button dimensions
  static double get buttonHeight => 48.h;
  static double get buttonHeightSM => 36.h;
  static double get buttonHeightLG => 56.h;
  static double get buttonRadius => 8.r;

  // Input field dimensions
  static double get inputHeight => 48.h;
  static double get inputHeightSM => 36.h;
  static double get inputHeightLG => 56.h;
  static double get inputRadius => 8.r;

  // Card dimensions
  static double get cardRadius => 12.r;
  static double get cardElevation => 2.0;
  static double get cardPadding => 16.w;

  // App bar dimensions
  static double get appBarHeight => 56.h;
  static double get appBarElevation => 0.0;

  // Bottom navigation bar
  static double get bottomNavHeight => 60.h;
  static double get bottomNavIconSize => 24.sp;

  // Divider
  static double get dividerThickness => 1.0;
  static double get dividerIndent => 16.w;

  // Avatar sizes
  static double get avatarXS => 24.sp;
  static double get avatarSM => 32.sp;
  static double get avatarMD => 40.sp;
  static double get avatarLG => 56.sp;
  static double get avatarXL => 72.sp;
  static double get avatarXXL => 96.sp;

  // Splash screen specific dimensions
  static double get splashLogoWidth => 350.w;
  static double get splashLogoHeight => 98.h;
  static double get splashContainerWidth => 402.w;
  static double get splashContainerHeight => 874.h;

  // Status bar dimensions
  static double get statusBarHeight => 30.h;
  static double get statusBarPaddingHorizontal => 26.w;
  static double get statusBarPaddingBottom => 14.h;

  // Navigation bar dimensions (bottom system bar)
  static double get navBarHeight => 40.h;
  static double get navBarIndicatorWidth => 144.w;
  static double get navBarIndicatorHeight => 6.h;
  static double get navBarIndicatorRadius => 10.r;

  // Battery and signal indicators
  static double get batteryWidth => 25.w;
  static double get batteryHeight => 12.h;
  static double get batteryInnerWidth => 19.w;
  static double get batteryInnerHeight => 8.h;
  static double get batteryRadius => 1.r;

  static double get signalWidth => 20.w;
  static double get signalHeight => 14.h;

  static double get wifiWidth => 16.w;
  static double get wifiHeight => 14.h;

  static double get timeWidth => 54.w;
  static double get timeHeight => 21.h;
  static double get timeRadius => 20.r;

  // Custom method to get responsive width
  static double width(double size) => size.w;

  // Custom method to get responsive height
  static double height(double size) => size.h;

  // Custom method to get responsive radius
  static double radius(double size) => size.r;

  // Custom method to get responsive font size
  static double fontSize(double size) => size.sp;
}
