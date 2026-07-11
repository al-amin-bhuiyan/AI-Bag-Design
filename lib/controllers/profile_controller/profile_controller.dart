import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/user_profile_model.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/auth_state_service.dart';
import '../../services/session_data_isolation_service.dart';
import '../../services/token_storage_service.dart';
import '../../services/user_session_service.dart';
import '../../services/network/network_manager.dart';

/// ProfileController - Manages profile screen state and business logic
/// Reads user data from UserSessionService (single source of truth)
/// Any update in EditProfile instantly reflects here via reactive observables
/// Follows 100% OOP: encapsulation, single responsibility, composition
class ProfileController extends GetxController {
  // ─── Dependencies ─────────────────────────────────────────────────────────
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  /// Single source of truth for user data — shared across all controllers
  final UserSessionService session = UserSessionService.instance;

  // ─── Expose session observables for views (shorthand getters) ─────────────
  RxString get userName         => session.name;
  RxString get userEmail        => session.email;
  RxString get userProfileImage => session.imageUrl;
  RxBool   get isAdmin          => session.isAdmin;
  RxInt    get userId           => session.id;

  // ─── Loading states ───────────────────────────────────────────────────────
  final RxBool isLoading    = false.obs;
  final RxBool isLoggingOut = false.obs;

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    // If session not yet loaded, load cache instantly then re-fetch from API
    if (!session.isLoaded.value) {
      _loadCachedProfile();
    }
    fetchProfile();
    
    // Auto-retry fetching data when internet comes back online
    if (Get.isRegistered<NetworkManager>()) {
      ever(Get.find<NetworkManager>().isConnected, (bool connected) {
        if (connected) {
          debugPrint('🌐 Internet restored: Auto-refreshing profile data...');
          fetchProfile();
        }
      });
    }
  }

  // ─── Private ──────────────────────────────────────────────────────────────

  Future<void> _loadCachedProfile() async {
    await session.loadFromCache();
  }

  // ─── Public Methods ───────────────────────────────────────────────────────

  /// Fetches real user profile from API using saved Bearer token
  /// GET /accounts/user/profile/
  /// Updates UserSessionService → all screens reading session observables
  /// rebuild automatically
  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final String? accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        debugPrint('⚠️ No access token — cannot fetch profile');
        return;
      }

      final ApiResponse<UserProfileModel> response =
          await _authService.getProfile(accessToken: accessToken);

      if (response.success && response.data != null) {
        // Update the single source of truth — ProfileCard, NavBar, etc. all rebuild
        await session.updateFromProfile(response.data!);
        debugPrint('✅ ProfileController: fetched ${session.name.value}');
      } else {
        debugPrint('⚠️ Profile fetch failed: ${response.errorMessage}');
      }
    } catch (e) {
      debugPrint('❌ Profile fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes profile (pull-to-refresh compatible)
  Future<void> refreshProfile() async => fetchProfile();

  // ─── Navigation ───────────────────────────────────────────────────────────

  void navigateToEditProfile(BuildContext context) =>
      context.push(AppPath.editProfile);

  void navigateToSettings(BuildContext context) =>
      context.push(AppPath.settings);

  void navigateToSecurity(BuildContext context) =>
      context.push(AppPath.security);

  void navigateToHelpSupport(BuildContext context) =>
      context.push(AppPath.helpSupport);

  // ─── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout(BuildContext context) async {
    isLoggingOut.value = true;
    try {
      debugPrint('🚪 Logging out user: ${session.email.value}');

      // Clear all state immediately for fast visual update
      session.clear();
      SessionDataIsolationService.instance.clearUserScopedState();
      AuthStateService.instance.setUnauthenticated();

      // Clear specific auth tokens and flags
      await _tokenStorage.clearAll(isManualLogout: true);

      // Force UI reset
      update();

      debugPrint('✅ Logout complete — redirecting to login');

      if (context.mounted) {
        context.go(AppPath.login);
      }
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      Fluttertoast.showToast(
        msg: 'Logout failed. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        textColor: Colors.white,
        fontSize: 15.0,
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  Future<void> confirmLogout(BuildContext context) async => logout(context);
}