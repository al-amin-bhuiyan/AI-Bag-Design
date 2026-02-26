import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/reset_success_controller/reset_success_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_assets.dart';
import '../../utils/app_fonts.dart';

/// ResetSuccessScreen - Password reset success confirmation screen
/// Follows OOP principles with composition and encapsulation
class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(ResetSuccessController());

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _ResetSuccessContent(controller: controller),
    );
  }
}

/// Private widget for reset success screen content
class _ResetSuccessContent extends StatelessWidget {
  final ResetSuccessController controller;

  const _ResetSuccessContent({required this.controller});

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
          // Main Content with Button
          Positioned.fill(
            top: 44.h,
            bottom: 40.h,
            child: Column(
              children: [
                // App Bar
                _AppBar(controller: controller),
                // Main Content - Centered
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 26.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _SuccessIcon(),
                          SizedBox(height: 48.h),
                          _SuccessMessage(),
                        ],
                      ),
                    ),
                  ),
                ),
                // Continue Button - Fixed at bottom
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: _ContinueButton(controller: controller),
                  ),
                ),
                SizedBox(height: 35.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// App Bar with back button and title
class _AppBar extends StatelessWidget {
  final ResetSuccessController controller;

  const _AppBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            size: 24.w,
            iconSize: 14.sp,
            onPressed: () => controller.navigateBack(context),
          ),
          SizedBox(width: 79.w),
          // Title
          SizedBox(
            width: 144.w,
            child: Text(
              'Reset Success',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: Colors.black,
              ).copyWith(height: 1.11),
            ),
          ),
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

/// Success icon with circular background
class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 208.w,
      height: 208.h,
      child: Image.asset(
        CustomAssets.successImage,
        width: 208.w,
        height: 208.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Success message section
class _SuccessMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Success!',
            textAlign: TextAlign.center,
            style: AppFonts.poppinsSemiBold(
              fontSize: 20.sp,
              color: const Color(0xFF1F2A37),
            ).copyWith(height: 1.30),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 290.w,
            child: Text(
              'You password has been changed. Please log in again with a new password.',
              textAlign: TextAlign.center,
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

/// Continue button
class _ContinueButton extends StatelessWidget {
  final ResetSuccessController controller;

  const _ContinueButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomButton(
          label: 'Continue',
          onPressed: () => controller.handleContinue(context),
          isLoading: controller.isLoading,
          isDisabled: controller.isLoading,
          width: double.infinity,
          height: 52.h,
        ));
  }
}
