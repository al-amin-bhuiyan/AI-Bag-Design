import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../utils/app_colors.dart';
import '../utils/app_fonts.dart';

/// CircleFadeAnimation - Reusable ripple/circle fade animation on tap
/// OOP: Single responsibility — only handles the press animation effect
class CircleFadeAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;
  final Color? splashColor;

  const CircleFadeAnimation({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius,
    this.splashColor,
  });

  @override
  State<CircleFadeAnimation> createState() => _CircleFadeAnimationState();
}

class _CircleFadeAnimationState extends State<CircleFadeAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = box.globalToLocal(details.globalPosition);
    });
    _controller.forward(from: 0.0);
  }

  void _onTap() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTap: _onTap,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              foregroundPainter: _RipplePainter(
                center: _tapPosition,
                progress: _scaleAnimation.value,
                opacity: _opacityAnimation.value,
                color: widget.splashColor ?? Colors.white,
              ),
              child: child,
            );
          },
          child: widget.child,
        ),
      ),
    );
  }
}

/// _RipplePainter - Draws the expanding circle fade on canvas
/// OOP: Encapsulates all drawing logic in one place
class _RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final double opacity;
  final Color color;

  const _RipplePainter({
    required this.center,
    required this.progress,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    // Max radius = diagonal of the widget so ripple covers full area
    final maxRadius =
        (Offset.zero - Offset(size.width, size.height)).distance;
    final radius = maxRadius * progress;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.opacity != opacity;
  }
}

/// CustomCloseButton - Reusable X/close button with circle fade animation
/// OOP: Self-contained, composable, reusable across all dialogs and screens
class CustomCloseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final double? iconSize;
  final Color? splashColor;

  const CustomCloseButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.iconSize,
    this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = size ?? 28;

    return CircleFadeAnimation(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(buttonSize / 2),
      splashColor: splashColor ?? Colors.white,
      child: _CloseButtonContainer(
        size: buttonSize,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        iconSize: iconSize,
      ),
    );
  }
}

/// Private container for close button visuals
/// OOP: Separates visual from gesture logic
class _CloseButtonContainer extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;

  const _CloseButtonContainer({
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
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.close,
          size: iconSize ?? 3.sp,
          color: iconColor ?? Colors.white,
        ),
      ),
    );
  }
}

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
    // When height is explicit, use zero padding so SizedBox controls the height
    final effectivePadding = height != null
        ? EdgeInsets.symmetric(horizontal: 24)
        : padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14);

    return _ButtonWrapper(
      width: width,
      height: height,
      onPressed: _handlePress,
      borderRadius: borderRadius ?? 8,
      child: _ButtonContent(
        backgroundColor: _getBackgroundColor(),
        borderRadius: borderRadius ?? 8,
        padding: effectivePadding,
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
/// Encapsulates width, height, and gesture handling with circle fade animation
class _ButtonWrapper extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final double? borderRadius;
  final Widget child;

  const _ButtonWrapper({
    required this.width,
    required this.height,
    required this.onPressed,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return CircleFadeAnimation(
      onPressed: onPressed,
      borderRadius: BorderRadius.circular((borderRadius ?? 8).r),
      child: SizedBox(
        width: width != null ? width!.w : double.infinity,
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
      width: double.infinity,
      padding: padding,
      alignment: Alignment.center,
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
            width: 24.sp,
            height: 24.sp,
            child: LoadingAnimationWidget.progressiveDots(
              color: Colors.white,
              size: 24.sp,
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
        height: 1.2,
      ),
    );
  }
}