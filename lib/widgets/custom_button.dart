import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

/// CustomButton - A reusable button widget following OOP principles
/// Encapsulates button styling, behavior, and configuration
class CustomButton extends StatelessWidget {
  // Button properties
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.boxShadow,
  });

  /// Factory constructor for primary button style
  factory CustomButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    bool isDisabled = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return CustomButton(
      key: key,
      label: label,
      onPressed: onPressed,
      width: width,
      backgroundColor: const Color(0xFF1355BF),
      textColor: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      isLoading: isLoading,
      isDisabled: isDisabled,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      boxShadow: const [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 2,
          offset: Offset(0, 1),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 3,
          offset: Offset(0, 1),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Factory constructor for secondary button style
  factory CustomButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      label: label,
      onPressed: onPressed,
      width: width,
      backgroundColor: AppColors.secondary,
      textColor: AppColors.primary,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      isLoading: isLoading,
      isDisabled: isDisabled,
      boxShadow: const [
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 2,
          offset: Offset(0, 1),
          spreadRadius: -1,
        ),
        BoxShadow(
          color: Color(0x19000000),
          blurRadius: 3,
          offset: Offset(0, 1),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// Factory constructor for outlined button style
  factory CustomButton.outlined({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    double? width,
    bool isLoading = false,
    bool isDisabled = false,
  }) {
    return CustomButton(
      key: key,
      label: label,
      onPressed: onPressed,
      width: width,
      backgroundColor: Colors.transparent,
      textColor: AppColors.primary,
      fontSize: 18,
      fontWeight: FontWeight.w400,
      borderRadius: 8,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      isLoading: isLoading,
      isDisabled: isDisabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _ButtonWrapper(
      width: width,
      height: height,
      onPressed: _handlePress,
      child: _ButtonContent(
        backgroundColor: _getBackgroundColor(),
        borderRadius: borderRadius ?? 8,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        boxShadow: boxShadow,
        child: _ButtonRow(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          isLoading: isLoading,
          label: _ButtonLabel(
            text: label,
            textColor: _getTextColor(),
            fontSize: fontSize ?? 18,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
      ),
    );
  }

  /// Handles button press with loading and disabled states
  void _handlePress() {
    if (!isLoading && !isDisabled && onPressed != null) {
      onPressed!();
    }
  }

  /// Gets the effective background color based on state
  Color _getBackgroundColor() {
    if (isDisabled) {
      return AppColors.borderDark;
    }
    return backgroundColor ?? AppColors.primary;
  }

  /// Gets the effective text color based on state
  Color _getTextColor() {
    if (isDisabled) {
      return AppColors.textDisabled;
    }
    return textColor ?? Colors.white;
  }
}

/// Private wrapper widget for button container
/// Encapsulates width, height, and gesture handling
class _ButtonWrapper extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final Widget child;

  const _ButtonWrapper({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width?.w ?? 350.w,
        height: height?.h,
        child: child,
      ),
    );
  }
}

/// Private widget for button visual content
/// Encapsulates decoration and padding
class _ButtonContent extends StatelessWidget {
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final List<BoxShadow>? boxShadow;
  final Widget child;

  const _ButtonContent({
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
    this.boxShadow,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        shadows: boxShadow,
      ),
      child: child,
    );
  }
}

/// Private widget for button row layout
/// Encapsulates icon and label arrangement
class _ButtonRow extends StatelessWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final Widget label;

  const _ButtonRow({
    required this.prefixIcon,
    required this.suffixIcon,
    required this.isLoading,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Prefix icon
        if (prefixIcon != null && !isLoading) ...[
          prefixIcon!,
          SizedBox(width: 10.w),
        ],

        // Loading indicator
        if (isLoading) ...[
          SizedBox(
            width: 18.sp,
            height: 18.sp,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(width: 10.w),
        ],

        // Label
        label,

        // Suffix icon
        if (suffixIcon != null && !isLoading) ...[
          SizedBox(width: 10.w),
          suffixIcon!,
        ],
      ],
    );
  }
}

/// Private widget for button label text
/// Encapsulates text styling
class _ButtonLabel extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;

  const _ButtonLabel({
    required this.text,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.poppinsRegular(
        fontSize: fontSize.sp,
        color: textColor,
      ).copyWith(
        fontWeight: fontWeight,
        height: 1.44,
      ),
    );
  }
}
