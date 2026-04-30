import 'package:go_router/go_router.dart';
import '../views/auth_guard/auth_guard_screen.dart';
import '../views/profile/security/security.dart';
import '../views/profile/settings/settings.dart';
import '../views/help_support/help_support.dart';
import '../views/help_support/faqs_help_center/faqs_help_center.dart';
import '../views/help_support/contact_support/contact_support.dart';
import '../views/help_support/privacy_policy/privacy_policy.dart';
import '../views/help_support/terms_and_conditions/terms_and_conditions.dart';
import '../views/set_new_password/set_new_password.dart';
import '../views/verification_code_from_signup/verification_code_from_signup.dart';
import 'app_path.dart';
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

/// RoutePath - Centralized GoRouter configuration
///
/// Navigation decision flow (real-life app pattern):
///   App open → / (AuthGuardScreen resolves auth) → correct screen
///
/// Follows 100% OOP: private constructor, static factory, single responsibility
class RoutePath {
  // Private constructor to prevent instantiation
  RoutePath._();

  /// Application router — initial route is AuthGuard which decides everything
  static final GoRouter router = GoRouter(
    initialLocation: AppPath.splash, // '/' → AuthGuardScreen
    routes: _buildRoutes(),
  );

  /// Builds the complete route list
  static List<RouteBase> _buildRoutes() {
    return [
      // ── Auth Guard (true initial route) ───────────────────────────────────
      _createAuthGuardRoute(),

      // ── Auth Flow ─────────────────────────────────────────────────────────
      _createOnboardingRoute(),
      _createLoginRoute(),
      _createSignUpRoute(),
      _createForgotPasswordRoute(),
      _createVerificationCodeRoute(),
      _createVerificationCodeFromSignupRoute(),
      _createChangePasswordRoute(),
      _createSetNewPasswordRoute(),
      _createResetSuccessRoute(),

      // ── Main App ──────────────────────────────────────────────────────────
      _createCreateRoute(),
      _createUploadImageRoute(),
      _createTextToDesignRoute(),
      _createCollectionsRoute(),
      _createYourDesignRoute(),

      // ── Profile & Settings ────────────────────────────────────────────────
      _createProfileRoute(),
      _createEditProfileRoute(),
      _createSettingsRoute(),
      _createSecurityRoute(),

      // ── Help & Support ────────────────────────────────────────────────────
      _createHelpSupportRoute(),
      _createFAQsHelpCenterRoute(),
      _createContactSupportRoute(),
      _createPrivacyPolicyRoute(),
      _createTermsAndConditionsRoute(),
    ];
  }

  // ── Auth Guard ─────────────────────────────────────────────────────────────

  /// '/' — Invisible bootstrap screen that resolves auth then redirects
  static GoRoute _createAuthGuardRoute() {
    return GoRoute(
      path: AppPath.splash,
      name: 'authGuard',
      builder: (context, state) => const AuthGuardScreen(),
    );
  }

  // ── Auth Flow ──────────────────────────────────────────────────────────────

  static GoRoute _createOnboardingRoute() {
    return GoRoute(
      path: AppPath.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    );
  }

  static GoRoute _createLoginRoute() {
    return GoRoute(
      path: AppPath.login,
      name: 'login',
      builder: (context, state) => const LogInScreen(),
    );
  }

  static GoRoute _createSignUpRoute() {
    return GoRoute(
      path: AppPath.signUp,
      name: 'signup',
      builder: (context, state) => const SignUpScreen(),
    );
  }

  static GoRoute _createForgotPasswordRoute() {
    return GoRoute(
      path: AppPath.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordScreen(),
    );
  }

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

