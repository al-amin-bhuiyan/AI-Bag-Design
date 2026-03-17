import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_fonts.dart';
import '../custom_button.dart';

/// Delete Account Confirmation Dialog
/// Follows OOP principles with clear separation of concerns
class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({
    Key? key,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 330.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Close Icon (X)
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEE6C61),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 24.sp,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 20.h),
            
            // Title
            Text(
              'Delete Account',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 20.sp,
                color: const Color(0xFFEE6C61),
              ).copyWith(height: 1.2),
            ),
            
            SizedBox(height: 32.h),
            
            // Delete Button with ripple animation
            CircleFadeAnimation(
              onPressed: onConfirm,
              borderRadius: BorderRadius.circular(8.r),
              splashColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEE6C61),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    'Delete Account',
                    style: AppFonts.interMedium(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
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
