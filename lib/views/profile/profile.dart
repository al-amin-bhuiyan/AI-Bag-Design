import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:jeebz_bag_design_app/utils/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../controllers/profile_controller/profile_controller.dart';
import '../../utils/app_fonts.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_nav_bar_widgets.dart';
import '../../widgets/dialogs/logout_dialog.dart';
import '../../routes/app_path.dart';

/// Profile Screen - Displays user profile and settings options
/// Follows OOP principles with widget composition and separation of concerns
class Profile extends StatelessWidget {
  final bool showNavBar;
  
  const Profile({super.key, this.showNavBar = true});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered and always fetch fresh profile
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    // When the Profile screen is opened, always refresh from API
    // so that name, email, and image are driven ONLY by the
    // GET /accounts/user/profile/ endpoint.
    controller.refreshProfile();

    final content = SafeArea(
      child: Column(
        children: [
          // Custom App Bar
          _ProfileAppBar(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  
                  // Profile Card
                  _ProfileCard(controller: controller),
                  
                  SizedBox(height: 24.h),
                  
                  // Menu Options
                  _MenuOptions(controller: controller),
                  
                  SizedBox(height: 212.h),
                  
                  // Logout Button
                  _LogoutButton(controller: controller),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    // When embedded in another screen, don't use Scaffold
    if (!showNavBar) {
      return content;
    }

    // When standalone, use Scaffold with bottom navigation
    return Scaffold(
      backgroundColor: Colors.white,
      body: content,
      bottomNavigationBar: CustomNavBar(
        currentIndex: 3, // Profile tab
        onTap: (index) => _handleNavigation(context, index),
      ),
    );
  }
  
  /// Handles navigation bar tap events
  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Create
        context.go(AppPath.create);
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
        // Profile - Already on Profile, do nothing
        break;
    }
  }
}

/// Profile App Bar
class _ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 8.h,
        left: 45.w,
        right: 26.w,
        bottom: 24.h,
      ),
      child: Row(
        children: [
          // Back Button (invisible placeholder)
          // Container(
          //   width: 24.w,
          //   height: 24.h,
          //   decoration: ShapeDecoration(
          //     color: Colors.black.withValues(alpha: 0.10),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(100.r),
          //     ),
          //   ),
          // ),
          
          Spacer(),
          
          // Title
          Text(
            'Profile',
            textAlign: TextAlign.center,
            style: AppFonts.poppinsSemiBold(
              fontSize: 18.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(height: 1.22),
          ),
          
          Spacer(),
          
          // Placeholder for symmetry
          Opacity(
            opacity: 0,
            child: Container(
              width: 24.w,
              height: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile Card Widget
/// Displays user name, email, and profile image fetched from API
class _ProfileCard extends StatelessWidget {
  final ProfileController controller;

  const _ProfileCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    // Read directly from session RxString observables inside Obx
    // so GetX correctly tracks each reactive value
    return Obx(() {
      final imageUrl = controller.session.imageUrl.value;
      final name     = controller.session.name.value;
      final email    = controller.session.email.value;
      final loading  = controller.isLoading.value;

      return Container(
        width: 350.w,
        height: 90.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Color(0xFFF2F4F6)),
            borderRadius: BorderRadius.circular(16.r),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 2,
              offset: Offset(1, 1),
              spreadRadius: -0.1,
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Profile Image ──────────────────────────────────────────────
            _ProfileAvatar(imageUrl: imageUrl),

            SizedBox(width: 12.w),

            // ── User Info ──────────────────────────────────────────────────
            Expanded(
              child: loading && name.isEmpty
                  ? _ProfileInfoShimmer()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isNotEmpty ? name : '—',
                          style: AppFonts.poppinsSemiBold(
                            fontSize: 18.sp,
                            color: const Color(0xFF101727),
                          ).copyWith(height: 1.56),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          email.isNotEmpty ? email : '—',
                          style: AppFonts.interRegular(
                            fontSize: 14.sp,
                            color: const Color(0xFF697282),
                          ).copyWith(height: 1.43),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),

            // ── Refresh indicator ──────────────────────────────────────────
            if (loading)
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SizedBox(
                  width: 16.w,
                  height: 16.h,
                  child: LoadingAnimationWidget.beat(
                    color: const Color(0xFF1F7CD5),
                    size: 16.w,
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

/// Profile avatar widget — handles network image, loading, and error fallback
class _ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  const _ProfileAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 70.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF2F4F6)),
          borderRadius: BorderRadius.circular(35.r),
        ),
      ),
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              // Show shimmer while loading
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  color: const Color(0xFFF2F4F6),
                  child: Center(
                    child: LoadingAnimationWidget.beat(
                      color: const Color(0xFF1F7CD5),
                      size: 20.w,
                    ),
                  ),
                );
              },
              // Fallback to asset on error
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  CustomAssets.personimage,
                  fit: BoxFit.cover,
                );
              },
            )
          : Image.asset(
              CustomAssets.personimage,
              fit: BoxFit.cover,
            ),
    );
  }
}

