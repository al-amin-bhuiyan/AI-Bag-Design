import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/api_response_model.dart';
import '../../models/reset_password_otp_model.dart';
import '../../models/reset_password_model.dart';
import '../../routes/app_path.dart';
import '../../services/auth_service.dart';

/// VerificationCodeController - Manages OTP verification for forgot password flow
/// POST /accounts/user/reset-password-otp/ → gets reset_token → navigate to set-new-password
/// Resend OTP → POST /accounts/user/send-reset-password-email/
/// Follows 100% OOP: encapsulation, single responsibility, composition
class VerificationCodeController extends GetxController {
  // ─── Dependencies ─────────────────────────────────────────────────────────
  final AuthService _authService = AuthService.instance;

  // ─── OTP Text Controllers ──────────────────────────────────────────────────
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

  // ─── Observable OTP digits ────────────────────────────────────────────────
  final RxString otp1 = ''.obs;
  final RxString otp2 = ''.obs;
  final RxString otp3 = ''.obs;
  final RxString otp4 = ''.obs;
  final RxString otp5 = ''.obs;
  final RxString otp6 = ''.obs;

  // ─── Observable State ─────────────────────────────────────────────────────
  final RxBool _isLoading = false.obs;
  final RxString _email = ''.obs;
  final RxInt _remainingSeconds = 60.obs;
  final RxBool _canResend = true.obs;
  Timer? _timer;

