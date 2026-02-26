import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';
import '../../utils/app_constants.dart';

/// SplashController manages the splash screen logic and navigation
/// Follows OOP principles with encapsulation and single responsibility
class SplashController extends GetxController {
  // Private observable for navigation state
  final RxBool _isNavigating = false.obs;

  // Configuration constants from centralized constants file
  static const Duration _splashDuration = SplashConfig.splashDuration;

  // Getters
  bool get isNavigating => _isNavigating.value;

  @override
  void onInit() {
    super.onInit();
    _initializeSplash();
  }

  /// Initializes splash screen and starts navigation timer
  void _initializeSplash() {
    // Initialize any app-wide settings here if needed
    _scheduleNavigation();
  }

  /// Schedules navigation to the next screen after splash duration
  Future<void> _scheduleNavigation() async {
    if (_isNavigating.value) return;

    _isNavigating.value = true;

    // Wait for the configured splash duration
    await Future.delayed(_splashDuration);

    // Navigate to onboarding screen
    _navigateToNextScreen();
  }

  /// Navigates to the onboarding screen
  void _navigateToNextScreen() {
    if (Get.context != null && Get.context!.mounted) {
      Get.context!.go(AppPath.onboarding);
    }
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
