import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ProfileController - Manages profile screen state and business logic
/// Follows OOP principles with single responsibility and separation of concerns
class ProfileController extends GetxController {
  // ============ Observables ============
  
  // User profile data
  final RxString userName = 'Mohammad Shobuj'.obs;
  final RxString userEmail = 'example@gmail.com'.obs;
  final RxString userProfileImage = ''.obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoggingOut = false.obs;

  // ============ Lifecycle Methods ============
  
  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ============ Private Methods ============
  
  /// Loads user profile data
  void _loadUserProfile() {
    // TODO: Load user profile from API or local storage
    // This is placeholder data
    userName.value = 'Mohammad Shobuj';
    userEmail.value = 'example@gmail.com';
    userProfileImage.value = ''; // Will use placeholder
  }

  /// Sets loading state
  void _setLoading(bool value) {
    isLoading.value = value;
  }

  /// Sets logout loading state
  void _setLoggingOut(bool value) {
    isLoggingOut.value = value;
  }

  // ============ Public Methods ============
  
  /// Navigates to Edit Profile screen
  void navigateToEditProfile(BuildContext context) {
    context.push('/edit-profile');
    print('🔵 Navigate to Edit Profile');
  }

  /// Navigates to Settings screen
  void navigateToSettings(BuildContext context) {
    context.push('/settings');
    print('🔵 Navigate to Settings');
  }

  /// Navigates to Security screen
  void navigateToSecurity(BuildContext context) {
    context.push('/security');
    print('🔵 Navigate to Security');
  }

  /// Navigates to Help & Support screen
  void navigateToHelpSupport(BuildContext context) {
    context.push('/help-support');
    print('🔵 Navigate to Help & Support');
  }

  /// Shows logout confirmation dialog
  /// Returns true if user confirms, false otherwise
  Future<bool> showLogoutDialog() async {
    // This will be called from the UI to show the dialog
    // The actual dialog will be shown from the view
    return true; // Placeholder
  }

  /// Handles user logout
  Future<void> logout() async {
    _setLoggingOut(true);
    
    try {
      // TODO: Implement actual logout logic
      // - Clear user session
      // - Clear local storage
      // - Call logout API
      await Future.delayed(const Duration(seconds: 1));
      
      print('✅ Logout successful');
      
      // Navigate to login screen and clear navigation stack
      // Get.offAllNamed(AppPath.login);
      
    } catch (e) {
      print('❌ Logout failed: $e');
    } finally {
      _setLoggingOut(false);
    }
  }

  /// Performs actual logout after confirmation
  Future<void> confirmLogout() async {
    await logout();
  }

  /// Updates user profile data
  Future<void> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    _setLoading(true);
    
    try {
      // TODO: Implement API call to update profile
      if (name != null) userName.value = name;
      if (email != null) userEmail.value = email;
      if (profileImage != null) userProfileImage.value = profileImage;
      
      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Profile update failed: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Refreshes profile data
  Future<void> refreshProfile() async {
    _setLoading(true);
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      _loadUserProfile();
      print('✅ Profile refreshed');
    } catch (e) {
      print('❌ Profile refresh failed: $e');
    } finally {
      _setLoading(false);
    }
  }
}
