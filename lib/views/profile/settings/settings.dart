import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../controllers/settings_controller/settings_controller.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_back_button.dart';


/// Settings Screen - Displays app settings with toggle switches
/// Follows OOP principles with widget composition and separation of concerns
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SettingsController());

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

                    // Notifications Setting
                    _SettingCard(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Enable Notifications',
                      description: 'Get updates about order status and print confirmation.',
                      value: controller.notificationsEnabled,
                      onChanged: controller.toggleNotifications,
                    ),

                    SizedBox(height: 24.h),

                    // Auto Apply Mockup Setting
                    _SettingCard(
                      icon: Icons.auto_awesome_outlined,
                      title: 'Auto Apply to Mockup',
                      subtitle: 'Allow auto Mockup',
                      description: 'Automatically preview uploaded design on bag.',
                      value: controller.autoApplyMockup,
                      onChanged: controller.toggleAutoApplyMockup,
                    ),

                    SizedBox(height: 24.h),

                    // High Quality Export Setting
                    _SettingCard(
                      icon: Icons.highlight,
                      title: 'High Quality Export',
                      subtitle: 'Allow high quality export',
                      description: 'Export designs in 300 DPI for printing.',
                      value: controller.highQualityExport,
                      onChanged: controller.toggleHighQualityExport,
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

          SizedBox(width: 79.w),

          // Title
          Expanded(
            child: Text(
              'Settings',
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

/// Setting Card Widget with toggle switch
class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final RxBool value;
  final Function(bool) onChanged;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: EdgeInsets.all(12.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x33C9C8C8),
            blurRadius: 15,
            offset: const Offset(0, 2),
            spreadRadius:20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section with icon
          Container(
            width: 326.w,
            padding: EdgeInsets.only(bottom: 8.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: Colors.grey.withValues(alpha: 0.20),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20.sp,
                  color: Colors.blue,
                ),

                SizedBox(width: 8.w),

                Text(
                  title,
                  style: AppFonts.poppinsSemiBold(
                    fontSize: 16.sp,
                    color: const Color(0xFF0F0F0F),
                  ).copyWith(height: 1.50),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Content Section with toggle
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subtitle,
                      style: AppFonts.interRegular(
                        fontSize: 16.sp,
                        color: const Color(0xFF0F0F0F),
                      ).copyWith(height: 1.25),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      description,
                      style: AppFonts.interRegular(
                        fontSize: 12.sp,
                        color: const Color(0xFF0F0F0F),
                      ).copyWith(height: 1.67),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 61.w),

              // Toggle Switch
              Obx(() => _CustomToggle(
                value: value.value,
                onChanged: onChanged,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom Toggle Switch Widget
class _CustomToggle extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  const _CustomToggle({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46.w,
        height: 26.h,
        padding: EdgeInsets.all(2.w),
        decoration: ShapeDecoration(
          color: value
              ? const Color(0x331F7CD5)
              : Colors.grey.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.w,
            height: 22.h,
            decoration: ShapeDecoration(
              color: value
                  ? const Color(0xFF1F7CD5)
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.r),
              ),
              shadows: [
                BoxShadow(
                  color: const Color(0x0C000000),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
