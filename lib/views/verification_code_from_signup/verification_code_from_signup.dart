import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/verification_code_from_sign_up_controller/verification_code_from_sign_up_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';

/// VerificationCodeFromSignup - Email verification code entry screen after signup
/// Follows OOP principles with composition and encapsulation
class VerificationCodeFromSignup extends StatelessWidget {
  final String? email;

  const VerificationCodeFromSignup({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(VerificationCodeControllerfromSignup());

    // Set email from route parameter
    if (email != null && email!.isNotEmpty) {
      controller.setEmail(email!);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _VerificationCodeContent(controller: controller),
    );
  }
}

/// Private widget for verification code screen content
class _VerificationCodeContent extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _VerificationCodeContent({required this.controller});

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
            child: _MainContent(controller: controller),
          ),
          // App Bar
          _AppBar(controller: controller),
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
  final VerificationCodeControllerfromSignup controller;

  const _MainContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderSection(),
          SizedBox(height: 40.h),
          _OtpInputSection(controller: controller),
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
          _TitleSection(),
          SizedBox(height: 28.h),
          _OtpFieldsAndActions(),
        ],
      ),
    );
  }
}

/// Title section
class _TitleSection extends StatelessWidget {
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
            'Verify your Email',
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
              'Please enter 6 digit verification that have been sent to your email address',
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

/// OTP fields and actions section
class _OtpFieldsAndActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// OTP input section with fields, resend, and verify button
class _OtpInputSection extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _OtpInputSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _OtpFields(controller: controller),
          SizedBox(height: 16.h),
          _PasteCodeButton(controller: controller),
          SizedBox(height: 32.h),
          _ResendSection(controller: controller),
          SizedBox(height: 40.h),
          _VerifyButton(controller: controller),
        ],
      ),
    );
  }
}

/// OTP input fields row
class _OtpFields extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _OtpFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildOtpField(controller.otp1Controller, controller.otp1FocusNode, 1, controller.otp1, controller, context),
        SizedBox(width: 12.w),
        _buildOtpField(controller.otp2Controller, controller.otp2FocusNode, 2, controller.otp2, controller, context),
        SizedBox(width: 12.w),
        _buildOtpField(controller.otp3Controller, controller.otp3FocusNode, 3, controller.otp3, controller, context),
        SizedBox(width: 12.w),
        _buildOtpField(controller.otp4Controller, controller.otp4FocusNode, 4, controller.otp4, controller, context),
        SizedBox(width: 12.w),
        _buildOtpField(controller.otp5Controller, controller.otp5FocusNode, 5, controller.otp5, controller, context),
        SizedBox(width: 12.w),
        _buildOtpField(controller.otp6Controller, controller.otp6FocusNode, 6, controller.otp6, controller, context),
      ],
    );
  }

  /// Build individual OTP input field
  Widget _buildOtpField(
      TextEditingController textController,
      FocusNode focusNode,
      int index,
      RxString observableValue,
      VerificationCodeControllerfromSignup otpController,
      BuildContext context,
      ) {
    return Obx(() {
      final hasInput = observableValue.value.isNotEmpty;

      return Container(
        width: 48.w,
        height: 48.h,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: hasInput ? const Color(0xFF1F7CD5) : const Color(0xFFD2D6DB),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextFormField(
          controller: textController,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: AppFonts.poppinsBold(
            fontSize: 24.sp,
            color: Colors.black,
          ).copyWith(height: 2.10),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: (value) {
            if (value.length <= 1) {
              otpController.onOtpChanged(value, index, context);
            }
          },
        ),
      );
    });
  }
}

/// Paste Code button
class _PasteCodeButton extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _PasteCodeButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.handlePasteFromClipboard(context),
      child: Text(
        'Paste Code',
        style: AppFonts.poppinsSemiBold(
          fontSize: 14.sp,
          color: const Color(0xFF1F7CD5),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

/// Resend code section
class _ResendSection extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _ResendSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Don't receive code ?",
            style: AppFonts.poppinsRegular(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.29),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: controller.canResend ? () => controller.resendCode(context) : null,
            child: Text(
              controller.canResend
                  ? 'Resend code'
                  : 'Resend code (${controller.timerText})',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsRegular(
                fontSize: 14.sp,
                color: controller.canResend
                    ? const Color(0xFFF97066)
                    : const Color(0xFF9DA4AE),
              ).copyWith(height: 1.29),
            ),
          ),
        ],
      ),
    ));
  }
}

/// Verify button
class _VerifyButton extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

  const _VerifyButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CircleFadeAnimation(
      onPressed: controller.isLoading
          ? null
          : () => controller.verifyCode(context),
      borderRadius: BorderRadius.circular(8.r),
      splashColor: Colors.white,
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
                'Verify',
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

/// App bar with back button and title
class _AppBar extends StatelessWidget {
  final VerificationCodeControllerfromSignup controller;

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
            //  SizedBox(width: 69.w),
            // Title
            SizedBox(
              width: 144.w,
              child: Text(
                'Verification',
                textAlign: TextAlign.center,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 18.sp,
                  color: Colors.black,
                ).copyWith(height: 1.22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}