import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/contact_support_controller/contact_support_controller.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/animated_text.dart';
import '../../../utils/app_fonts.dart';

/// Contact Support Screen - Allows users to send support messages
/// Follows OOP principles with composition and encapsulation
class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(ContactSupportController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // App Bar
              _AppBar(controller: controller),
              
              // Content
              Expanded(
                child: _ContactContent(controller: controller),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Private widget for app bar
/// Encapsulates header with back button and title
class _AppBar extends StatelessWidget {
  final ContactSupportController controller;

  const _AppBar({required this.controller});

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
            onPressed: () => controller.navigateBack(context),
          ),
          
          SizedBox(width: 40.w),
          
          // Title
          Expanded(
            child: Text(
              'Contact Support',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.22),
            ),
          ),
          
          SizedBox(width: 64.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Private widget for contact content
/// Encapsulates scrollable form content
class _ContactContent extends StatelessWidget {
  final ContactSupportController controller;

  const _ContactContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 26.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          
          // Description Text
          _DescriptionText(),
          
          SizedBox(height: 32.h),
          
          // Subject Field
          _SubjectField(controller: controller),
          
          SizedBox(height: 24.h),
          
          // Email Field
          _EmailField(controller: controller),
          
          SizedBox(height: 24.h),
          
          // Message Field
          _MessageField(controller: controller),
          
          SizedBox(height: 32.h),
          
          // Send Button
          _SendButton(controller: controller),
          
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

/// Private widget for description text
/// Encapsulates introductory message with animation
class _DescriptionText extends StatelessWidget {
  const _DescriptionText();

  @override
  Widget build(BuildContext context) {
    return AnimatedTextSlide(
      text: 'If something doesn\'t feel right or you need assistance, you can reach out here. Share what\'s on your mind, and we\'ll respond as soon as we can.',
      style: AppFonts.poppinsRegular(
        fontSize: 14.sp,
        color: const Color(0xFF6B7280),
      ).copyWith(height: 1.57),
      textAlign: TextAlign.left,
      duration: const Duration(milliseconds: 600),
      delay: const Duration(milliseconds: 100),
      beginOffset: const Offset(0, 0.3),
    );
  }
}

/// Private widget for subject field
/// Encapsulates subject input with label
class _SubjectField extends StatelessWidget {
  final ContactSupportController controller;

  const _SubjectField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FormFieldContainer(
      label: 'Subject',
      child: _SubjectInput(controller: controller),
    );
  }
}

/// Private widget for subject input
/// Encapsulates the actual text input field
class _SubjectInput extends StatelessWidget {
  final ContactSupportController controller;

  const _SubjectInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.subjectController,
      focusNode: controller.subjectFocusNode,
      style: AppFonts.poppinsRegular(
        fontSize: 14.sp,
        color: const Color(0xFF0F0F0F),
      ).copyWith(height: 1.29),
      decoration: InputDecoration(
        hintText: 'Short title of your issue',
        hintStyle: AppFonts.poppinsRegular(
          fontSize: 14.sp,
          color: const Color(0xFF9DA4AE),
        ).copyWith(height: 1.29),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        controller.emailFocusNode.requestFocus();
      },
    );
  }
}

/// Private widget for email field
/// Encapsulates email input with label
class _EmailField extends StatelessWidget {
  final ContactSupportController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FormFieldContainer(
      label: 'Email Address',
      child: _EmailInput(controller: controller),
    );
  }
}

/// Private widget for email input
/// Encapsulates the actual email text input field
class _EmailInput extends StatelessWidget {
  final ContactSupportController controller;

  const _EmailInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.emailController,
      focusNode: controller.emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      style: AppFonts.poppinsRegular(
        fontSize: 14.sp,
        color: const Color(0xFF0F0F0F),
      ).copyWith(height: 1.29),
      decoration: InputDecoration(
        hintText: 'Write your email',
        hintStyle: AppFonts.poppinsRegular(
          fontSize: 14.sp,
          color: const Color(0xFF9DA4AE),
        ).copyWith(height: 1.29),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        controller.messageFocusNode.requestFocus();
      },
    );
  }
}

/// Private widget for message field
/// Encapsulates message input with label
class _MessageField extends StatelessWidget {
  final ContactSupportController controller;

  const _MessageField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _FormFieldContainer(
      label: 'Message',
      child: _MessageInput(controller: controller),
      isExpanded: true,
    );
  }
}

/// Private widget for message input
/// Encapsulates the actual message text input field
class _MessageInput extends StatelessWidget {
  final ContactSupportController controller;

  const _MessageInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller.messageController,
      focusNode: controller.messageFocusNode,
      maxLines: 6,
      style: AppFonts.poppinsRegular(
        fontSize: 14.sp,
        color: const Color(0xFF0F0F0F),
      ).copyWith(height: 1.29),
      decoration: InputDecoration(
        hintText: 'Please explain what happened...',
        hintStyle: AppFonts.poppinsRegular(
          fontSize: 14.sp,
          color: const Color(0xFF9DA4AE),
        ).copyWith(height: 1.29),
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      textInputAction: TextInputAction.done,
    );
  }
}

/// Private widget for form field container
/// Encapsulates the field wrapper with label and styling
class _FormFieldContainer extends StatelessWidget {
  final String label;
  final Widget child;
  final bool isExpanded;

  const _FormFieldContainer({
    required this.label,
    required this.child,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFEFF6FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: AppFonts.poppinsSemiBold(
              fontSize: 14.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.29),
          ),
          
          SizedBox(height: 8.h),
          
          // Input Field
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: isExpanded ? 120.h : 40.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: isExpanded ? 12.h : 8.h,
            ),
            decoration: ShapeDecoration(
              color: const Color(0xFFBFDBFE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Private widget for send button
/// Encapsulates the submit button with loading state
class _SendButton extends StatelessWidget {
  final ContactSupportController controller;

  const _SendButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CustomButton(
      label: 'Send Message',
      onPressed: controller.isLoading
          ? null
          : () => controller.sendMessage(context),
      isLoading: controller.isLoading,
      backgroundColor: const Color(0xFF1F7CD5),
      textColor: Colors.white,
      fontSize: 16.sp,
      width: 350.w,
      height: 52.h,
    ));
  }
}
