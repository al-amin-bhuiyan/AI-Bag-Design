import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_path.dart';

/// VerificationCodeController manages verification code screen logic and state
/// Follows OOP principles with encapsulation and single responsibility
class VerificationCodeController extends GetxController {
  // Text editing controllers for 6 OTP fields
  final TextEditingController otp1Controller = TextEditingController();
  final TextEditingController otp2Controller = TextEditingController();
  final TextEditingController otp3Controller = TextEditingController();
  final TextEditingController otp4Controller = TextEditingController();
  final TextEditingController otp5Controller = TextEditingController();
  final TextEditingController otp6Controller = TextEditingController();

  // Focus nodes for 6 OTP fields
  final FocusNode otp1FocusNode = FocusNode();
  final FocusNode otp2FocusNode = FocusNode();
  final FocusNode otp3FocusNode = FocusNode();
  final FocusNode otp4FocusNode = FocusNode();
  final FocusNode otp5FocusNode = FocusNode();
  final FocusNode otp6FocusNode = FocusNode();

  // Observable state for each OTP field
  final RxString otp1 = ''.obs;
  final RxString otp2 = ''.obs;
  final RxString otp3 = ''.obs;
  final RxString otp4 = ''.obs;
  final RxString otp5 = ''.obs;
  final RxString otp6 = ''.obs;

  // Observable state
  final RxBool _isLoading = false.obs;
  final RxString _email = ''.obs;
  
  // Timer state
  final RxInt _remainingSeconds = 60.obs;
  final RxBool _canResend = true.obs; // Start as true - can resend immediately
  Timer? _timer;

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Getters
  bool get isLoading => _isLoading.value;
  String get email => _email.value;
  String get fullOtp => '${otp1.value}${otp2.value}${otp3.value}${otp4.value}${otp5.value}${otp6.value}';
  int get remainingSeconds => _remainingSeconds.value;
  bool get canResend => _canResend.value;
  String get timerText {
    final minutes = (_remainingSeconds.value ~/ 60).toString().padLeft(1, '0');
    final seconds = (_remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  /// Initializes the controller
  void _initializeController() {
    // Load email from previous screen or storage
    _loadEmail();
    // Timer will start only when user presses resend
  }

  /// Loads email from storage or previous screen
  void _loadEmail() {
    // TODO: Get email from forgot password screen or shared preferences
    // For now, using a placeholder
    _email.value = 'mu***@gmail.com';
  }

  /// Starts the resend countdown timer
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

  /// Stops the timer
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Sets email from route parameter
  void setEmail(String email) {
    _email.value = email;
  }

  /// Handles OTP field change
  void onOtpChanged(String value, int index, BuildContext context) {
    // Update corresponding observable
    switch (index) {
      case 1:
        otp1.value = value;
        break;
      case 2:
        otp2.value = value;
        break;
      case 3:
        otp3.value = value;
        break;
      case 4:
        otp4.value = value;
        break;
      case 5:
        otp5.value = value;
        break;
      case 6:
        otp6.value = value;
        break;
    }

    // Auto-focus next field if value entered
    if (value.isNotEmpty && index < 6) {
      _focusNextField(index);
    }
    
    // Auto-focus previous field if backspace
    if (value.isEmpty && index > 1) {
      _focusPreviousField(index);
    }
  }

  /// Focuses next OTP field
  void _focusNextField(int currentIndex) {
    switch (currentIndex) {
      case 1:
        otp2FocusNode.requestFocus();
        break;
      case 2:
        otp3FocusNode.requestFocus();
        break;
      case 3:
        otp4FocusNode.requestFocus();
        break;
      case 4:
        otp5FocusNode.requestFocus();
        break;
      case 5:
        otp6FocusNode.requestFocus();
        break;
    }
  }

  /// Focuses previous OTP field
  void _focusPreviousField(int currentIndex) {
    switch (currentIndex) {
      case 2:
        otp1FocusNode.requestFocus();
        break;
      case 3:
        otp2FocusNode.requestFocus();
        break;
      case 4:
        otp3FocusNode.requestFocus();
        break;
      case 5:
        otp4FocusNode.requestFocus();
        break;
      case 6:
        otp5FocusNode.requestFocus();
        break;
    }
  }

  /// Handles paste from clipboard
  Future<void> handlePasteFromClipboard(BuildContext context) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final pastedText = clipboardData?.text ?? '';

      if (pastedText.isEmpty) {
        _showMessage('Clipboard is empty');
        return;
      }

      // Extract only digits
      final digits = pastedText.replaceAll(RegExp(r'[^0-9]'), '');

      if (digits.length < 6) {
        _showMessage('Invalid code format');
        return;
      }

      // Fill OTP fields
      otp1Controller.text = digits[0];
      otp1.value = digits[0];

      otp2Controller.text = digits[1];
      otp2.value = digits[1];

      otp3Controller.text = digits[2];
      otp3.value = digits[2];

      otp4Controller.text = digits[3];
      otp4.value = digits[3];

      otp5Controller.text = digits[4];
      otp5.value = digits[4];

      otp6Controller.text = digits[5];
      otp6.value = digits[5];

      // Focus last field
      otp6FocusNode.requestFocus();

      _showMessage('Code pasted successfully');
    } catch (e) {
      _showMessage('Failed to paste code');
    }
  }

  /// Verifies the OTP code
  Future<void> verifyCode(BuildContext context) async {
    // Check if all fields are filled
    if (fullOtp.length < 6) {
      _showMessage('Please enter complete 6-digit code');
      return;
    }

    _setLoading(true);

    try {
      // Simulate API call
    //await _verifyOtpCode(fullOtp);

      if (context.mounted) {
        _showMessage('Code verified successfully!');
        // Navigate to change password screen
        context.push(AppPath.changePassword);
      }
    } catch (e) {
      _showMessage('Invalid verification code. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  /// API call to verify OTP code (placeholder)
  Future<void> _verifyOtpCode(String code) async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate verification
    if (code != '554000') { // Just for testing
      throw Exception('Invalid code');
    }
  }

  /// Resends verification code
  Future<void> resendCode(BuildContext context) async {
    if (!_canResend.value) {
      _showMessage('Please wait ${timerText} before resending');
      return;
    }

    // Start timer immediately
    _startTimer();
    
    _setLoading(true);

    try {
      // Simulate API call
      await _resendOtpCode();

      // Clear all fields
      _clearAllFields();

      _showMessage('Verification code sent to your email');
      
      // Focus first field
      otp1FocusNode.requestFocus();
    } catch (e) {
      _showMessage('Failed to resend code. Please try again.');
      // If failed, stop timer and allow retry
      _stopTimer();
      _canResend.value = true;
    } finally {
      _setLoading(false);
    }
  }

  /// API call to resend OTP code (placeholder)
  Future<void> _resendOtpCode() async {
    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
  }

  /// Clears all OTP fields
  void _clearAllFields() {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();

    otp1.value = '';
    otp2.value = '';
    otp3.value = '';
    otp4.value = '';
    otp5.value = '';
    otp6.value = '';
  }

  /// Sets loading state
  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  /// Shows a message to the user
  void _showMessage(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  /// Navigates back to previous screen
  void navigateBack(BuildContext context) {
    if (context.mounted) {
      context.pop();
    }
  }

  /// Disposes all controllers and focus nodes
  void _disposeControllers() {
    // Cancel timer
    _stopTimer();
    
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();

    otp1FocusNode.dispose();
    otp2FocusNode.dispose();
    otp3FocusNode.dispose();
    otp4FocusNode.dispose();
    otp5FocusNode.dispose();
    otp6FocusNode.dispose();
  }
}
