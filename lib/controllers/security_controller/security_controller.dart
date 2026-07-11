import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/delete_account_model.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/auth_state_service.dart';
import '../../services/session_data_isolation_service.dart';
import '../../services/token_storage_service.dart';
import '../../services/user_session_service.dart';
import '../../widgets/dialogs/delete_account_dialog.dart';
/// SecurityController - Manages security screen state and business logic
/// Calls real DELETE /accounts/user/delete-account/ API with Bearer token
/// Shows Fluttertoast for success and error responses
/// Follows 100% OOP: encapsulation, single responsibility, composition
class SecurityController extends GetxController {
  // Dependencies
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;
  // Observable State
  final RxBool isLoading         = false.obs;
  final RxBool isDeletingAccount = false.obs;
  // Navigation
  void navigateToChangePassword(BuildContext context) =>
      context.push(AppPath.changePassword);
  // Delete Account
  /// Shows delete account confirmation dialog
  /// Passes screen-level context into callback so navigation works after dialog closes
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => DeleteAccountDialog(
        onConfirm: () async {
          Navigator.of(dialogContext).pop();
          await _performDeleteAccount(context);
        },
      ),
    );
  }
  /// Calls DELETE /accounts/user/delete-account/ with Bearer token
  /// On success: clears all local data (full logout) then navigates to login
  /// If session already expired (no token): goes to login directly
  Future<void> _performDeleteAccount(BuildContext context) async {
    isDeletingAccount.value = true;
    try {
      final String? accessToken = await _tokenStorage.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        _showError('Session expired. Please log in again.');
        // Clear any stale data and go to login
        await _tokenStorage.clearAll();
        SessionDataIsolationService.instance.clearUserScopedState();
        AuthStateService.instance.setUnauthenticated();
        if (context.mounted) context.go(AppPath.login);
        return;
      }
      debugPrint('Deleting account...');
      final ApiResponse<DeleteAccountResponseModel> response =
          await _authService.deleteAccount(accessToken: accessToken);
      if (response.success) {
        debugPrint('✅ Account deleted from API');

        // Clear all session state
        UserSessionService.instance.clear();
        SessionDataIsolationService.instance.clearUserScopedState();
        AuthStateService.instance.setUnauthenticated();
        await _tokenStorage.clearAll(isManualLogout: true);

        Fluttertoast.showToast(msg: 'Account deleted successfully.');
      } else {
        _showError(response.errorMessage ??
            'Failed to delete account. Please try again.');
      }
    } catch (e) {
      debugPrint('Error Delete account: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isDeletingAccount.value = false;
    }
  }
  // Toast Helpers
  void _showError(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        textColor: Colors.white,
        fontSize: 15.0,
      );
  void _showSuccess(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        textColor: Colors.white,
        fontSize: 15.0,
      );
}
