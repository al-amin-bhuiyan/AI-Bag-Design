import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'custom_button.dart';

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
    final double buttonSize = size ?? 40.r;

    return CircleFadeAnimation(
      onPressed: onPressed ?? () => _handleBackPress(context),
      // Fully circular clip
      borderRadius: BorderRadius.circular(buttonSize / 2),
      // Dark splash looks better on light bg buttons
      splashColor: Colors.black,
      child: _BackButtonContainer(
        size: buttonSize,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        iconSize: iconSize,
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

/// Private container for back button visuals
/// OOP: Separates visual rendering from gesture logic
class _BackButtonContainer extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const _BackButtonContainer({
    required this.size,
    this.backgroundColor,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
      child: Center(
        child: Icon(
          Icons.arrow_back_ios_new,
          size: iconSize ?? 24.r,
          color: iconColor ?? Colors.black,
        ),
      ),
    );
  }
}