  // ─── Form ─────────────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── Public Getters ───────────────────────────────────────────────────────
  bool get isLoading => _isLoading.value;
  String get email => _email.value;
  bool get canResend => _canResend.value;
  int get remainingSeconds => _remainingSeconds.value;
  String get fullOtp =>
      '${otp1.value}${otp2.value}${otp3.value}${otp4.value}${otp5.value}${otp6.value}';
  String get timerText {
    final m = (_remainingSeconds.value ~/ 60).toString().padLeft(1, '0');
    final s = (_remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onClose() {
    _stopTimer();
    otp1Controller.dispose(); otp2Controller.dispose(); otp3Controller.dispose();
    otp4Controller.dispose(); otp5Controller.dispose(); otp6Controller.dispose();
    otp1FocusNode.dispose();  otp2FocusNode.dispose();  otp3FocusNode.dispose();
    otp4FocusNode.dispose();  otp5FocusNode.dispose();  otp6FocusNode.dispose();
    super.onClose();
  }

  // ─── Public API ───────────────────────────────────────────────────────────

  /// Sets email from route query parameter
  void setEmail(String email) {
    _email.value = email;
    debugPrint('📧 VerificationCode: email set — $email');
  }

  /// Handles single OTP field change — auto-moves focus
  void onOtpChanged(String value, int index, BuildContext context) {
    _updateOtpValue(value, index);
    if (value.isNotEmpty && index < 6) _focusNext(index);
    if (value.isEmpty && index > 1) _focusPrev(index);
  }

  /// Pastes OTP from clipboard
  Future<void> handlePasteFromClipboard(BuildContext context) async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final digits = (data?.text ?? '').replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.length < 6) { _showError('Invalid OTP format — need 6 digits'); return; }
      _fillAllOtpFields(digits);
      otp6FocusNode.requestFocus();
      _showInfo('Code pasted successfully');
    } catch (_) {
      _showError('Failed to paste code');
    }
  }

  /// Verifies OTP — calls POST /accounts/user/reset-password-otp/
  /// On success: navigates to SetNewPassword with reset_token
  Future<void> verifyCode(BuildContext context) async {
    if (fullOtp.length < 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }
    if (_email.value.isEmpty) {
      _showError('Email not found. Please go back and try again.');
      return;
    }

    _isLoading.value = true;
    try {
      debugPrint('🔐 Verifying reset OTP for: ${_email.value}');

      final ApiResponse<ResetPasswordOtpResponseModel> response =
          await _authService.verifyResetOtp(
        email: _email.value,
        otp: fullOtp,
      );

      if (response.success && response.data != null) {
        final String resetToken = response.data!.resetToken;
        debugPrint('✅ OTP verified — reset_token received');

        _showSuccess('OTP verified successfully!');
        await Future.delayed(const Duration(milliseconds: 600));

        if (context.mounted) {
          // Pass reset_token to set-new-password screen
          context.push(
            '${AppPath.setNewPassword}?reset_token=${Uri.encodeComponent(resetToken)}',
          );
        }
      } else {
        _showError(response.errorMessage ?? 'Invalid OTP. Please try again.');
      }
    } catch (e) {
      debugPrint('❌ Verify OTP error: $e');
      _showError('Verification failed. Please try again.');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Resends OTP — calls POST /accounts/user/send-reset-password-email/
  Future<void> resendCode(BuildContext context) async {
    if (!_canResend.value) {
      _showInfo('Please wait $timerText before resending');
      return;
    }
    if (_email.value.isEmpty) {
      _showError('Email not found. Please go back and try again.');
      return;
    }

    _startTimer();
    _isLoading.value = true;
    try {
      debugPrint('📨 Resending reset OTP to: ${_email.value}');

      final ApiResponse<SendResetPasswordEmailResponseModel> response =
          await _authService.sendResetPasswordEmail(email: _email.value);

      if (response.success && response.data != null) {
        _clearAllFields();
        _showSuccess(response.data!.message.isNotEmpty
            ? response.data!.message
            : 'OTP sent to your email');
        otp1FocusNode.requestFocus();
      } else {
        _showError(response.errorMessage ?? 'Failed to resend OTP. Try again.');
        _stopTimer();
        _canResend.value = true;
      }
    } catch (e) {
      debugPrint('❌ Resend OTP error: $e');
      _showError('Failed to resend OTP. Please try again.');
      _stopTimer();
      _canResend.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Navigates back
  void navigateBack(BuildContext context) {
    if (context.mounted) context.pop();
  }

  // ─── Private Helpers ──────────────────────────────────────────────────────

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

  void _focusNext(int i) {
    switch (i) {
      case 1: otp2FocusNode.requestFocus(); break;
      case 2: otp3FocusNode.requestFocus(); break;
      case 3: otp4FocusNode.requestFocus(); break;
      case 4: otp5FocusNode.requestFocus(); break;
      case 5: otp6FocusNode.requestFocus(); break;
    }
  }

  void _focusPrev(int i) {
    switch (i) {
      case 2: otp1FocusNode.requestFocus(); break;
      case 3: otp2FocusNode.requestFocus(); break;
      case 4: otp3FocusNode.requestFocus(); break;
      case 5: otp4FocusNode.requestFocus(); break;
      case 6: otp5FocusNode.requestFocus(); break;
    }
  }

  void _fillAllOtpFields(String digits) {
    final controllers = [otp1Controller, otp2Controller, otp3Controller,
                         otp4Controller, otp5Controller, otp6Controller];
    final observables = [otp1, otp2, otp3, otp4, otp5, otp6];
    for (int i = 0; i < 6; i++) {
      controllers[i].text = digits[i];
      observables[i].value = digits[i];
    }
  }

  void _clearAllFields() {
    for (final c in [otp1Controller, otp2Controller, otp3Controller,
                     otp4Controller, otp5Controller, otp6Controller]) {
      c.clear();
    }
    for (final o in [otp1, otp2, otp3, otp4, otp5, otp6]) {
      o.value = '';
    }
  }

  void _startTimer() {
    _remainingSeconds.value = 60;
    _canResend.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds.value > 0) {
        _remainingSeconds.value--;
      } else {
        _canResend.value = true;
        t.cancel();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  // ─── Toast Helpers ────────────────────────────────────────────────────────

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF44336),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }

  void _showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF2196F3),
      textColor: Colors.white,
      fontSize: 15.0,
    );
  }
}