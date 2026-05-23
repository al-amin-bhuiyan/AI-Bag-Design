import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/create_controller/create_controller.dart';
import '../../routes/app_path.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_nav_bar_widgets.dart';

/// CreateScreen - Main creation screen for bag designs
/// Follows OOP principles with clean separation of UI and business logic
class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                
                // Page Title
                _PageTitle(),
                
                SizedBox(height: 55.h),
                
                // Bag Type Options
                const _BagTypeOptions(),
                
                SizedBox(height: 50.h),
                
                // Subtitle
                const _Subtitle(),
                
                SizedBox(height: 34.h),
                
                // Creation Options
                const _CreationOptions(),
                
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0,
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }

  /// Handles navigation bar tap events
  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Create - Already on Create, do nothing
        break;
      case 1:
        // Collections
        context.go(AppPath.collection);
        break;
      case 2:
        // Your Design
        context.go(AppPath.yourdesign);
        break;
      case 3:
        // Profile
        context.go(AppPath.profile);
        break;
    }
  }
}

/// Page title widget
class _PageTitle extends StatelessWidget {
  const _PageTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Create',
      textAlign: TextAlign.center,
      style: AppFonts.poppinsSemiBold(
        fontSize: 18.sp,
        color: const Color(0xFF0F0F0F),
      ).copyWith(height: 1.22),
    );
  }
}

/// Bag type options (Full Graphic and Label)
class _BagTypeOptions extends StatelessWidget {
  const _BagTypeOptions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Full Graphic Bag
        Obx(() => _BagTypeCard(
          image: CustomAssets.createYourFullGraphicsBag,
          title: 'Create Graphics',
          isSelected: controller.isFullGraphicSelected,
          onTap: () => controller.createFullGraphicBag(),
        )),
        
        SizedBox(width: 12.w),
        
        // Label Bag
        Obx(() => _BagTypeCard(
          image: CustomAssets.createLabelBag,
          title: 'Create Label',
          isSelected: controller.isLabelSelected,
          onTap: () => controller.createLabelBag(),
        )),
      ],
    );
  }
}

/// Individual bag type card with scale animation
class _BagTypeCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _BagTypeCard({
    required this.image,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: isSelected ? 2.9 : 0.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          // Scale up when selected (1.0 to 1.08)
          final scale = 1.0 + (value * 0.08);
          final shadowSpread = (value * 4.0).clamp(0.0, 4.0);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 163.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Bag Image
                  Container(
                    width: 163.w,
                    height: 300.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),

                      boxShadow: [
                        // BoxShadow(
                        //   color: Colors.transparent.withValues(alpha: 0.08),
                        //   blurRadius: 2,
                        //   offset: const Offset(0, 4),
                        // ),
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: (0.1* value).clamp(0.0, 0.1)),
                            blurRadius: (90 * value).clamp(0.0, 50.0),
                            spreadRadius: (shadowSpread * 0.5).clamp(0.0, 1.0),
                            offset: Offset(0, (8 * value).clamp(0.0, 8.0)),
                          ),
                        if (isSelected)
                          BoxShadow(
                            color: Colors.transparent.withValues(alpha: (0.1 * value).clamp(0.0, 0.1)),
                            blurRadius: (90 * value).clamp(0.0, 50.0),
                            spreadRadius: (shadowSpread * 0.5).clamp(0.0, 1.0),
                            offset: Offset(0, (8 * value).clamp(0.0, 8.0)),
                          ),
                      ],
                    ),
                    child: Image.asset(
                      image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppFonts.interSemiBold(
                      fontSize: 22.sp,
                      color: const Color(0xFF0F0F0F),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Subtitle widget
class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 281.w,
      child: Text(
        'Design your custom\nbag in seconds.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontFamily: 'Archivo',
          fontWeight: FontWeight.w600,
          height: 1.17,
        ),
      ),
    );
  }
}

/// Creation options (Upload and Generate AI)
class _CreationOptions extends StatelessWidget {
  const _CreationOptions();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Upload Option
        Expanded(
          child: Obx(() => _CreationOptionCard(
            image: CustomAssets.uploadLogo,
            title: 'Upload Image/Logo',
            subtitle: 'Add your logo or\nCompleted Design',
            backgroundColor: const Color(0xFFE5E5E5),
            isAnimating: controller.isUploadAnimating,
            onTap: () => controller.onUploadTap(context),
          )),
        ),
        
        SizedBox(width: 8.w),
        
        // Generate AI Option
        Expanded(
          child: Obx(() => _CreationOptionCard(
            image: CustomAssets.generateWithAi,
            title: 'Generate with AI',
            subtitle: 'Generate a label with\nartificial intelligence',
            backgroundColor: const Color(0xFFE6EEFF),
            isAnimating: controller.isGenerateAnimating,
            onTap: () => controller.onGenerateAITap(context),
          )),
        ),
      ],
    );
  }
}

/// Individual creation option card with animation
class _CreationOptionCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final bool isAnimating;
  final VoidCallback onTap;

  const _CreationOptionCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.isAnimating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: isAnimating ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          // Calculate animation values
          final scale = 1.0 - (value * 0.08); // Scale down slightly
          final rotateAngle = value * 0.05; // Slight rotation
          final borderWidth = (value * 3.0).clamp(0.0, 3.0); // Border grows (clamped to prevent negative)
          final shadowSpread = (value * 8.0).clamp(0.0, 8.0); // Shadow expands (clamped)
          
          return Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotateAngle,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(
                      color: Color.lerp(
                        Colors.transparent,
                        AppColors.primary,
                        value,
                      )!,
                      width: borderWidth,
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: (0.4 * value).clamp(0.0, 0.4)),
                      blurRadius: (16 * value).clamp(0.0, 16.0),
                      spreadRadius: shadowSpread,
                      offset: Offset(0, (4 * value).clamp(0.0, 4.0)),
                    ),
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: (0.2 * value).clamp(0.0, 0.2)),
                      blurRadius: (24 * value).clamp(0.0, 24.0),
                      spreadRadius: (shadowSpread * 1.5).clamp(0.0, 12.0),
                      offset: Offset(0, (8 * value).clamp(0.0, 8.0)),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon with bounce animation
                    Transform.scale(
                      scale: 1.0 + (value * 0.05),
                      child: Transform.rotate(
                        angle: -rotateAngle * 2,
                        child: Container(
                          width: 60.w,
                          height: 60.h,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(),
                          child: Image.asset(
                            image,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Title with slide animation
                    Transform.translate(
                      offset: Offset(0, -2 * value),
                      child: Opacity(
                        opacity: (1.0 - (value * 0.2)).clamp(0.0, 1.0),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF0F0F0F),
                            fontSize: 15.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            height: 1.47,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // Subtitle
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.60),
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}