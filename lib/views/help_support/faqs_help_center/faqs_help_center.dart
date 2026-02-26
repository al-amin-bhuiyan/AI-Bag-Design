import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/faqs_help_center_controller/faqs_help_center_controller.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_fonts.dart';

/// FAQs Help Center Screen - Displays frequently asked questions
/// Follows OOP principles with composition and encapsulation
class FAQsHelpCenterScreen extends StatelessWidget {
  const FAQsHelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(FAQsHelpCenterController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(controller: controller),
            
            // Content
            Expanded(
              child: _FAQContent(controller: controller),
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
  final FAQsHelpCenterController controller;

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
          
          SizedBox(width: 55.w),
          
          // Title
          Expanded(
            child: Text(
              'FAQs',
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

/// Private widget for FAQ content
/// Encapsulates scrollable list of FAQs
class _FAQContent extends StatelessWidget {
  final FAQsHelpCenterController controller;

  const _FAQContent({required this.controller});

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
              
              // FAQ List
              _FAQList(controller: controller),
              
              SizedBox(height: 24.h),
            ],
          ),
        ),
      );
    });
  }
}

/// Private widget for FAQ list
/// Encapsulates list of FAQ items
class _FAQList extends StatelessWidget {
  final FAQsHelpCenterController controller;

  const _FAQList({required this.controller});

  @override
  Widget build(BuildContext context) {
    final faqItems = controller.faqItems;

    return Column(
      children: List.generate(
        faqItems.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            bottom: index < faqItems.length - 1 ? 16.h : 0,
          ),
          child: _FAQItem(
            controller: controller,
            faqItem: faqItems[index],
            index: index,
          ),
        ),
      ),
    );
  }
}

/// Private widget for individual FAQ item
/// Encapsulates expandable FAQ with question and answer
class _FAQItem extends StatelessWidget {
  final FAQsHelpCenterController controller;
  final FAQItem faqItem;
  final int index;

  const _FAQItem({
    required this.controller,
    required this.faqItem,
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
            // Question Header
            _FAQItemHeader(
              question: faqItem.question,
              isExpanded: isExpanded,
              onTap: () => controller.toggleFAQ(index),
            ),
            
            // Answer Body (Expandable)
            _FAQItemBody(
              answer: faqItem.answer,
              isExpanded: isExpanded,
            ),
          ],
        ),
      );
    });
  }
}

/// Private widget for FAQ item header
/// Encapsulates question and expand/collapse icon
class _FAQItemHeader extends StatelessWidget {
  final String question;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FAQItemHeader({
    required this.question,
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
            // Question Text
            Expanded(
              child: Text(
                question,
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

/// Private widget for FAQ item body
/// Encapsulates expandable answer content
class _FAQItemBody extends StatelessWidget {
  final String answer;
  final bool isExpanded;

  const _FAQItemBody({
    required this.answer,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: _AnswerContent(answer: answer),
      crossFadeState: isExpanded 
          ? CrossFadeState.showSecond 
          : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
      sizeCurve: Curves.easeInOut,
    );
  }
}

/// Private widget for answer content
/// Encapsulates the answer text with proper styling
class _AnswerContent extends StatelessWidget {
  final String answer;

  const _AnswerContent({required this.answer});

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
          
          // Answer Text
          Text(
            answer,
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
