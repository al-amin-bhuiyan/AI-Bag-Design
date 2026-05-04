import 'package:get/get.dart';
import '../controllers/change_password_controller/change_password_controller.dart';
import '../controllers/create_controller/create_controller.dart';
import '../controllers/forgot_password_controller/forgot_password_controller.dart';
import '../controllers/verification_code_controller/verification_code_controller.dart';
import '../controllers/reset_success_controller/reset_success_controller.dart';
import '../controllers/profile_controller/profile_controller.dart';
import '../controllers/edit_profile_controller/edit_profile_controller.dart';
import '../controllers/collections_controller/collections_controller.dart';
import '../controllers/settings_controller/settings_controller.dart';
import '../controllers/security_controller/security_controller.dart';
import '../controllers/help_support_controller/help_support_controller.dart';
import '../controllers/faqs_help_center_controller/faqs_help_center_controller.dart';
import '../controllers/contact_support_controller/contact_support_controller.dart';
import '../controllers/privacy_policy_controller/privacy_policy_controller.dart';
import '../controllers/terms_and_conditions_controller/terms_and_conditions_controller.dart';
import '../controllers/your_design_controller/your_design_controller.dart';
import '../services/network/network_manager.dart';

/// Binding class manages dependency injection for the entire application
/// Follows OOP principles with separation of concerns and lazy initialization
/// NOTE: SplashController removed — AuthGuardScreen handles auth routing directly
class Binding {
  // Private constructor to prevent instantiation
  Binding._();

  /// Initializes all app-wide dependencies
  /// This method should be called in main() before runApp()
  static void init() {
    _initializeControllers();
    _initializeServices();
  }

  /// Initializes all controllers with lazy loading
  static void _initializeControllers() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(), fenix: true);
    Get.lazyPut<VerificationCodeController>(() => VerificationCodeController(), fenix: true);
    Get.lazyPut<ChangePasswordController>(() => ChangePasswordController(), fenix: true);
    Get.lazyPut<ResetSuccessController>(() => ResetSuccessController(), fenix: true);
    Get.lazyPut<CreateController>(() => CreateController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<EditProfileController>(() => EditProfileController(), fenix: true);
    Get.lazyPut<CollectionsController>(() => CollectionsController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    Get.lazyPut<SecurityController>(() => SecurityController(), fenix: true);
    Get.lazyPut<HelpSupportController>(() => HelpSupportController(), fenix: true);
    Get.lazyPut<FAQsHelpCenterController>(() => FAQsHelpCenterController(), fenix: true);
    Get.lazyPut<ContactSupportController>(() => ContactSupportController(), fenix: true);
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController(), fenix: true);
    Get.lazyPut<TermsAndConditionsController>(() => TermsAndConditionsController(), fenix: true);
    Get.lazyPut<YourDesignController>(() => YourDesignController(), fenix: true);
  }

  /// Initializes app-wide services (singletons that persist entire app lifecycle)
  static void _initializeServices() {
    // Services are singletons — no need to register with Get
    // AuthStateService.instance, TokenStorageService.instance, etc.
    // are accessed directly via their singleton accessors
    
    // Register global network manager
    Get.put<NetworkManager>(NetworkManager(), permanent: true);
  }

  /// Cleans up all dependencies
  static void dispose() {
    Get.deleteAll(force: true);
  }
}