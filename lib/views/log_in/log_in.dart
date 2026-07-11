import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jeebz_bag_design_app/utils/app_colors.dart';

import '../../controllers/log_in_controller/log_in_controller.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/app_fonts.dart';

/// LogInScreen - Main login screen with email/password and social auth
/// Follows OOP principles with composition and encapsulation
class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const _LogInContent(),
    );
  }
}

/// Private widget for login screen content
class _LogInContent extends StatelessWidget {
  const _LogInContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                children: [
                  SizedBox(height: 54.h),
                  _AppBar(),
                  SizedBox(height: 43.h),
                  const _LoginForm(),
                ],
              ),
            ),
          ),

          // Bottom navigation bar
          _BottomNavBar(),
        ],
      ),
    );
  }
}

/// App bar with title
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'log In',
        textAlign: TextAlign.center,
        style: AppFonts.poppinsSemiBold(
          fontSize: 18.sp,
          color: Colors.black,
        ).copyWith(height: 1.22),
      ),
    );
  }
}

/// Main login form container
class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _WelcomeSection(),
          
          SizedBox(height: 32.h),
          
          // Input fields section
          const _InputFieldsSection(),
          
          SizedBox(height: 32.h),
          
          // Actions section
          const _ActionsSection(),
          
          SizedBox(height: 32.h),
          
          // Sign up prompt
          const _SignUpPrompt(),
        ],
      ),
    );
  }
}

/// Welcome section with title and subtitle
class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    //  mainAxisAlignment:  MainAxisAlignment.start,
      children: [
        Text(
          'Welcome Back !',
          style: AppFonts.poppinsSemiBold(
            fontSize: 20.sp,
            color: const Color(0xFF1F7CD5),
          ).copyWith(height: 1.30),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in with your email and password \nor social media to continue',
          style: AppFonts.poppinsRegular(
            fontSize: 14.sp,
            color: const Color(0xFF9DA4AE),
          ).copyWith(height: 1.29),
        ),
      ],
    );
  }
}

/// Input fields section with email and password
class _InputFieldsSection extends StatelessWidget {
  const _InputFieldsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInController>();
    return Column(
      children: [
        // Email field
        CustomTextField.email(
          label: 'Email',
          controller: controller.emailController,
          validator: controller.validateEmail,
        ),
        
        SizedBox(height: 24.h),
        
        // Password field
        CustomTextField.password(
          label: 'Password',
          controller: controller.passwordController,
          validator: controller.validatePassword,
        ),
        
        SizedBox(height: 16.h),
        
        // Remember me and forgot password
        const _RememberMeRow(),
      ],
    );
  }
}

/// Remember me and forgot password row
class _RememberMeRow extends StatelessWidget {
  const _RememberMeRow();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me checkbox
        Obx(() => _RememberMeCheckbox(
          isChecked: controller.rememberMe,
          onChanged: () => controller.toggleRememberMe(),
        )),
        
        // Forgot password button
        _ForgotPasswordButton(
          onTap: () => controller.forgotPassword(context),
        ),
      ],
    );
  }
}

/// Remember me checkbox with label
class _RememberMeCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onChanged;

  const _RememberMeCheckbox({
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: isChecked ? AppColors.textPrimary : const Color(0xFFD2D6DB),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4.r),
              color: isChecked ? AppColors.textPrimary : Colors.transparent,
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    size: 12.sp,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Text(
            'Remember me',
            style: AppFonts.poppinsRegular(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.29),
          ),
        ],
      ),
    );
  }
}

/// Forgot password button
class _ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ForgotPasswordButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Forgot password ?',
        style: AppFonts.poppinsRegular(
          fontSize: 14.sp,
          color: const Color(0xFF0F0F0F),
        ).copyWith(height: 1.29),
      ),
    );
  }
}

/// Actions section with sign in button and social auth
class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInController>();
    return Column(
      children: [
        // Sign in button
        Obx(() => CustomButton(
          label: 'Sign in',
          backgroundColor: const Color(0xFF1F7CD5),
          textColor: Colors.white,
          fontSize: 16,
          onPressed: controller.isLoading ? null : () => controller.signIn(context),
          isLoading: controller.isLoading,
        )),
        
        SizedBox(height: 24.h),
        
        // Or divider
        Text(
          'Or',
          style: AppFonts.poppinsRegular(
            fontSize: 14.sp,
            color: const Color(0xFF1F7CD5),
          ).copyWith(height: 1.29),
        ),
        
        SizedBox(height: 24.h),
        
        // Social auth buttons
        const _SocialAuthButtons(),
      ],
    );
  }
}

/// Social authentication buttons (Apple and Google)
class _SocialAuthButtons extends StatelessWidget {
  const _SocialAuthButtons();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Apple sign in
        _SocialAuthButton(
          icon: CustomAssets.apple,
          onTap: controller.signInWithApple,
        ),
        
        SizedBox(width: 16.w),
        
        // Google sign in
        _SocialAuthButton(
          icon: CustomAssets.google,
          onTap: controller.signInWithGoogle,
        ),
      ],
    );
  }
}

/// Single social auth button
class _SocialAuthButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _SocialAuthButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46.w,
        height: 46.h,
        decoration: ShapeDecoration(
          color: const Color(0xFFE5E7EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
          ),
        ),
      ),
    );
  }
}

/// Sign up prompt at bottom
class _SignUpPrompt extends StatelessWidget {
  const _SignUpPrompt();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LogInController>();
    return GestureDetector(
      onTap: () => controller.navigateToSignUp(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have account? ",
            style: AppFonts.poppinsRegular(
              fontSize: 16.sp,
              color: const Color(0xFF1F7CD5),
            ).copyWith(height: 1.38),
          ),
          Text(
            'Sign up',
            style: AppFonts.poppinsSemiBold(
              fontSize: 16.sp,
              color: const Color(0xFF1F7CD5),
            ).copyWith(height: 1.38),
          ),
        ],
      ),
    );
  }
}

/// Bottom navigation bar indicator
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 834.h,
      child: Container(
        width: 402.w,
        height: 40.h,
        child: Center(
          child: Container(
            width: 144.w,
            height: 6.h,
            decoration: ShapeDecoration(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}