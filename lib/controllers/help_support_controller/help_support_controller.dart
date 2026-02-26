import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';

/// HelpSupportController manages help & support screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class HelpSupportController extends GetxController {
  /// Navigate to FAQs / Help Center
  void navigateToFAQs(BuildContext context) {
    if (context.mounted) {
      context.push(AppPath.faqsHelpCenter);
      print('🔵 Navigate to FAQs Help Center');
    }
  }

  /// Navigate to Contact Support
  void navigateToContactSupport(BuildContext context) {
    if (context.mounted) {
      context.push(AppPath.contactSupport);
      print('🔵 Navigate to Contact Support');
    }
  }

  /// Navigate to Privacy Policy + Terms
  void navigateToPrivacyPolicy(BuildContext context) {
    if (context.mounted) {
      context.push(AppPath.privacyPolicy);
      print('🔵 Navigate to Privacy Policy');
    }
  }

  /// Navigate to Terms & Conditions
  void navigateToTermsConditions(BuildContext context) {
    if (context.mounted) {
      context.push(AppPath.termsAndConditions);
      print('🔵 Navigate to Terms & Conditions');
    }
  }

  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
    }
  }
}
