import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jeebz_bag_design_app/utils/app_colors.dart';

import '../../controllers/sign_up_controller/sign_up_controller.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../utils/app_fonts.dart';

/// SignUpScreen - Registration screen with email/password and social auth
/// Follows OOP principles with composition and encapsulation
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SignUpController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: _SignUpContent(controller: controller),
    );
  }
}

/// Private widget for sign up screen content
class _SignUpContent extends StatelessWidget {
  final SignUpController controller;

  const _SignUpContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Column(
                children: [
                  SizedBox(height: 44.h),
                  _AppBar(),
                  SizedBox(height: 43.h),
                  _RegistrationForm(controller: controller),
                  SizedBox(height: 32.h),
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
        'Register',
        textAlign: TextAlign.center,
        style: AppFonts.poppinsSemiBold(
          fontSize: 18.sp,
          color: Colors.black,
        ).copyWith(height: 1.22),
      ),
    );
  }
}

/// Main registration form container
class _RegistrationForm extends StatelessWidget {
  final SignUpController controller;

  const _RegistrationForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      child: Column(
        mainAxisAlignment:  MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _HeaderSection(),
          
          SizedBox(height: 32.h),
          
          // Input fields section
          _InputFieldsSection(controller: controller),
          
          SizedBox(height: 32.h),
          
          // Actions section
          _ActionsSection(controller: controller),
          
          SizedBox(height: 32.h),
          
          // Sign in prompt
          _SignInPrompt(controller: controller),
        ],
      ),
    );
  }
}

/// Header section with title and subtitle
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Register Account',
          style: AppFonts.poppinsSemiBold(
            fontSize: 20.sp,
            color: const Color(0xFF1F7CD5),
          ).copyWith(height: 1.30),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in with your email and password\nor social media to continue',
          style: AppFonts.poppinsRegular(
            fontSize: 14.sp,
            color: const Color(0xFF9DA4AE),
          ).copyWith(height: 1.29),
        ),
      ],
    );
  }
}

/// Input fields section
class _InputFieldsSection extends StatelessWidget {
  final SignUpController controller;

  const _InputFieldsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name field
        CustomTextField(
          label: 'Full Name',
          hintText: 'Your Name',
          controller: controller.fullNameController,
          validator: controller.validateFullName,
        ),
        
        SizedBox(height: 24.h),
        
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
        
        SizedBox(height: 24.h),
        
        // Confirm Password field
        Obx(() => CustomTextField(
          label: 'Confirm Password',
          hintText: '••••••••',
          controller: controller.confirmPasswordController,
          obscureText: controller.obscureConfirmPassword,
          showPasswordToggle: true,
          validator: controller.validateConfirmPassword,
        )),
        
        SizedBox(height: 16.h),
        
        // Terms and privacy checkbox
        _TermsCheckbox(controller: controller),
      ],
    );
  }
}

/// Terms and privacy checkbox
class _TermsCheckbox extends StatelessWidget {
  final SignUpController controller;

  const _TermsCheckbox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.toggleAgreeToTerms,
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.agreeToTerms 
                    ? AppColors.textPrimary
                    : const Color(0xFFD2D6DB),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
              color: controller.agreeToTerms 
                  ? AppColors.textPrimary
                  : Colors.transparent,
            ),
            child: controller.agreeToTerms
                ? Icon(
                    Icons.check,
                    size: 12.sp,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.showTermsAndPrivacy(context),
              child: Text(
                'Agree with terms and privacy',
                style: AppFonts.poppinsSemiBold(
                  fontSize: 14.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.29),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

/// Actions section with sign up button and social auth
class _ActionsSection extends StatelessWidget {
  final SignUpController controller;

  const _ActionsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sign up button
        Obx(() => CustomButton(
          label: 'Sign up',
          backgroundColor: const Color(0xFF1F7CD5),
          textColor: Colors.white,
          fontSize: 16,
          onPressed: controller.isLoading ? null : () => controller.signUp(context),
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
        _SocialAuthButtons(controller: controller),
      ],
    );
  }
}

/// Social authentication buttons (Apple and Google)
class _SocialAuthButtons extends StatelessWidget {
  final SignUpController controller;

  const _SocialAuthButtons({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Apple sign up
        _SocialAuthButton(
          icon: CustomAssets.apple,
          onTap: controller.signUpWithApple,
        ),
        
        SizedBox(width: 16.w),
        
        // Google sign up
        _SocialAuthButton(
          icon: CustomAssets.google,
          onTap: controller.signUpWithGoogle,
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
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
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

/// Sign in prompt at bottom
class _SignInPrompt extends StatelessWidget {
  final SignUpController controller;

  const _SignInPrompt({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.navigateToSignIn(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account? ',
            style: AppFonts.poppinsRegular(
              fontSize: 16.sp,
              color: const Color(0xFF1F7CD5),
            ).copyWith(height: 1.38),
          ),
          Text(
            'Sign in',
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