/// Shimmer placeholder for name/email while loading
class _ProfileInfoShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          width: 160.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F6),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}

/// Menu Options Widget
class _MenuOptions extends StatelessWidget {
  final ProfileController controller;

  const _MenuOptions({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.person_outline,
          title: 'Edit Profile',
          onTap: () => controller.navigateToEditProfile(context),
        ),
        
        SizedBox(height: 16.h),
        
        _MenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () => controller.navigateToSettings(context),
        ),
        
        SizedBox(height: 16.h),
        
        _MenuItem(
          icon: Icons.security_sharp,
          title: 'Security',
          onTap: () => controller.navigateToSecurity(context),
        ),
        
        SizedBox(height: 16.h),
        
        _MenuItem(
          icon: Icons.support,
          title: 'Help & Support',
          onTap: () => controller.navigateToHelpSupport(context),
        ),
      ],
    );
  }
}

/// Individual Menu Item Widget
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350.w,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          // Glass effect with gradient
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF2F7FF).withValues(alpha: 0.9),
              const Color(0xFFE6EFFF).withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(10.r), // Circular border
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5), // Glass border effect
            width: 0,
          ),
          boxShadow: [
            // Glass effect shadow
            BoxShadow(
              color: const Color(0xFF1F7CD5).withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            // Inner glow effect
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(-2, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container with glass effect
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.6),
                    Colors.white.withValues(alpha: 0.3),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1F7CD5).withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 20.sp,
                color: const Color(0xFF1F7CD5),
              ),
            ),
            
            SizedBox(width: 16.w),
            
            // Title
            Expanded(
              child: Text(
                title,
                style: AppFonts.interMedium(
                  fontSize: 16.sp,
                  color: const Color(0xFF1E1E1E),
                ).copyWith(height: 1.30),
              ),
            ),
            
            // Arrow Icon with glass background
            Container(
              padding: EdgeInsets.all(4.w),
              // decoration: BoxDecoration(
              //   color: Colors.white.withValues(alpha: 0.5),
              //   shape: BoxShape.circle,
              // ),
              child: Icon(
                Icons.chevron_right,
                size: 24.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Logout Button Widget
class _LogoutButton extends StatelessWidget {
  final ProfileController controller;

  const _LogoutButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: controller.isLoggingOut.value 
          ? null 
          : () => _showLogoutDialog(context),
      child: Container(
        width: 350.w,
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: ShapeDecoration(
          color: const Color(0xFF1F7CD5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.isLoggingOut.value)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 20.w,
                ),
              )
            else ...[
              Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.w400,
                  height: 1.44,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.logout,
                size: 24.sp,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    ));
  }

  /// Shows logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (BuildContext dialogContext) => LogoutDialog(
        onLogoutConfirm: () => controller.confirmLogout(context),
      ),
    );
  }
}