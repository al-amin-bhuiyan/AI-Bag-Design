import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/reset_password_controller/reset_password_controller.dart';
import '../../routes/app_path.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';

/// SetNewPasswordScreen - Screen for setting a new password after OTP verification
/// Uses reset_token received from /reset-password-otp/ endpoint
/// Calls POST /accounts/user/set-new-password/
/// Follows 100% OOP: composition and encapsulation
class SetNewPasswordScreen extends StatefulWidget {
  final String? resetToken;

  const SetNewPasswordScreen({super.key, this.resetToken});

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  late final ResetPasswordController _controller;
  Worker? _successWorker;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ResetPasswordController());

    if (widget.resetToken != null && widget.resetToken!.isNotEmpty) {
      _controller.setResetToken(widget.resetToken!);
    }

    // Register ever() once in initState — safe, no duplicates
    _successWorker = ever(_controller.isSuccess, (bool success) {
      if (success && mounted) {
        // GoRouter now has /set-new-password registered → context.go works
        context.go(AppPath.resetSuccess);
      }
    });
  }

  @override
  void dispose() {
    _successWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    _PasswordField(
                      label: 'New Password',
                      controller: _controller.newPasswordController,
                      obscureText: _controller.newPasswordObscure,
                      onToggleVisibility: _controller.toggleNewPasswordVisibility,
                    ),
                    SizedBox(height: 20.h),
                    _PasswordField(
                      label: 'Confirm Password',
                      controller: _controller.confirmPasswordController,
                      obscureText: _controller.confirmPasswordObscure,
                      onToggleVisibility: _controller.toggleConfirmPasswordVisibility,
                    ),
                    SizedBox(height: 40.h),
                    Obx(() => CustomButton(
                          label: 'Reset Password',
                          onPressed: _controller.isLoading.value
                              ? null
                              : () => _controller.resetPassword(),
                          isLoading: _controller.isLoading.value,
                          backgroundColor: const Color(0xFF1F7CD5),
                          textColor: Colors.white,
                          height: 54.h,
                        )),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App Bar
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 8.h,
        left: 26.w,
        right: 26.w,
        bottom: 24.h,
      ),
      child: Row(
        children: [
          CustomBackButton(onPressed: () => context.pop()),
          Expanded(
            child: Center(
              child: Text(
                'Set New Password',
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.11),
              ),
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }
}

/// Password Field — reusable floating label password input
class _PasswordField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final RxBool obscureText;
  final VoidCallback onToggleVisibility;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Obx(() => Container(
              width: double.infinity,
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: _isFocused ? 2 : 1,
                    color: _isFocused
                        ? const Color(0xFF1F7CD5)
                        : const Color(0xFFD0D5DB),
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: widget.controller,
                      obscureText: widget.obscureText.value,
                      keyboardType: TextInputType.visiblePassword,
                      style: AppFonts.interRegular(
                        fontSize: 14.sp,
                        color: const Color(0xFF0F0F0F),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '••••••••',
                        hintStyle: AppFonts.interRegular(
                          fontSize: 14.sp,
                          color: const Color(0xFF9DA4AE),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: widget.onToggleVisibility,
                    child: Icon(
                      widget.obscureText.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color(0xFF9CA3AF),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            )),
        // Floating label
        Positioned(
          left: 12.w,
          top: -10.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              widget.label,
              style: AppFonts.interMedium(
                fontSize: 12.sp,
                color: _isFocused
                    ? const Color(0xFF1F7CD5)
                    : const Color(0xFF0F0F0F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
