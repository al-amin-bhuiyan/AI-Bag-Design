import 'dart:io' as dart_io;
import '../models/api_response_model.dart';
import '../models/sign_up_request_model.dart';
import '../models/sign_up_response_model.dart';
import '../models/otp_verify_response_model.dart';
import '../models/resend_otp_response_model.dart';
import '../models/login_model.dart';
import '../models/user_profile_model.dart';
import '../models/update_profile_request_model.dart';
import '../models/change_password_model.dart';
import '../models/delete_account_model.dart';
import '../models/reset_password_model.dart';
import '../models/reset_password_otp_model.dart';
import '../models/set_new_password_model.dart';
import '../utils/app_constants.dart';
import 'api_service.dart';

/// AuthService - Handles all authentication-related API calls
/// Follows OOP principles: encapsulation, single responsibility, composition
class AuthService {
  // Private constructor - singleton pattern
  AuthService._();
  static final AuthService _instance = AuthService._();

  /// Singleton accessor
  static AuthService get instance => _instance;

  // Dependency: composed with ApiService
  final ApiService _apiService = ApiService.instance;

  // ─────────────────────────────────────────────────────────────────────────────
  // REGISTRATION
  // ─────────────────────────────────────────────────────────────────────────────

  /// Registers a new user
  /// POST /accounts/user/register/
  Future<ApiResponse<SignUpResponseModel>> register({
    required String name,
    required String email,
    required String password,
    required String password2,
  }) async {
    final request = SignUpRequestModel(
      email: email,
      name: name,
      password: password,
      password2: password2,
    );

    final response = await _apiService.post(
      endpoint: AppConstants.registerEndpoint,
      body: request.toJson(),
    );

    if (response.success && response.data != null) {
      try {
        final model = SignUpResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse registration response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Registration failed.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // OTP VERIFICATION (SIGNUP)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Verifies OTP after signup
  /// POST /accounts/user/verify-otp/
  /// Body:     { "email": "...", "otp": "427240" }
  /// Response: { "msg": "Account activated successfully", "token": {...}, "user": {...} }
  Future<ApiResponse<OtpVerifyResponseModel>> verifyOtpSignup({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.verifyOtpSignupEndpoint,
      body: {
        'email': email,
        'otp': otp,
      },
    );

    if (response.success && response.data != null) {
      try {
        final model = OtpVerifyResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse verification response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'OTP verification failed.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // RESEND OTP
  // ─────────────────────────────────────────────────────────────────────────────

  /// Resends OTP to email
  /// POST /accounts/user/resend-otp/
  /// Body:     { "email": "..." }
  /// Error:    { "errors": { "email": ["Account is already activated."] } }
  Future<ApiResponse<ResendOtpResponseModel>> resendOtp({
    required String email,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.resendOtpEndpoint,
      body: {'email': email},
    );

    if (response.success && response.data != null) {
      try {
        final model = ResendOtpResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse resend OTP response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to resend OTP.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FORGOT PASSWORD
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sends password reset OTP email
  /// POST /accounts/user/forgot-password/
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.forgotPasswordEndpoint,
      body: {'email': email},
    );
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SEND RESET PASSWORD EMAIL
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sends password reset OTP to email
  /// POST /accounts/user/send-reset-password-email/
  /// Body:     { "email": "..." }
  /// Response: { "msg": "Password Reset OTP send. Please check your Email" }
  Future<ApiResponse<SendResetPasswordEmailResponseModel>> sendResetPasswordEmail({
    required String email,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.sendResetPasswordEmailEndpoint,
      body: {'email': email},
    );

    if (response.success && response.data != null) {
      try {
        final model = SendResetPasswordEmailResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to send reset email. Please try again.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // OTP VERIFICATION (RESET PASSWORD)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Verifies reset password OTP and returns a reset_token
  /// POST /accounts/user/reset-password-otp/
  /// Body:     { "email": "...", "otp": "327899" }
  /// Response: { "reset_token": "23387a12-..." }
  Future<ApiResponse<ResetPasswordOtpResponseModel>> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.resetPasswordOtpEndpoint,
      body: {'email': email, 'otp': otp},
    );

    if (response.success && response.data != null) {
      try {
        final model = ResetPasswordOtpResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse OTP response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Invalid OTP. Please try again.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SET NEW PASSWORD
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sets a new password using the reset_token received after OTP verification
  /// POST /accounts/user/set-new-password/
  /// Body: { "reset_token": "...", "new_password": "...", "new_password2": "..." }
  /// Response: { "msg": "Password reset successfully" }
  Future<ApiResponse<SetNewPasswordResponseModel>> setNewPassword({
    required SetNewPasswordRequestModel request,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.setNewPasswordEndpoint,
      body: request.toJson(),
    );

    if (response.success && response.data != null) {
      try {
        final model = SetNewPasswordResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to reset password.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // OTP VERIFICATION (FORGOT PASSWORD) — legacy
  // ─────────────────────────────────────────────────────────────────────────────

  /// Verifies OTP for forgot password flow
  /// POST /accounts/user/verify-otp-forgot/
  Future<ApiResponse<Map<String, dynamic>>> verifyOtpForgot({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.verifyOtpForgotEndpoint,
      body: {
        'email': email,
        'otp': otp,
      },
    );
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // CHANGE PASSWORD
  // ─────────────────────────────────────────────────────────────────────────────

  /// Changes the authenticated user's password
  /// POST /accounts/user/change-password/
  /// Body:     { "current_password": "...", "new_password": "...", "confirm_new_password": "..." }
  /// Response: { "msg": "Password changed successfully" }
  /// Requires Bearer token in Authorization header
  Future<ApiResponse<ChangePasswordResponseModel>> changePassword({
    required String accessToken,
    required ChangePasswordRequestModel request,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.changePasswordEndpoint,
      body: request.toJson(),
      token: accessToken,
    );

    if (response.success && response.data != null) {
      try {
        final model = ChangePasswordResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Password changed but response could not be parsed.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to change password.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────────────────────────────────────────────

  /// Logs in with email and password
  /// POST /accounts/user/login/
  /// Body:     { "email": "...", "password": "..." }
  /// Response: { "access": "...", "refresh": "...", "user": {...} }
  Future<ApiResponse<LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(email: email, password: password);

    final response = await _apiService.post(
      endpoint: AppConstants.loginEndpoint,
      body: request.toJson(),
    );

    if (response.success && response.data != null) {
      try {
        final model = LoginResponseModel.fromJson(response.data!);
        if (model.accessToken.trim().isEmpty || model.refreshToken.trim().isEmpty) {
          final payload = response.data!;
          final message =
              (payload['detail'] ?? payload['message'] ?? payload['msg'] ?? payload['error'])
                  ?.toString() ??
              'Login failed. Check email and password.';
          return ApiResponse.error(
            message: message,
            statusCode: response.statusCode,
          );
        }
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse login response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Login failed. Check email and password.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN REFRESH
  // ─────────────────────────────────────────────────────────────────────────────

  /// Refreshes access token using refresh token
  /// POST /accounts/user/token/refresh/
  /// Body:     { "refresh": "..." }
  /// Response: { "access": "..." }
  Future<ApiResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.tokenRefreshEndpoint,
      body: {'refresh': refreshToken},
    );
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // TOKEN VERIFY
  // ─────────────────────────────────────────────────────────────────────────────

  /// Verifies if an access token is still valid
  /// POST /accounts/user/token/verify/
  Future<ApiResponse<Map<String, dynamic>>> verifyToken({
    required String token,
  }) async {
    final response = await _apiService.post(
      endpoint: AppConstants.tokenVerifyEndpoint,
      body: {'token': token},
    );
    return response;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // USER PROFILE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Fetches the authenticated user's profile
  /// GET /accounts/user/profile/
  /// Requires Bearer token in Authorization header
  Future<ApiResponse<UserProfileModel>> getProfile({
    required String accessToken,
  }) async {
    final response = await _apiService.get(
      endpoint: AppConstants.profileEndpoint,
      token: accessToken,
    );

    if (response.success && response.data != null) {
      try {
        final model = UserProfileModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse profile response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to load profile.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // DELETE ACCOUNT
  // ─────────────────────────────────────────────────────────────────────────────

  /// Deletes the authenticated user's account
  /// DELETE /accounts/user/delete-account/
  /// Requires Bearer token in Authorization header
  /// Response: { "msg": "Account satipog496@medevsa.com deleted successfully." }
  Future<ApiResponse<DeleteAccountResponseModel>> deleteAccount({
    required String accessToken,
  }) async {
    final response = await _apiService.delete(
      endpoint: AppConstants.deleteAccountEndpoint,
      token: accessToken,
    );

    if (response.success && response.data != null) {
      try {
        final model = DeleteAccountResponseModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        // Even if parsing fails, deletion was successful
        return ApiResponse.success(
          data: const DeleteAccountResponseModel(message: 'Account deleted successfully.'),
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to delete account.',
      statusCode: response.statusCode,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // UPDATE PROFILE
  // ─────────────────────────────────────────────────────────────────────────────

  /// Updates the authenticated user's profile
  /// PATCH /accounts/user/profile/
  /// - With image:    multipart/form-data (name, email, image file)
  /// - Without image: application/json    (name, email only)
  /// Response: { "id":4, "email":"...", "name":"...", "is_admin":false, "image":"..." }
  Future<ApiResponse<UserProfileModel>> updateProfile({
    required String accessToken,
    required UpdateProfileRequestModel request,
    dart_io.File? imageFile,
  }) async {
    ApiResponse<Map<String, dynamic>> response;

    if (imageFile != null) {
      response = await _apiService.patchMultipart(
        endpoint: AppConstants.profileEndpoint,
        fields: request.toFormFields(),
        imageFile: imageFile,
        imageFieldName: 'image',
        token: accessToken,
      );
    } else {
      response = await _apiService.patch(
        endpoint: AppConstants.profileEndpoint,
        body: request.toJson(),
        token: accessToken,
      );
    }

    if (response.success && response.data != null) {
      try {
        final model = UserProfileModel.fromJson(response.data!);
        return ApiResponse.success(data: model, statusCode: response.statusCode);
      } catch (e) {
        return ApiResponse.error(
          message: 'Failed to parse update response.',
          statusCode: response.statusCode,
        );
      }
    }

    return ApiResponse.error(
      message: response.errorMessage ?? 'Failed to update profile.',
      statusCode: response.statusCode,
    );
  }
}
