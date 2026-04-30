import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/terms_and_conditions_controller/terms_and_conditions_controller.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';
import '../../../widgets/custom_button.dart';

/// Terms & Conditions Screen - Displays terms with expandable sections or a page view
/// Follows OOP principles with composition and encapsulation
class TermsAndConditionsScreen extends StatefulWidget {
  final bool isFromOnboarding;

  const TermsAndConditionsScreen({
    super.key,
    this.isFromOnboarding = false,
  });

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late TermsAndConditionsController controller;

  @override
  void initState() {
    super.initState();
    // Initialize controller and set the value directly
    controller = Get.put(TermsAndConditionsController());
    // Safe to set value right after initialization before build
    controller.isFromOnboarding.value = widget.isFromOnboarding;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            // App Bar
            _AppBar(controller: controller),
            
            // Content
            Expanded(
              child: controller.isFromOnboarding.value
                  ? _TermsOnboardingContent(controller: controller)
                  : _TermsVerticalContent(controller: controller),
            ),
            
            // Bottom Action Row (Only for onboarding)
            if (controller.isFromOnboarding.value)
              _BottomActionRow(controller: controller),
          ],
        )),
      ),
    );
  }
}

/// Private widget for app bar
/// Encapsulates header with back button and title
class _AppBar extends StatelessWidget {
  final TermsAndConditionsController controller;

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
          
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Text(
              'Terms & Conditions',
              textAlign: TextAlign.center,
              style: AppFonts.poppinsSemiBold(
                fontSize: 18.sp,
                color: const Color(0xFF0F0F0F),
              ).copyWith(height: 1.11),
            ),
          ),
          
          SizedBox(width: 50.w), // Balance for back button
        ],
      ),
    );
  }
}

/// Private widget for terms onboarding content
/// Encapsulates horizontal scrollable list of terms sections
class _TermsOnboardingContent extends StatelessWidget {
  final TermsAndConditionsController controller;

  const _TermsOnboardingContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const _LoadingView();
      }

      final sections = controller.termsSections;

      return PageView.builder(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFE5E7EB),
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: AppFonts.poppinsSemiBold(
                      fontSize: 18.sp,
                      color: const Color(0xFF0F0F0F),
                    ).copyWith(height: 1.33),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    height: 1,
                    color: const Color(0xFFE5E7EB),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    section.content,
                    style: AppFonts.poppinsRegular(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ).copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

/// Private widget for terms vertical content
/// Encapsulates vertical scrollable expandable list of terms sections (Accordion)
class _TermsVerticalContent extends StatelessWidget {
  final TermsAndConditionsController controller;

  const _TermsVerticalContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const _LoadingView();
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
              
              // Terms Sections List
              _TermsList(controller: controller),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    });
  }
}

/// Private widget for terms sections list
class _TermsList extends StatelessWidget {
  final TermsAndConditionsController controller;

  const _TermsList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final sections = controller.termsSections;

    return Column(
      children: List.generate(
        sections.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < sections.length - 1 ? 16.h : 0,
          ),
          child: _TermsSectionItem(
            controller: controller,
            section: sections[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

/// Private widget for individual terms section (Accordion Item)
class _TermsSectionItem extends StatelessWidget {
  final TermsAndConditionsController controller;
  final TermsSection section;
  final int index;

  const _TermsSectionItem({
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
            side: const BorderSide(
              width: 1,
              color: Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
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

/// Private widget for bottom action row
class _BottomActionRow extends StatelessWidget {
  final TermsAndConditionsController controller;

  const _BottomActionRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final isLast = controller.isLastPage;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.termsSections.length,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              // Action buttons
              Row(
                children: [
                  if (controller.currentPage.value > 0) ...[
                    Expanded(
                      flex: 1,
                      child: CustomButton.outlined(
                        label: 'Back',
                        onPressed: controller.previousPage,
                      ),
                    ),
                    SizedBox(width: 16.w),
                  ],
                  
                  Expanded(
                    flex: 2,
                    child: CustomButton.primary(
                      label: isLast ? 'Agree & Continue' : 'Next',
                      onPressed: isLast 
                          ? () => controller.agreeAndContinue(context)
                          : controller.nextPage,
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
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