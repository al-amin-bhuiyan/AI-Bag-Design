import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/forgot_password_controller/forgot_password_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';

/// ForgotPasswordScreen - Password recovery screen
/// Follows OOP principles with composition and encapsulation
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const _ForgotPasswordContent(),
    );
  }
}

/// Private widget for forgot password screen content
class _ForgotPasswordContent extends StatelessWidget {
  const _ForgotPasswordContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Bottom Navigation Bar
          _BottomNavigationBar(),
          // Main Content
          Positioned(
            left: 26.w,
            top: 131.h,
            child: const _MainContent(),
          ),
          // App Bar
          const _AppBar(),
        ],
      ),
    );
  }
}

/// Bottom navigation bar widget
class _BottomNavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 834.h,
      child: Container(
        width: 402.w,
        height: 40.h,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            Positioned(
              left: 129.71.w,
              top: 24.25.h,
              child: Container(
                width: 143.65.w,
                height: 6.88.h,
                decoration: ShapeDecoration(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
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

/// Main content widget
class _MainContent extends StatelessWidget {
  const _MainContent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(),
          SizedBox(height: 32.h),
          const _RecoveryMethodSection(),
          SizedBox(height: 40.h),
          const _ContinueButton(),
        ],
      ),
    );
  }
}

/// Header section with title and subtitle
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forgot Password',
            textAlign: TextAlign.center,
            style: AppFonts.poppinsSemiBold(
              fontSize: 20.sp,
              color: const Color(0xFF1F7CD5),
            ).copyWith(height: 1.30),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 350.w,
            child: Text(
              'Select which contact details should we use to reset your password',
              style: AppFonts.poppinsRegular(
                fontSize: 14.sp,
                color: const Color(0xFF9DA4AE),
              ).copyWith(height: 1.29),
            ),
          ),
        ],
      ),
    );
  }
}

/// Recovery method section €” email input field
class _RecoveryMethodSection extends StatelessWidget {
  const _RecoveryMethodSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: AppFonts.poppinsMedium(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ),
          ),
          SizedBox(height: 8.h),
          const _EmailTextField(),
        ],
      ),
    );
  }
}

/// Email text field widget
class _EmailTextField extends StatelessWidget {
  const _EmailTextField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD2D6DB)),
          borderRadius: BorderRadius.circular(8.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        style: AppFonts.poppinsRegular(
          fontSize: 14.sp,
          color: const Color(0xFF0F0F0F),
        ),
        decoration: InputDecoration(
          hintText: 'Enter your email address',
          hintStyle: AppFonts.poppinsRegular(
            fontSize: 14.sp,
            color: const Color(0xFF9DA4AE),
          ),
          prefixIcon: Icon(
            Icons.mark_email_unread_outlined,
            size: 20.sp,
            color: const Color(0xFF9DA4AE),
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}

/// App bar with back button and title
class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    return Positioned(
      left: 0,
      top: 44.h,
      child: Container(
        width: 402.w,
        padding: EdgeInsets.only(
          top: 8.h,
          left: 26.w,
          right: 26.w,
          bottom: 16.h,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back button
            CustomBackButton(
              size: 35.w,
              iconSize: 24.sp,
              onPressed: () => controller.navigateBack(context),
            ),
            SizedBox(width: 69.w),
            // Title
            Text(
              'Forgot Password',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: Colors.black,
              ).copyWith(height: 1.22),
            ),
          ],
        ),
      ),
    );
  }
}

/// Continue button widget
class _ContinueButton extends StatelessWidget {
  const _ContinueButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();
    return Obx(() => CircleFadeAnimation(
          onPressed: controller.isLoading
              ? null
              : () => controller.handleContinue(context),
          borderRadius: BorderRadius.circular(8.r),
          splashColor: Colors.white,
          child: Container(
            width: 350.w,
            height: 52.h,
            decoration: ShapeDecoration(
              color: const Color(0xFF1F7CD5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (controller.isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else
                  Text(
                    'Continue',
                    style: AppFonts.poppinsRegular(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ).copyWith(height: 1.50),
                  ),
              ],
            ),
          ),
        ));
  }
}