import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';
import '../../services/auth_state_service.dart';
import '../../services/token_storage_service.dart';
import '../../models/api_response_model.dart';
import '../../models/otp_verify_response_model.dart';
import '../../models/resend_otp_response_model.dart';

/// VerificationCodeControllerfromSignup manages OTP verification logic after signup
/// Calls real APIs, saves JWT tokens, then navigates to Create screen
/// Follows 100% OOP principles: encapsulation, single responsibility, composition
class VerificationCodeControllerfromSignup extends GetxController {
  // ─── Dependencies (Composition) ───────────────────────────────────────────
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  // ─── Text Editing Controllers ─────────────────────────────────────────────
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  final TextEditingController otp5Controller = TextEditingController();
  final TextEditingController otp6Controller = TextEditingController();

  // ─── Focus Nodes ──────────────────────────────────────────────────────────
  final FocusNode otp1FocusNode = FocusNode();
  final FocusNode otp2FocusNode = FocusNode();
  final FocusNode otp3FocusNode = FocusNode();
  final FocusNode otp4FocusNode = FocusNode();
  final FocusNode otp5FocusNode = FocusNode();
  final FocusNode otp6FocusNode = FocusNode();

  // ─── Observable OTP digit state ───────────────────────────────────────────
  final RxString otp1 = ''.obs;
  final RxString otp2 = ''.obs;
  final RxString otp3 = ''.obs;
  final RxString otp4 = ''.obs;
  final RxString otp5 = ''.obs;
  final RxString otp6 = ''.obs;

  // ─── Observable state ────────────────────────────────────────────────────
  final RxBool _isLoading = false.obs;
  final RxString _email = ''.obs;

  // ─── Timer state ──────────────────────────────────────────────────────────
  final RxInt _remainingSeconds = 60.obs;
  final RxBool _canResend = true.obs;
  Timer? _timer;

  // ─── Form key ─────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Public Getters ───────────────────────────────────────────────────────
  bool get isLoading => _isLoading.value;
  String get email => _email.value;
  String get fullOtp =>
      '${otp1.value}${otp2.value}${otp3.value}${otp4.value}${otp5.value}${otp6.value}';
  int get remainingSeconds => _remainingSeconds.value;
  bool get canResend => _canResend.value;
  String get timerText {
    final minutes = (_remainingSeconds.value ~/ 60).toString().padLeft(1, '0');
    final seconds = (_remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onClose() {
    _disposeResources();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Sets email passed from signup route parameter
  void setEmail(String email) {
    _email.value = email;
    debugPrint('📧 OTP screen email set: $email');
  }

  /// Handles single OTP field change — auto-focuses next/prev field
  void onOtpChanged(String value, int index, BuildContext context) {
    _updateOtpValue(value, index);
    if (value.isNotEmpty && index < 6) _focusNextField(index);
    if (value.isEmpty && index > 1) _focusPreviousField(index);
  }

  /// Handles paste from clipboard — fills all 6 OTP digits at once
  Future<void> handlePasteFromClipboard(BuildContext context) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final pastedText = clipboardData?.text ?? '';
      if (pastedText.isEmpty) {
        _showInfo('Clipboard is empty');
        return;
      }
      final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length < 6) {
        _showError('Invalid OTP format — need 6 digits');
        return;
      }
      _fillAllOtpFields(digits);
      otp6FocusNode.requestFocus();
      _showInfo('Code pasted successfully');
    } catch (e) {
      _showError('Failed to paste code');
    }
  }

