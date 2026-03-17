import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/change_password_controller/change_password_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';

/// ChangePasswordScreen - Screen for changing user password
/// Follows OOP principles with composition and encapsulation
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.find() — controller is registered in Binding via lazyPut(fenix: true)
    // Get.put() would create a new orphaned instance skipping onInit lifecycle
    final controller = Get.find<ChangePasswordController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      
                      // Current Password Field
                      _PasswordField(
                        label: 'Current Pass',
                        controller: controller.currentPasswordController,
                        obscureText: controller.currentPasswordObscure,
                        onToggleVisibility: controller.toggleCurrentPasswordVisibility,
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // New Password Field
                      _PasswordField(
                        label: 'New Password',
                        controller: controller.newPasswordController,
                        obscureText: controller.newPasswordObscure,
                        onToggleVisibility: controller.toggleNewPasswordVisibility,
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Confirm Password Field
                      _PasswordField(
                        label: 'Confirm Password',
                        controller: controller.confirmPasswordController,
                        obscureText: controller.confirmPasswordObscure,
                        onToggleVisibility: controller.toggleConfirmPasswordVisibility,
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Save Button
                      Obx(() => CustomButton(
                        label: 'Save',
                        onPressed: controller.isLoading.value 
                            ? null 
                            : () => controller.changePassword(),
                        isLoading: controller.isLoading.value,
                        backgroundColor: const Color(0xFF1F7CD5),
                        height: 54.h,
                        width: 350.w,
                      )),
                      
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App Bar Widget with back button and title
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
          // Back Button
          CustomBackButton(
            onPressed: () => context.pop(),
          ),
          
          Expanded(
            child: Center(
              child: Text(
                'Change Pass',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.11),
              ),
            ),
          ),
          
          SizedBox(width: 24.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Password Field Widget with label and toggle visibility
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
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Obx(() => Container(
          width: 350.w,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: _isFocused ? 2 : 1,
                color: _isFocused ? const Color(0xFF1F7CD5) : const Color(0xFFD0D5DB),
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
                  ).copyWith(height: 1.29),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '••••••••',
                    hintStyle: AppFonts.interRegular(
                      fontSize: 14.sp,
                      color: const Color(0xFF9DA4AE),
                    ).copyWith(height: 1.29),
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
                color: _isFocused ? const Color(0xFF1F7CD5) : const Color(0xFF0F0F0F),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
