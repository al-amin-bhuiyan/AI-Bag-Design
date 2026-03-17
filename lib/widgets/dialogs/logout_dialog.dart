import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_assets.dart';
import '../custom_button.dart';

/// Logout Confirmation Dialog Widget
/// Follows OOP principles with encapsulation and single responsibility
/// Displays a confirmation dialog when user attempts to logout
class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogoutConfirm;

  const LogoutDialog({
    Key? key,
    required this.onLogoutConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: _DialogContent(onLogoutConfirm: onLogoutConfirm),
    );
  }
}

/// Private widget for dialog content
/// Encapsulates the dialog's visual structure
class _DialogContent extends StatelessWidget {
  final VoidCallback onLogoutConfirm;

  const _DialogContent({required this.onLogoutConfirm});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 75.w, vertical: 24.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width:double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon and Title Section
                    _IconAndTitleSection(),
                    
                    SizedBox(height: 30.h),
                    
                    // Log Out Button
                    _LogoutButton(onLogoutConfirm: onLogoutConfirm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Private widget for icon and title section
/// Encapsulates the logout icon and title text
class _IconAndTitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 181.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logout Icon
          _LogoutIcon(),
          
          SizedBox(height: 8.h),
          
          // Logout Text
          _LogoutTitle(),
        ],
      ),
    );
  }
}

/// Private widget for logout icon
/// Displays the SVG logout icon
class _LogoutIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46.w,
      height: 46.h,
      child: SvgPicture.asset(
        CustomAssets.logouticon,
        width: 46.w,
        height: 46.h,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Private widget for logout title
/// Displays the confirmation message
class _LogoutTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'Logout from the app',
        textAlign: TextAlign.start,
        style: AppFonts.poppinsSemiBold(
          fontSize: 15.sp,
          color: Colors.white,
        ).copyWith(height: 1.10),
      ),
    );
  }
}

/// Private widget for logout button
/// Handles the logout confirmation action
class _LogoutButton extends StatelessWidget {
  final VoidCallback onLogoutConfirm;

  const _LogoutButton({required this.onLogoutConfirm});

  @override
  Widget build(BuildContext context) {
    return CircleFadeAnimation(
      onPressed: () {
        Navigator.of(context).pop();
        onLogoutConfirm();
      },
      borderRadius: BorderRadius.circular(10.r),
      splashColor: Colors.white,
      child: Container(
        width: double.infinity,
        height: 44.h,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xCC181A20),
          border: Border.all(
            width: 1,
            color: const Color(0xCC181A20),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Log Out',
              style: AppFonts.poppinsRegular(
                fontSize: 16.sp,
                color: Colors.white,
              ).copyWith(height: 1),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.logout,
              color: Colors.white,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
