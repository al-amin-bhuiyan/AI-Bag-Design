import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';
import '../../routes/app_path.dart';

/// OnboardingScreen - Main onboarding flow with 3 pages
/// Follows OOP principles with composition and encapsulation
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles page change
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  /// Navigates to next page or completes onboarding
  void _handleNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen after onboarding
      if (mounted) {
        context.go(AppPath.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _OnboardingContent(
        pageController: _pageController,
        currentPage: _currentPage,
        onPageChanged: _onPageChanged,
        onNext: _handleNext,
      ),
    );
  }
}

/// Private widget for onboarding content
/// Encapsulates the page view and navigation
class _OnboardingContent extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;

  const _OnboardingContent({
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEFFCFF),
      ),
      child: Stack(
        children: [
          // Page View
          PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              _OnboardingPage1(),
              _OnboardingPage2(),
              _OnboardingPage3(),
            ],
          ),

          // Page Indicators
          Positioned(
            left: 178.w,
            top: 739.h,
            child: _PageIndicators(currentPage: currentPage),
          ),

          // Next Button
          Positioned(
            left: 26.w,
            top: 773.h,
            child: CustomButton.primary(
              label: 'Next',
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}

/// Page 1: Welcome to Soestern
class _OnboardingPage1 extends StatelessWidget {
  const _OnboardingPage1();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingFirst,
            fit: BoxFit.cover,
          ),
        ),

        // Text content
        Positioned(
          left: 26.w,
          top: 319.h,
          child: _OnboardingText(
            title: 'WELCOME TO SOESTERN!',
            description: 'Create, Save and print custom labels\nwith ease.',
          ),
        ),

        // Decorative images (placeholders from your design)
        ..._buildDecorativeImages1(),
      ],
    );
  }

  List<Widget> _buildDecorativeImages1() {
    return [
      // You can add decorative images here if needed
      // For now, the background image handles the visuals
    ];
  }
}

/// Page 2: Design Your Label
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingSecond,
            fit: BoxFit.cover,
          ),
        ),

        // Text content
        Positioned(
          left: 26.w,
          top: 493.h,
          child: _OnboardingText(
            title: 'DESIGN YOUR LABEL OR FULLY PRINTED BAG INSTANTLY',
            description: 'Upload your logo or generate a design with AI — customize text, colors, and layout in just a few taps.',
          ),
        ),
      ],
    );
  }
}

/// Page 3: Preview, Save, Done
class _OnboardingPage3 extends StatelessWidget {
  const _OnboardingPage3();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingThird,
            fit: BoxFit.cover,
          ),
        ),

        // Text content
        Positioned(
          left: 26.w,
          top: 493.h,
          child: _OnboardingText(
            title: 'PREVIEW.  SAVE.  DONE.',
            description: 'See your uploaded labels or custom printed mock up within seconds!',
          ),
        ),
      ],
    );
  }
}

/// Reusable text widget for onboarding pages
/// Encapsulates title and description styling
class _OnboardingText extends StatelessWidget {
  final String title;
  final String description;

  const _OnboardingText({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppFonts.poppinsBold(
              fontSize: 32.sp,
              color: const Color(0xFF0F0F0F),
            ).copyWith(
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: AppFonts.poppinsMedium(
              fontSize: 16.sp,
              color: Colors.black,
            ).copyWith(
              height: 1.38,
            ),
          ),
        ],
      ),
    );
  }
}

/// Page indicators widget
/// Shows which page is currently active
class _PageIndicators extends StatelessWidget {
  final int currentPage;

  const _PageIndicators({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? 8.w : 0),
          child: _PageIndicator(isActive: index == currentPage),
        );
      }),
    );
  }
}

/// Single page indicator
/// Encapsulates indicator styling
class _PageIndicator extends StatelessWidget {
  final bool isActive;

  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.h,
      decoration: ShapeDecoration(
        color: isActive ? const Color(0xFF1355BF) : const Color(0xFFD2D6DB),
        shape: const OvalBorder(),
      ),
    );
  }
}