  /// Verifies OTP with real API call
  /// On success: saves JWT tokens + user info, then navigates to Create screen
  Future<void> verifyCode(BuildContext context) async {
    if (fullOtp.length < 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }
    if (_email.value.isEmpty) {
      _showError('Email not found. Please go back and try again.');
      return;
    }

    _setLoading(true);
    try {
      debugPrint('🔐 Verifying OTP for: ${_email.value}');

      final ApiResponse<OtpVerifyResponseModel> response =
          await _authService.verifyOtpSignup(
        email: _email.value,
        otp: fullOtp,
      );

      if (response.success && response.data != null) {
        final OtpVerifyResponseModel data = response.data!;
        debugPrint('✅ ${data.message}');
        debugPrint('👤 User: ${data.user.name} (${data.user.email})');
        debugPrint('🔑 Access token received');

        // Save JWT tokens and user info persistently
        await _tokenStorage.saveTokens(
          accessToken: data.token.access,
          refreshToken: data.token.refresh,
        );
        await _tokenStorage.saveUserInfo(
          id: data.user.id,
          email: data.user.email,
          name: data.user.name,
        );

        // Mark auth state as authenticated so next app start goes to home
        AuthStateService.instance.setAuthenticated();

        _showSuccess(data.message.isNotEmpty
            ? data.message
            : 'Email verified successfully! Welcome aboard 🎉');

        // Small delay so toast is visible
        await Future.delayed(const Duration(milliseconds: 700));

        // Navigate to Terms and Conditions (onboarding) screen
        if (context.mounted) {
          context.go('${AppPath.termsAndConditions}?onboarding=true');
        }
      } else {
        _showError(
            response.errorMessage ?? 'Invalid verification code. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ OTP verify error: $e');
      _showError('Verification failed. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// Resends OTP to user's email with real API call
  Future<void> resendCode(BuildContext context) async {
    if (!_canResend.value) {
      _showInfo('Please wait $timerText before resending');
      return;
    }
    if (_email.value.isEmpty) {
      _showError('Email not found. Please go back and try again.');
      return;
    }

    // Start countdown timer immediately
    _startTimer();
    _setLoading(true);

    try {
      debugPrint('📨 Resending OTP to: ${_email.value}');

      final ApiResponse<ResendOtpResponseModel> response =
          await _authService.resendOtp(email: _email.value);

      if (response.success && response.data != null) {
        final ResendOtpResponseModel data = response.data!;
        _clearAllFields();
        _showSuccess(data.message.isNotEmpty
            ? data.message
            : 'Verification code sent to your email');
        otp1FocusNode.requestFocus();
      } else {
        _showError(response.errorMessage ?? 'Failed to resend code. Please try again.');
        // Stop timer and allow retry on failure
        _stopTimer();
        _canResend.value = true;
      }
    } catch (e) {
      debugPrint('❌ Resend OTP error: $e');
      _showError('Failed to resend code. Please try again.');
      _stopTimer();
      _canResend.value = true;
    } finally {
      _setLoading(false);
    }
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) context.pop();
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

  /// Updates the observable for a specific OTP index
  void _updateOtpValue(String value, int index) {
    switch (index) {
      case 1: otp1.value = value; break;
      case 2: otp2.value = value; break;
      case 3: otp3.value = value; break;
      case 4: otp4.value = value; break;
      case 5: otp5.value = value; break;
      case 6: otp6.value = value; break;
    }
  }

  /// Moves focus to next OTP field
  void _focusNextField(int currentIndex) {
    switch (currentIndex) {
      case 1: otp2FocusNode.requestFocus(); break;
      case 2: otp3FocusNode.requestFocus(); break;
      case 3: otp4FocusNode.requestFocus(); break;
      case 4: otp5FocusNode.requestFocus(); break;
      case 5: otp6FocusNode.requestFocus(); break;
    }
  }

  /// Moves focus to previous OTP field
  void _focusPreviousField(int currentIndex) {
    switch (currentIndex) {
      case 2: otp1FocusNode.requestFocus(); break;
      case 3: otp2FocusNode.requestFocus(); break;
      case 4: otp3FocusNode.requestFocus(); break;
      case 5: otp4FocusNode.requestFocus(); break;
      case 6: otp5FocusNode.requestFocus(); break;
    }
  }

  /// Fills all 6 OTP fields from a digit string (e.g., from clipboard paste)
  void _fillAllOtpFields(String digits) {
    otp1Controller.text = digits[0]; otp1.value = digits[0];
    otp2Controller.text = digits[1]; otp2.value = digits[1];
    otp3Controller.text = digits[2]; otp3.value = digits[2];
    otp4Controller.text = digits[3]; otp4.value = digits[3];
    otp5Controller.text = digits[4]; otp5.value = digits[4];
    otp6Controller.text = digits[5]; otp6.value = digits[5];
  }

  /// Clears all OTP text fields and observable values
  void _clearAllFields() {
    otp1Controller.clear(); otp2Controller.clear();
    otp3Controller.clear(); otp4Controller.clear();
    otp5Controller.clear(); otp6Controller.clear();
    otp1.value = ''; otp2.value = ''; otp3.value = '';
    otp4.value = ''; otp5.value = ''; otp6.value = '';
  }

  /// Starts the 60-second resend countdown timer
  void _startTimer() {
    _remainingSeconds.value = 60;
    _canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        _canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Cancels the countdown timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _setLoading(bool value) => _isLoading.value = value;

  // ─── Toast Helpers ────────────────────────────────────────────────────────

  /// Shows a red error toast
  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  /// Shows a green success toast
  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  /// Shows a blue info toast
  void _showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  // ─── Dispose ──────────────────────────────────────────────────────────────

  /// Disposes all controllers, focus nodes, and timers
  void _disposeResources() {
    _stopTimer();
    otp1Controller.dispose(); otp2Controller.dispose();
    otp3Controller.dispose(); otp4Controller.dispose();
    otp5Controller.dispose(); otp6Controller.dispose();
    otp1FocusNode.dispose(); otp2FocusNode.dispose();
    otp3FocusNode.dispose(); otp4FocusNode.dispose();
    otp5FocusNode.dispose(); otp6FocusNode.dispose();
  }
}