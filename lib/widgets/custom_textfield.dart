import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_fonts.dart';

/// CustomTextField - A reusable text field widget following OOP principles
/// Encapsulates text field styling, behavior, and validation
class CustomTextField extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showPasswordToggle;
  final int? maxLines;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.showPasswordToggle = false,
    this.maxLines = 1,
    this.enabled = true,
  });

  /// Factory constructor for email field
  factory CustomTextField.email({
    Key? key,
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      key: key,
      label: label,
      hintText: 'Enter your email',
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      validator: validator,
      onChanged: onChanged,
    );
  }

  /// Factory constructor for password field
  factory CustomTextField.password({
    Key? key,
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      key: key,
      label: label,
      hintText: 'Enter your password',
      controller: controller,
      obscureText: true,
      showPasswordToggle: true,
      validator: validator,
      onChanged: onChanged,
    );
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = false;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  /// Handles focus change
  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  /// Toggles password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _TextFieldContainer(
      label: widget.label,
      isFocused: _isFocused,
      child: _TextFieldInput(
        focusNode: _focusNode,
        hintText: widget.hintText,
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.showPasswordToggle
            ? _PasswordToggleIcon(
                isObscured: _isObscured,
                onToggle: _togglePasswordVisibility,
              )
            : widget.suffixIcon,
      ),
    );
  }
}

/// Private container widget for text field with floating label
class _TextFieldContainer extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isFocused;

  const _TextFieldContainer({
    required this.label,
    required this.child,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: isFocused ? 2 : 1,
                color: isFocused ? const Color(0xFF1F7CD5) : const Color(0xFFD2D6DB),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: child,
        ),
        // Floating label
        Positioned(
          left: 25.w,
          top: -13.h,
          child: _FloatingLabel(label: label, isFocused: isFocused),
        ),
      ],
    );
  }
}

/// Private widget for floating label
class _FloatingLabel extends StatelessWidget {
  final String label;
  final bool isFocused;

  const _FloatingLabel({
    required this.label,
    required this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        label,
        style: AppFonts.poppinsSemiBold(
          fontSize: 12.sp,
          color: isFocused ? const Color(0xFF1F7CD5) : const Color(0xFF0F0F0F),
        ).copyWith(height: 1.50),
      ),
    );
  }
}

/// Private widget for text field input
class _TextFieldInput extends StatelessWidget {
  final FocusNode focusNode;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const _TextFieldInput({
    required this.focusNode,
    this.hintText,
    this.controller,
    required this.obscureText,
    this.keyboardType,
    this.onChanged,
    this.maxLines,
    required this.enabled,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          SizedBox(width: 8.w),
        ],
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            maxLines: maxLines,
            enabled: enabled,
            style: AppFonts.poppinsRegular(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.29),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: AppFonts.poppinsRegular(
                fontSize: 14.sp,
                color: const Color(0xFF9DA4AE),
              ).copyWith(height: 1.29),
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: 8.w),
          suffixIcon!,
        ],
      ],
    );
  }
}

/// Private widget for password toggle icon
class _PasswordToggleIcon extends StatelessWidget {
  final bool isObscured;
  final VoidCallback onToggle;

  const _PasswordToggleIcon({
    required this.isObscured,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Icon(
        isObscured ? Icons.visibility_off : Icons.visibility,
        color: const Color(0xFF9DA4AE),
        size: 20.sp,
      ),
    );
  }
}
