import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';
import '../../services/auth_state_service.dart';

/// AuthGuardScreen - Invisible bootstrap screen that resolves auth state
/// then immediately redirects to the correct screen.
///
/// This is the app's true initial route. It shows nothing visible to the user
/// (native splash is already showing), resolves auth, then navigates.
///
/// Real-life pattern used by: Spotify, Instagram, YouTube
class AuthGuardScreen extends StatefulWidget {
  const AuthGuardScreen({super.key});

  @override
  State<AuthGuardScreen> createState() => _AuthGuardScreenState();
}

class _AuthGuardScreenState extends State<AuthGuardScreen> {
  @override
  void initState() {
    super.initState();
    _resolveAndNavigate();
  }

  /// Resolves auth state and navigates to the correct screen
  Future<void> _resolveAndNavigate() async {
    final AuthState authState = await AuthStateService.instance.resolve();

    if (!mounted) return;

    switch (authState) {
      case AuthState.firstLaunch:
        // Brand new user — show onboarding
        context.go(AppPath.onboarding);
        break;

      case AuthState.unauthenticated:
        // Returning user, not logged in — skip onboarding, go to login
        context.go(AppPath.login);
        break;

      case AuthState.authenticated:
        // Logged in with valid token — go straight to create
        context.go(AppPath.create);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Transparent scaffold — native splash is still visible at this point
    return const Scaffold(
      backgroundColor: Color(0xFFEBFCFF),
      body: SizedBox.expand(),
    );
  }
}
