import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../services/auth_state_service.dart';
import '../../services/token_storage_service.dart';
import '../../widgets/custom_assets.dart';
import '../../widgets/custom_button.dart';
import '../../utils/app_fonts.dart';
import '../../routes/app_path.dart';

/// OnboardingScreen - Main onboarding flow with 3 pages
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

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      TokenStorageService.instance.setOnboardingSeen();
      AuthStateService.instance.reset();
      if (mounted) {
        context.go(AppPath.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody ensures content goes behind gesture bar area
      extendBody: true,
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
    // Get bottom inset (gesture bar / nav bar height)
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      // ✅ Use full screen size instead of fixed 402.w / 874.h
      width: double.infinity,
      height: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Color(0xFFEFFCFF),
      ),
      child: Stack(
        children: [
          // Page View — fills entire screen
          PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: const [
              _OnboardingPage1(),
              _OnboardingPage2(),
              _OnboardingPage3(),
            ],
          ),

          // ✅ Bottom controls: indicators + button above gesture bar
          Positioned(
            left: 0,
            right: 0,
            // Push above gesture bar dynamically
            bottom: bottomInset + 20.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Page Indicators
                _PageIndicators(currentPage: currentPage),

                SizedBox(height: 10.h),

                // Next Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: CustomButton.primary(
                    label: 'Next',
                    onPressed: onNext,
                  ),
                ),
              ],
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingFirst,
            fit: BoxFit.cover,
          ),
        ),

        // ✅ Text position relative to screen height (not fixed pixel)
        Positioned(
          left: 26.w,
          top: screenHeight * 0.34,
          child: const _OnboardingText(
            title: 'WELCOME TO SOESTERN PACKAGING!',
            description: 'Create, Save and print custom full graphic printed bags\nwith ease.',
          ),
        ),
      ],
    );
  }
}

/// Page 2: Design Your Label
class _OnboardingPage2 extends StatelessWidget {
  const _OnboardingPage2();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingSecond,
            fit: BoxFit.cover,
          ),
        ),

        // ✅ Relative position
        Positioned(
          left: 26.w,
          top: screenHeight * 0.565,
          child: const _OnboardingText(
            title: 'DESIGN YOUR LABEL OR FULLY PRINTED BAG INSTANTLY',
            description:
                'Create custom flexible packaging with just a handful of words or an uploaded images.',
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
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            CustomAssets.onBoardingThird,
            fit: BoxFit.cover,
          ),
        ),

        // ✅ Relative position
        Positioned(
          left: 26.w,
          top: screenHeight * 0.565,
          child: const _OnboardingText(
            title: 'PREVIEW.  SAVE.  DONE.',
            description:
                'See your uploaded labels or custom printed mock up within seconds!'
                    'Like the design you created? Contact our sales department to make your idea in to a reality!"',
          ),
        ),
      ],
    );
  }
}

/// Reusable text widget for onboarding pages
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
            ).copyWith(height: 1.25),
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: AppFonts.poppinsMedium(
              fontSize: 16.sp,
              color: Colors.black,
            ).copyWith(height: 1.38),
          ),
        ],
      ),
    );
  }
}

/// Page indicators widget
class _PageIndicators extends StatelessWidget {
  final int currentPage;

  const _PageIndicators({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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