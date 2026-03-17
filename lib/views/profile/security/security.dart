import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/security_controller/security_controller.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_back_button.dart';

/// SecurityScreen - Change password and delete account options
/// Follows OOP principles with widget composition and separation of concerns
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.find() — controller is registered in Binding via lazyPut(fenix: true)
    final controller = Get.find<SecurityController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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

                        // Change Password
                        _SecurityOption(
                          title: 'Change Password',
                          onTap: () => controller.navigateToChangePassword(context),
                          isDestructive: false,
                        ),

                        SizedBox(height: 16.h),

                        // Delete Account
                        _SecurityOption(
                          title: 'Delete Account',
                          onTap: () => controller.showDeleteAccountDialog(context),
                          isDestructive: true,
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Full-screen loading overlay while deleting
            Obx(() => controller.isDeletingAccount.value
                ? Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEE6C61),
                      ),
                    ),
                  )
                : const SizedBox.shrink()),
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

          SizedBox(width: 79.w),

          // Title
          Expanded(
            child: Text(
              'Security',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.11),
            ),
          ),

          SizedBox(width: 103.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Security Option Widget
class _SecurityOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SecurityOption({
    required this.title,
    required this.onTap,
    this.isDestructive = false,
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
            // Title
            Text(
              title,
              style: AppFonts.interMedium(
                fontSize: 14.sp,
                color: isDestructive
                    ? const Color(0xFFEE6C61)
                    : const Color(0xFF1E1E1E),
              ).copyWith(height: 1.30),
            ),

            // Arrow Icon or Delete Icon
            Icon(
              isDestructive ? Icons.delete_outline : Icons.chevron_right,
              size: 24.sp,
              color: isDestructive
                  ? const Color(0xFFEE6C61)
                  : const Color(0xFF1E1E1E),
            ),
          ],
        ),
      ),
    );
  }
}
