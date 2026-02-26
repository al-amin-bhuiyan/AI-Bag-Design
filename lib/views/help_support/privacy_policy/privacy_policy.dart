import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/privacy_policy_controller/privacy_policy_controller.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

/// Privacy Policy Screen - Displays privacy policy with expandable sections
/// Follows OOP principles with composition and encapsulation
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(controller: controller),
            
            // Content
            Expanded(
              child: _PolicyContent(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

/// Private widget for app bar
/// Encapsulates header with back button and title
class _AppBar extends StatelessWidget {
  final PrivacyPolicyController controller;

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
          
          SizedBox(width: 30.w),
          
          // Title
          Expanded(
            child: Text(
              'Privacy Policy',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.11),
            ),
          ),
          
          SizedBox(width: 64.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Private widget for policy content
/// Encapsulates scrollable list of policy sections
class _PolicyContent extends StatelessWidget {
  final PrivacyPolicyController controller;

  const _PolicyContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return _LoadingView();
      }

      return RefreshIndicator(
        onRefresh: controller.refresh,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              
              // Policy Sections List
              _PolicyList(controller: controller),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    });
  }
}

/// Private widget for policy sections list
/// Encapsulates list of expandable policy sections
class _PolicyList extends StatelessWidget {
  final PrivacyPolicyController controller;

  const _PolicyList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final sections = controller.policySections;

    return Column(
      children: List.generate(
        sections.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < sections.length - 1 ? 16.h : 0,
          ),
          child: _PolicySectionItem(
            controller: controller,
            section: sections[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

/// Private widget for individual policy section
/// Encapsulates expandable section with title and content
class _PolicySectionItem extends StatelessWidget {
  final PrivacyPolicyController controller;
  final PrivacyPolicySection section;
  final int index;

  const _PolicySectionItem({
    required this.controller,
    required this.section,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExpanded = controller.isExpanded(index);

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Section Header
            _SectionHeader(
              title: section.title,
              isExpanded: isExpanded,
              onTap: () => controller.toggleSection(index),
            ),
            
            // Section Body (Expandable)
            _SectionBody(
              content: section.content,
              isExpanded: isExpanded,
            ),
          ],
        ),
      );
    });
  }
}

/// Private widget for section header
/// Encapsulates title and expand/collapse icon
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isExpanded;
  final VoidCallback onTap;

  const _SectionHeader({
    required this.title,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Row(
          children: [
            // Title Text
            Expanded(
              child: Text(
                title,
                style: AppFonts.poppinsSemiBold(
                  fontSize: 15.sp,
                  color: const Color(0xFF0F0F0F),
                ).copyWith(height: 1.33),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Expand/Collapse Icon
            _ExpandIcon(isExpanded: isExpanded),
          ],
        ),
      ),
    );
  }
}

/// Private widget for expand/collapse icon
/// Encapsulates animated chevron icon
class _ExpandIcon extends StatelessWidget {
  final bool isExpanded;

  const _ExpandIcon({required this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: isExpanded ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Icon(
        Icons.keyboard_arrow_down,
        size: 24.sp,
        color: const Color(0xFF6B7280),
      ),
    );
  }
}

/// Private widget for section body
/// Encapsulates expandable content
class _SectionBody extends StatelessWidget {
  final String content;
  final bool isExpanded;

  const _SectionBody({
    required this.content,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: _ContentText(content: content),
      crossFadeState: isExpanded 
          ? CrossFadeState.showSecond 
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.easeInOut,
    );
  }
}

/// Private widget for content text
/// Encapsulates the content text with proper styling
class _ContentText extends StatelessWidget {
  final String content;

  const _ContentText({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Divider
          Container(
            height: 1,
            color: const Color(0xFFE5E7EB),
            margin: EdgeInsets.only(bottom: 12.h),
          ),
          
          // Content Text
          Text(
            content,
            style: AppFonts.poppinsRegular(
              fontSize: 13.sp,
              color: const Color(0xFF6B7280),
            ).copyWith(height: 1.54),
          ),
        ],
      ),
    );
  }
}

/// Private widget for loading view
/// Encapsulates loading indicator
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 2,
      ),
    );
  }
}
