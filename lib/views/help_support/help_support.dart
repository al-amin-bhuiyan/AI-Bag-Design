import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/help_support_controller/help_support_controller.dart';
import '../../widgets/custom_back_button.dart';
import '../../utils/app_fonts.dart';

/// Help & Support Screen - Shows various help and support options
/// Follows OOP principles with composition and encapsulation
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(HelpSupportController());

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
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    
                    // Help Options List
                    _HelpOption(
                      title: 'FAQs / Help Center',
                      onTap: () => controller.navigateToFAQs(context),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _HelpOption(
                      title: 'Contact Support',
                      onTap: () => controller.navigateToContactSupport(context),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _HelpOption(
                      title: 'Privacy Policy + Terms',
                      onTap: () => controller.navigateToPrivacyPolicy(context),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _HelpOption(
                      title: 'Terms & Conditions',
                      onTap: () => controller.navigateToTermsConditions(context),
                    ),
                    
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
          
          SizedBox(width: 55.w),
          
          // Title
          Expanded(
            child: Text(
              'Help & Support',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.11),
            ),
          ),
          
          SizedBox(width: 79.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Help Option Item Widget
class _HelpOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _HelpOption({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350.w,
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: const Color(0xFFF3F7FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: [
            BoxShadow(
              color: const Color(0x19000000),
              blurRadius: 2,
              offset: const Offset(0, 1),
              spreadRadius: -1,
            ),
            BoxShadow(
              color: const Color(0x19000000),
              blurRadius: 3,
              offset: const Offset(0, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title with bullet point
            Row(
              children: [
                // Bullet point
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F0F0F),
                    shape: BoxShape.circle,
                  ),
                ),
                
                SizedBox(width: 8.w),
                
                // Title
                Text(
                  title,
                  style: AppFonts.interRegular(
                    fontSize: 14.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.20),
                ),
              ],
            ),
            
            // Arrow Icon
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: const Color(0xFF0F0F0F),
            ),
          ],
        ),
      ),
    );
  }
}