  static GoRoute _createVerificationCodeFromSignupRoute() {
    return GoRoute(
      path: AppPath.verificationCodefromsignup,
      name: 'verificationCodefromsignup',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        return VerificationCodeFromSignup(email: email);
      },
    );
  }

  static GoRoute _createChangePasswordRoute() {
    return GoRoute(
      path: AppPath.changePassword,
      name: 'changePassword',
      builder: (context, state) => const ChangePasswordScreen(),
    );
  }

  static GoRoute _createSetNewPasswordRoute() {
    return GoRoute(
      path: AppPath.setNewPassword,
      name: 'setNewPassword',
      builder: (context, state) {
        final resetToken = state.uri.queryParameters['reset_token'];
        return SetNewPasswordScreen(resetToken: resetToken);
      },
    );
  }

  static GoRoute _createResetSuccessRoute() {
    return GoRoute(
      path: AppPath.resetSuccess,
      name: 'resetSuccess',
      builder: (context, state) => const ResetSuccessScreen(),
    );
  }

  // ── Main App ───────────────────────────────────────────────────────────────

  static GoRoute _createCreateRoute() {
    return GoRoute(
      path: AppPath.create,
      name: 'create',
      builder: (context, state) => const CreateScreen(),
    );
  }

  static GoRoute _createUploadImageRoute() {
    return GoRoute(
      path: '/upload-image',
      name: 'uploadImage',
      builder: (context, state) => const UploadImageScreen(),
    );
  }

  static GoRoute _createTextToDesignRoute() {
    return GoRoute(
      path: '/text-to-design',
      name: 'textToDesign',
      builder: (context, state) => const TextToDesignScreen(),
    );
  }

  static GoRoute _createCollectionsRoute() {
    return GoRoute(
      path: AppPath.collection,
      name: 'collection',
      builder: (context, state) => const CollectionsScreen(),
    );
  }

  static GoRoute _createYourDesignRoute() {
    return GoRoute(
      path: AppPath.yourdesign,
      name: 'yourdesign',
      builder: (context, state) => const YourDesignScreen(),
    );
  }

  // ── Profile ────────────────────────────────────────────────────────────────

  static GoRoute _createProfileRoute() {
    return GoRoute(
      path: AppPath.profile,
      name: 'profile',
      builder: (context, state) => const Profile(),
    );
  }

  static GoRoute _createEditProfileRoute() {
    return GoRoute(
      path: AppPath.editProfile,
      name: 'editProfile',
      builder: (context, state) => const EditProfile(),
    );
  }

  static GoRoute _createSettingsRoute() {
    return GoRoute(
      path: AppPath.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    );
  }

  static GoRoute _createSecurityRoute() {
    return GoRoute(
      path: AppPath.security,
      name: 'security',
      builder: (context, state) => const SecurityScreen(),
    );
  }

  // ── Help & Support ─────────────────────────────────────────────────────────

  static GoRoute _createHelpSupportRoute() {
    return GoRoute(
      path: AppPath.helpSupport,
      name: 'helpSupport',
      builder: (context, state) => const HelpSupportScreen(),
    );
  }

  static GoRoute _createFAQsHelpCenterRoute() {
    return GoRoute(
      path: AppPath.faqsHelpCenter,
      name: 'faqsHelpCenter',
      builder: (context, state) => const FAQsHelpCenterScreen(),
    );
  }

  static GoRoute _createContactSupportRoute() {
    return GoRoute(
      path: AppPath.contactSupport,
      name: 'contactSupport',
      builder: (context, state) => const ContactSupportScreen(),
    );
  }

  static GoRoute _createPrivacyPolicyRoute() {
    return GoRoute(
      path: AppPath.privacyPolicy,
      name: 'privacyPolicy',
      builder: (context, state) => const PrivacyPolicyScreen(),
    );
  }

  static GoRoute _createTermsAndConditionsRoute() {
    return GoRoute(
      path: AppPath.termsAndConditions,
      name: 'termsAndConditions',
      builder: (context, state) {
        final onboardingStr = state.uri.queryParameters['onboarding'];
        final isFromOnboarding = onboardingStr == 'true';
        
        // As we use GoRouter, we might need a way to pass this to the controller.
        // It's cleaner to pass it to the Screen widget, but the controller uses GetX.
        // We'll set it here via Get arguments if needed, but it's better to use Get.put with tag or just set it:
        // Wait, `TermsAndConditionsScreen` doesn't take parameters right now.
        return TermsAndConditionsScreen(isFromOnboarding: isFromOnboarding);
      },
    );
  }
}