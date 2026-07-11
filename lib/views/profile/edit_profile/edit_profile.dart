import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/edit_profile_controller/edit_profile_controller.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_assets.dart';
import '../../../widgets/custom_back_button.dart';

/// Edit Profile Screen - Allows users to edit their profile information
/// Follows OOP principles with widget composition and separation of concerns
class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Column(
                children: [
                  SizedBox(height: 76.h), // Space for app bar
                  
                  // Profile Photo Section
                  const _ProfilePhotoSection(),
                  
                  SizedBox(height: 46.h),
                  
                  // Form Fields
                  const _ProfileForm(),
                  
                  SizedBox(height: 40.h), // Bottom padding
                ],
              ),
            ),
          ),
          
          // App Bar
          _AppBar(),
        ],
      ),
    );
  }
}

/// App Bar Widget
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 44.h,
      right: 0,
      child: Container(
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
              onPressed: () =>context.pop(),
            ),
            
            Spacer(),
            
            // Title
            Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.22),
            ),
            
            Spacer(),
            
            // Placeholder for symmetry
            SizedBox(width: 24.w),
          ],
        ),
      ),
    );
  }
}

/// Profile Photo Section Widget
class _ProfilePhotoSection extends StatelessWidget {
  const _ProfilePhotoSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Column(
      children: [
        // Profile Image — tappable avatar
        // All observables read directly inside Obx builder scope
        Obx(() {
          final localPath = controller.profileImagePath.value;
          final networkUrl = controller.networkImageUrl.value;

          Widget imageChild;

          // Priority 1 — local file selected by user
          if (localPath.isNotEmpty) {
            imageChild = Image.file(
              File(localPath),
              fit: BoxFit.cover,
            );
          }
          // Priority 2 — network image from API
          else if (networkUrl.isNotEmpty) {
            imageChild = Image.network(
              networkUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF2F4F6),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF1F7CD5),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Image.asset(
                CustomAssets.personimage,
                fit: BoxFit.cover,
              ),
            );
          }
          // Priority 3 — default asset placeholder
          else {
            imageChild = Image.asset(
              CustomAssets.personimage,
              fit: BoxFit.cover,
            );
          }

          return GestureDetector(
            onTap: () => controller.showPhotoOptions(context),
            child: Container(
              width: 70.w,
              height: 70.h,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFF2F4F6)),
                  borderRadius: BorderRadius.circular(35.r),
                ),
              ),
              child: imageChild,
            ),
          );
        }),

        SizedBox(height: 12.h),

        // Edit Photo Button
        GestureDetector(
          onTap: () => controller.showPhotoOptions(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: ShapeDecoration(
              color: const Color(0xFFF3F7FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            child: Text(
              'Edit Photo',
              style: AppFonts.interRegular(
                fontSize: 14.sp,
                color: const Color(0xFF697282),
              ).copyWith(height: 1.43),
            ),
          ),
        ),
      ],
    );
  }
}

/// Profile Form Widget
class _ProfileForm extends StatelessWidget {
  const _ProfileForm();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Field
        const _NameField(),
        
        SizedBox(height: 24.h),
        
        // Email Field  
        const _EmailField(),
        
        SizedBox(height: 24.h),
        
        // Language Field
        const _LanguageField(),
        
        SizedBox(height: 24.h),
        
        // Save Change Button
        const _SaveChangeButton(),
        
        SizedBox(height: 24.h),
        
        // Connected Social Accounts
        const _SocialAccountsSection(),
      ],
    );
  }
}

/// Name Field Widget
class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Name',
          style: AppFonts.poppinsSemiBold(
            fontSize: 16.sp,
            color: const Color(0xFF101727),
          ).copyWith(height: 1.50),
        ),
        
        SizedBox(height: 8.h),
        
        // Text Field (always editable)
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFD0D5DB),
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.nameController,
                style: AppFonts.interRegular(
                  fontSize: 16.sp,
                  color: const Color(0xFF101727),
                ).copyWith(height: 1.50),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Email Field Widget
class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Email address',
          style: AppFonts.poppinsSemiBold(
            fontSize: 16.sp,
            color: const Color(0xFF101727),
          ).copyWith(height: 1.50),
        ),
        
        SizedBox(height: 8.h),
        
        // Email Field (always editable)
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              width: double.infinity,
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFD0D5DB),
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller.emailController,
                style: AppFonts.interRegular(
                  fontSize: 16.sp,
                  color: const Color(0xFF101727),
                ).copyWith(height: 1.50),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Language Field Widget
class _LanguageField extends StatelessWidget {
  const _LanguageField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: const Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Language',
            style: AppFonts.poppinsSemiBold(
              fontSize: 16.sp,
              color: const Color(0xFF101727),
            ).copyWith(height: 1.50),
          ),
          
          SizedBox(height: 8.h),
          
          // Language Dropdown with blur shadow
          Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                width: double.infinity,
                height: 50.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFD0D5DB),
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedLanguage.value,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.sp,
                      color: const Color(0xFF101727),
                    ),
                    style: AppFonts.interRegular(
                      fontSize: 16.sp,
                      color: const Color(0xFF101727),
                    ).copyWith(height: 1.50),
                    items: controller.languages.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: controller.changeLanguage,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

/// Save Change Button Widget
class _SaveChangeButton extends StatelessWidget {
  const _SaveChangeButton();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Obx(() => GestureDetector(
      onTap: controller.isSaving.value
          ? null
          : () => controller.saveProfile(context),
      child: Container(
        width: 350.w,
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 9.h),
        decoration: ShapeDecoration(
          color: controller.isSaving.value
              ? const Color(0xFF1F7CD5).withValues(alpha: 0.6)
              : const Color(0xFF1F7CD5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isSaving.value)
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Text(
                'Save Change',
                textAlign: TextAlign.center,
                style: AppFonts.interMedium(
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

/// Social Accounts Section Widget
class _SocialAccountsSection extends StatelessWidget {
  const _SocialAccountsSection();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connected social accounts',
              style: AppFonts.poppinsSemiBold(
                fontSize: 16.sp,
                color: const Color(0xFF101727),
              ).copyWith(height: 1.50),
            ),
            
            SizedBox(height: 4.h),
            
            Text(
              'Services that you use to log in to Canva',
              style: AppFonts.interRegular(
                fontSize: 14.sp,
                color: const Color(0xFF697282),
              ).copyWith(height: 1.43),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // Google Account Card with blur shadow
        ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Container(
              width: double.infinity,
              height: 74.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFE5E7EB),
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x19000000),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Google Icon
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: const Color(0xFFF2F4F6),
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      shadows: [
                        BoxShadow(
                          color: const Color(0x19000000),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                          spreadRadius: -1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        CustomAssets.google,
                        width: 22.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Account Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Google',
                          style: TextStyle(
                            color: const Color(0xFF101727),
                            fontSize: 14.sp,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                          ),
                        ),
                        Text(
                          'Mohammad Shobuj',
                          style: AppFonts.interRegular(
                            fontSize: 12.sp,
                            color: const Color(0xFF697282),
                          ).copyWith(height: 1.33),
                        ),
                      ],
                    ),
                  ),
                  
                  // Disconnect Button
                  GestureDetector(
                    onTap: () => controller.disconnectSocialAccount(context, 'Google'),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFD0D5DB),
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Disconnect',
                        textAlign: TextAlign.center,
                        style: AppFonts.interMedium(
                          fontSize: 12.sp,
                          color: const Color(0xFF354152),
                        ).copyWith(height: 1.33),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}