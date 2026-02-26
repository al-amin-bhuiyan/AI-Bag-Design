import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppFonts class manages all application text styles
/// Follows OOP principles with factory methods for different text styles
class AppFonts {
  // Private constructor to prevent instantiation
  AppFonts._();

  // Font weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  /// Creates a Poppins text style with regular weight
  static TextStyle poppinsRegular({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: regular,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with medium weight
  static TextStyle poppinsMedium({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: medium,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with semi-bold weight
  static TextStyle poppinsSemiBold({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: semiBold,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with bold weight
  static TextStyle poppinsBold({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: bold,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with light weight
  static TextStyle poppinsLight({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: light,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with extra-bold weight
  static TextStyle poppinsExtraBold({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: extraBold,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with black weight
  static TextStyle poppinsBlack({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: black,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with thin weight
  static TextStyle poppinsThin({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: thin,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates a Poppins text style with extra-light weight
  static TextStyle poppinsExtraLight({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: extraLight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // ============ Inter Font Family ============

  /// Creates an Inter text style with regular weight
  static TextStyle interRegular({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: regular,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates an Inter text style with medium weight
  static TextStyle interMedium({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: medium,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates an Inter text style with semi-bold weight
  static TextStyle interSemiBold({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: semiBold,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  /// Creates an Inter text style with bold weight
  static TextStyle interBold({
    double? fontSize,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize?.sp ?? 14.sp,
      fontWeight: bold,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );
  }

  // ============ Predefined Text Styles ============

  // Predefined text styles for common use cases
  
  /// Heading 1 style
  static TextStyle get h1 => poppinsBold(fontSize: 32);
  
  /// Heading 2 style
  static TextStyle get h2 => poppinsBold(fontSize: 28);
  
  /// Heading 3 style
  static TextStyle get h3 => poppinsSemiBold(fontSize: 24);
  
  /// Heading 4 style
  static TextStyle get h4 => poppinsSemiBold(fontSize: 20);
  
  /// Heading 5 style
  static TextStyle get h5 => poppinsMedium(fontSize: 18);
  
  /// Heading 6 style
  static TextStyle get h6 => poppinsMedium(fontSize: 16);
  
  /// Body large style
  static TextStyle get bodyLarge => poppinsRegular(fontSize: 16);
  
  /// Body medium style
  static TextStyle get bodyMedium => poppinsRegular(fontSize: 14);
  
  /// Body small style
  static TextStyle get bodySmall => poppinsRegular(fontSize: 12);
  
  /// Caption style
  static TextStyle get caption => poppinsRegular(fontSize: 12);
  
  /// Overline style
  static TextStyle get overline => poppinsRegular(fontSize: 10, letterSpacing: 1.5);
  
  /// Button style
  static TextStyle get button => poppinsMedium(fontSize: 14, letterSpacing: 0.5);
}
