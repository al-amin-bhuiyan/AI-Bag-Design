import 'package:go_router/go_router.dart';
import '../views/profile/security/security.dart';
import '../views/profile/settings/settings.dart';
import '../views/help_support/help_support.dart';
import '../views/help_support/faqs_help_center/faqs_help_center.dart';
import '../views/help_support/contact_support/contact_support.dart';
import '../views/help_support/privacy_policy/privacy_policy.dart';
import '../views/help_support/terms_and_conditions/terms_and_conditions.dart';
import 'app_path.dart';
import '../views/splash_screen/splash_screen.dart';
import '../views/on_boarding/on_boarding.dart';
import '../views/log_in/log_in.dart';
import '../views/sign_up/sign_up.dart';
import '../views/forget_password/forget_password.dart';
import '../views/verification_code/verification_code.dart';
import '../views/change_password/change_password.dart';
import '../views/reset_success/reset_success.dart';
import '../views/upload_image/upload_image_screen.dart';
import '../views/text_to_design/text_to_design_screen.dart';
import '../views/create/create.dart';
import '../views/collections/collections.dart';
import '../views/your_design/your_design.dart';
import '../views/profile/profile.dart';
import '../views/profile/edit_profile/edit_profile.dart';

/// RoutePath class manages application routing using GoRouter
/// Follows OOP principles with static configuration and centralized route management
class RoutePath {
  // Private constructor to prevent instantiation
  RoutePath._();

  /// Application router instance with all route configurations
  static final GoRouter router = GoRouter(
    initialLocation: AppPath.onboarding,
    routes: _buildRoutes(),
  );

  /// Builds the route configuration list
  /// This approach allows for better organization and scalability
  static List<RouteBase> _buildRoutes() {
    return [
      _createSplashRoute(),
      _createOnboardingRoute(),
      _createLoginRoute(),
      _createSignUpRoute(),
      _createForgotPasswordRoute(),
      _createVerificationCodeRoute(),
      _createChangePasswordRoute(),
      _createResetSuccessRoute(),
      _createCreateRoute(),
      _createUploadImageRoute(),
      _createTextToDesignRoute(),
      _createCollectionsRoute(),
      _createYourDesignRoute(),
      _createProfileRoute(),
      _createEditProfileRoute(),
      _createSettingsRoute(),
      _createSecurityRoute(),
      _createHelpSupportRoute(),
      _createFAQsHelpCenterRoute(),
      _createContactSupportRoute(),
      _createPrivacyPolicyRoute(),
      _createTermsAndConditionsRoute(),
      // Add more routes here as the app grows
    ];
  }

  /// Creates the splash screen route
  static GoRoute _createSplashRoute() {
    return GoRoute(
      path: AppPath.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    );
  }

  /// Creates the onboarding screen route
  static GoRoute _createOnboardingRoute() {
    return GoRoute(
      path: AppPath.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    );
  }

  /// Creates the login screen route
  static GoRoute _createLoginRoute() {
    return GoRoute(
      path: AppPath.login,
      name: 'login',
      builder: (context, state) => const LogInScreen(),
    );
  }

  /// Creates the sign up screen route
  static GoRoute _createSignUpRoute() {
    return GoRoute(
      path: AppPath.signUp,
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    );
  }

  /// Creates the forgot password screen route
  static GoRoute _createForgotPasswordRoute() {
    return GoRoute(
      path: AppPath.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    );
  }

  /// Creates the verification code screen route
  static GoRoute _createVerificationCodeRoute() {
    return GoRoute(
      path: AppPath.verificationCode,
      name: 'verificationCode',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return VerificationCodeScreen(email: email);
      },
    );
  }

  /// Creates the change password screen route
  static GoRoute _createChangePasswordRoute() {
    return GoRoute(
      path: AppPath.changePassword,
      name: 'changePassword',
      builder: (context, state) => const ChangePasswordScreen(),
    );
  }

  /// Creates the reset success screen route
  static GoRoute _createResetSuccessRoute() {
    return GoRoute(
      path: AppPath.resetSuccess,
      name: 'resetSuccess',
      builder: (context, state) => const ResetSuccessScreen(),
    );
  }
  
  /// Creates the create screen route
  static GoRoute _createCreateRoute() {
    return GoRoute(
      path: AppPath.create,
      name: 'create',
      builder: (context, state) => const CreateScreen(),
    );
  }
  
  /// Creates the upload image screen route
  static GoRoute _createUploadImageRoute() {
    return GoRoute(
      path: '/upload-image',
      name: 'uploadImage',
      builder: (context, state) => const UploadImageScreen(),
    );
  }
  
  /// Creates the text to design screen route
  static GoRoute _createTextToDesignRoute() {
    return GoRoute(
      path: '/text-to-design',
      name: 'textToDesign',
      builder: (context, state) => const TextToDesignScreen(),
    );
  }
  
  /// Creates the collections screen route
  static GoRoute _createCollectionsRoute() {
    return GoRoute(
      path: AppPath.collection,
      name: 'collection',
      builder: (context, state) => const CollectionsScreen(),
    );
  }
  
  /// Creates the your design screen route
  static GoRoute _createYourDesignRoute() {
    return GoRoute(
      path: AppPath.yourdesign,
      name: 'yourdesign',
      builder: (context, state) => const YourDesignScreen(),
    );
  }
  
  /// Creates the profile screen route
  static GoRoute _createProfileRoute() {
    return GoRoute(
      path: AppPath.profile,
      name: 'profile',
      builder: (context, state) => const Profile(),
    );
  }
  
  /// Creates the edit profile screen route
  static GoRoute _createEditProfileRoute() {
    return GoRoute(
      path: AppPath.editProfile,
      name: 'editProfile',
      builder: (context, state) => const EditProfile(),
    );
  }
  
  /// Creates the settings screen route
  static GoRoute _createSettingsRoute() {
    return GoRoute(
      path: AppPath.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    );
  }
  
  /// Creates the security screen route
  static GoRoute _createSecurityRoute() {
    return GoRoute(
      path: AppPath.security,
      name: 'security',
      builder: (context, state) => const SecurityScreen(),
    );
  }
  
  /// Creates the help & support screen route
  static GoRoute _createHelpSupportRoute() {
    return GoRoute(
      path: AppPath.helpSupport,
      name: 'helpSupport',
      builder: (context, state) => const HelpSupportScreen(),
    );
  }
  
  /// Creates the FAQs help center screen route
  static GoRoute _createFAQsHelpCenterRoute() {
    return GoRoute(
      path: AppPath.faqsHelpCenter,
      name: 'faqsHelpCenter',
      builder: (context, state) => const FAQsHelpCenterScreen(),
    );
  }
  
  /// Creates the contact support screen route
  static GoRoute _createContactSupportRoute() {
    return GoRoute(
      path: AppPath.contactSupport,
      name: 'contactSupport',
      builder: (context, state) => const ContactSupportScreen(),
    );
  }
  
  /// Creates the privacy policy screen route
  static GoRoute _createPrivacyPolicyRoute() {
    return GoRoute(
      path: AppPath.privacyPolicy,
      name: 'privacyPolicy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    );
  }
  
  /// Creates the terms and conditions screen route
  static GoRoute _createTermsAndConditionsRoute() {
    return GoRoute(
      path: AppPath.termsAndConditions,
      name: 'termsAndConditions',
      builder: (context, state) => const TermsAndConditionsScreen(),
    );
  }
}
