import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:jeebz_bag_design_app/utils/app_colors.dart';
import '../../controllers/forgot_password_controller/forgot_password_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../utils/app_fonts.dart';

/// ForgotPasswordScreen - Password recovery screen
/// Follows OOP principles with composition and encapsulation
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(ForgotPasswordController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: _ForgotPasswordContent(controller: controller),
    );
  }
}

/// Private widget for forgot password screen content
class _ForgotPasswordContent extends StatelessWidget {
  final ForgotPasswordController controller;

  const _ForgotPasswordContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          // Status Bar
        //  _StatusBar(),
          // Bottom Navigation Bar
          _BottomNavigationBar(),
          // Main Content
          Positioned(
            left: 26.w,
            top: 131.h,
            child: _MainContent(controller: controller),
          ),
          // App Bar
          _AppBar(controller: controller),
        ],
      ),
    );
  }
}

/// Status bar widget
class _StatusBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 402.w,
        padding: EdgeInsets.only(
          left: 26.w,
          right: 26.w,
          bottom: 14.h,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 30.h,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      // Time indicator
                      Container(
                        width: 54.w,
                        height: 21.h,
                        alignment: Alignment.center,
                        child: Text(
                          '9:41',
                          style: AppFonts.poppinsSemiBold(
                            fontSize: 15.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 227.w),
                      // Status icons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Signal icon
                          Icon(Icons.signal_cellular_alt, size: 14.sp),
                          SizedBox(width: 4.w),
                          // WiFi icon
                          Icon(Icons.wifi, size: 14.sp),
                          SizedBox(width: 4.w),
                          // Battery icon
                          Icon(Icons.battery_full, size: 14.sp),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
  final ForgotPasswordController controller;

  const _MainContent({required this.controller});

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
          _RecoveryMethodSection(controller: controller),
          SizedBox(height: 40.h),
          _ContinueButton(controller: controller),
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

/// Recovery method section with email option
class _RecoveryMethodSection extends StatelessWidget {
  final ForgotPasswordController controller;

  const _RecoveryMethodSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => _EmailRecoveryOption(
                controller: controller,
                isSelected: controller.isEmailSelected,
                maskedEmail: controller.maskedEmail,
              )),
        ],
      ),
    );
  }
}

/// Email recovery option widget
class _EmailRecoveryOption extends StatelessWidget {
  final ForgotPasswordController controller;
  final bool isSelected;
  final String maskedEmail;

  const _EmailRecoveryOption({
    required this.controller,
    required this.isSelected,
    required this.maskedEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.toggleEmailSelection(),
      child: Container(
        width: double.infinity,
        height: 76.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected ? const Color(0xFF1F7CD5) : const Color(0xFFE0E0E0),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Email icon container
            Container(
              width: 44.w,
              height: 44.h,
              padding: EdgeInsets.all(8.w),
              decoration: ShapeDecoration(
                color: const Color(0xFFF0F6FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31.r),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  size: 24.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Email details
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Via email',
                    style: AppFonts.poppinsRegular(
                      fontSize: 12.sp,
                      color: const Color(0xFF9DA4AE),
                    ).copyWith(height: 1.50),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    maskedEmail,
                    style: AppFonts.poppinsSemiBold(
                      fontSize: 14.sp,
                      color: const Color(0xFF0F0F0F),
                    ).copyWith(height: 1.29),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App bar with back button and title
class _AppBar extends StatelessWidget {
  final ForgotPasswordController controller;

  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
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
  final ForgotPasswordController controller;

  const _ContinueButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: controller.isLoading
              ? null
              : () => controller.handleContinue(context),
          child: Container(
            width: 350.w,
            height: 52.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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