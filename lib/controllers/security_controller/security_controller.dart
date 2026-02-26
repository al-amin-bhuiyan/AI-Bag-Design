import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// SecurityController - Manages security screen state and business logic
/// Follows OOP principles with encapsulation and separation of concerns
class SecurityController extends GetxController {
  // ============ Observables ============
  
  final RxBool isLoading = false.obs;
  final RxBool isDeletingAccount = false.obs;

  // ============ Lifecycle Methods ============
  
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // ============ Private Methods ============
  
  /// Sets loading state
  void _setLoading(bool value) {
    isLoading.value = value;
  }

  /// Sets delete account loading state
  void _setDeletingAccount(bool value) {
    isDeletingAccount.value = value;
  }

  // ============ Public Methods ============
  
  /// Navigates to change password screen
  void navigateToChangePassword(BuildContext context) {
    context.push('/change-password');
    print('🔵 Navigate to Change Password');
  }

  /// Shows delete account confirmation dialog
  Future<void> showDeleteAccountDialog(BuildContext context) async {
    // This will be called from the UI to show the dialog
    print('🔵 Show Delete Account Dialog');
  }

  /// Handles account deletion
  Future<void> deleteAccount() async {
    _setDeletingAccount(true);
    
    try {
      // TODO: Implement account deletion API call
      await Future.delayed(const Duration(seconds: 2));
      
      print('✅ Account deleted successfully');
      // Navigate to login or splash screen after deletion
      
    } catch (e) {
      print('❌ Error deleting account: $e');
      // Show error message
    } finally {
      _setDeletingAccount(false);
    }
  }
}
