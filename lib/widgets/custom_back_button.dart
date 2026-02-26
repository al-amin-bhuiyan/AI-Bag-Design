import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// CustomBackButton - Reusable back button widget
/// Follows OOP principles with composition and customization options
class CustomBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? iconSize;

  const CustomBackButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => _handleBackPress(context),
      child: Container(
        width: size ?? 40,
        height: size ?? 40,
        decoration: ShapeDecoration(
          color: backgroundColor ?? Colors.black.withValues(alpha: 0.10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: iconSize ?? 24,
            color: iconColor ?? Colors.black,
          ),
        ),
      ),
    );
  }

  /// Default back press handler
  void _handleBackPress(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
