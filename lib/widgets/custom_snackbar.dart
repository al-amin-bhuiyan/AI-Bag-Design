import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import '../utils/app_fonts.dart';

/// CustomSnackBar - Reusable toast notification widget
/// Follows OOP principles with customization options
class CustomSnackBar {
  // Private constructor to prevent instantiation
  CustomSnackBar._();

  /// Shows a success toast
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    _showToast(
      context,
      message: message,
      type: ToastificationType.success,
      backgroundColor:Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.check_circle_outline,
      iconColor: Colors.white,
      borderColor: const Color(0xFF22C55E),
      duration: duration,
    );
  }

  /// Shows an error toast
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message: message,
      type: ToastificationType.error,
      backgroundColor: const Color(0xFF0F0F0F),
      foregroundColor: Colors.white,
      icon: Icons.error_outline,
      iconColor: const Color(0xFFEF4444),
      borderColor: const Color(0xFFEF4444),
      duration: duration,
    );
  }

  /// Shows an info toast
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message: message,
      type: ToastificationType.info,
      backgroundColor: const Color(0xFF0F0F0F),
      foregroundColor: Colors.white,
      icon: Icons.info_outline,
      iconColor: const Color(0xFF3B82F6),
      borderColor: const Color(0xFF3B82F6),
      duration: duration,
    );
  }

  /// Shows a warning toast
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      message: message,
      type: ToastificationType.warning,
      backgroundColor:Colors.green,
      foregroundColor: Colors.white,
      icon: Icons.warning_amber_outlined,
      iconColor: const Color(0xFFF59E0B),
      borderColor: const Color(0xFFF59E0B),
      duration: duration,
    );
  }

  /// Internal method to show toast notification
  static void _showToast(
    BuildContext context, {
    required String message,
    required ToastificationType type,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      autoCloseDuration: duration,
      title: Text(
        message,
        style: AppFonts.interMedium(
          fontSize: 14.sp,
          color: foregroundColor,
        ),
      ),
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: Icon(
        icon,
        color: iconColor,
        size: 24.sp,
      ),
      showIcon: true,
      primaryColor: iconColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      borderRadius: BorderRadius.circular(8.r),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ],
      showProgressBar: true,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: false,
    );
  }
}
