import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_path.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_assets.dart';

/// SplashScreen displays the app's splash screen with branding
/// Follows OOP principles with separation of concerns and composition
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Schedule navigation after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleNavigation(context);
    });

    return Scaffold(
      body: _SplashScreenContent(),
    );
  }

  /// Schedules navigation to onboarding screen after splash duration
  /// Encapsulates navigation logic for better OOP design
  void _scheduleNavigation(BuildContext context) {
    Future.delayed(SplashConfig.splashDuration, () {
      if (context.mounted) {
        context.go(AppPath.onboarding);
      }
    });
  }
}

/// Private widget for splash screen content
/// Separates UI composition from the main widget for better organization
class _SplashScreenContent extends StatelessWidget {
  const _SplashScreenContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        _BackgroundImage(),
        
        // Content
        _CenterContent(),
      ],
    );
  }
}

/// Background image widget
/// Encapsulates background rendering logic
class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CustomAssets.splashBackground,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Center content widget containing logo
/// Encapsulates main content layout
class _CenterContent extends StatelessWidget {
  const _CenterContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _SplashLogo(),
    );
  }
}

/// Splash logo widget
/// Encapsulates logo rendering with proper dimensions
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      CustomAssets.logoSs,
      width: 70.w,
      height: 70.h,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
    );
  }
}
