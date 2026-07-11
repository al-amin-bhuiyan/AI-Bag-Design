import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/api_response_model.dart';
import '../utils/app_constants.dart';
import '../routes/route_path.dart';
import '../routes/app_path.dart';
import 'auth_state_service.dart';
import 'token_storage_service.dart';

/// ApiService - Base HTTP service layer
/// Handles all raw HTTP requests with proper error handling
/// Follows OOP principles: encapsulation, single responsibility
class ApiService {
  // Private constructor - singleton pattern
  ApiService._();
  static final ApiService _instance = ApiService._();

  /// Singleton accessor
  static ApiService get instance => _instance;

  // HTTP client
  final http.Client _client = http.Client();
  int _requestCounter = 0;

  /// Builds full URL from endpoint
  Uri _buildUri(String endpoint) {
    return Uri.parse('${AppConstants.baseUrl}$endpoint');
  }

  /// Default headers for all requests
  Map<String, String> _defaultHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// POST request
  Future<ApiResponse<Map<String, dynamic>>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
    int? timeoutSeconds,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      final uri = _buildUri(endpoint);
      final headers = _defaultHeaders(token: token);
      final caller = _resolveCallerFrame();

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 POST → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📨 Headers: ${jsonEncode(_safeHeaders(headers))}');
      debugPrint('📤 Request Body: ${jsonEncode(body)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await _client
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(
            Duration(seconds: timeoutSeconds ?? AppConstants.connectTimeoutSeconds),
          );

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return post(
            endpoint: endpoint,
            body: body,
            token: newToken,
            timeoutSeconds: timeoutSeconds,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      debugPrint('❌ POST SocketException: No internet');
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } on HttpException {
      stopwatch.stop();
      debugPrint('❌ POST HttpException');
      return ApiResponse.error(
        message: 'Server error. Please try again.',
        statusCode: 0,
      );
    } on FormatException {
      stopwatch.stop();
      debugPrint('❌ POST FormatException');
      return ApiResponse.error(
        message: 'Invalid response from server.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      debugPrint('❌ POST Exception: $e');
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// GET request
  Future<ApiResponse<Map<String, dynamic>>> get({
    required String endpoint,
    String? token,
    Map<String, String>? queryParams,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      var uri = _buildUri(endpoint);
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }
      final headers = _defaultHeaders(token: token);
      final caller = _resolveCallerFrame();

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 GET → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📨 Headers: ${jsonEncode(_safeHeaders(headers))}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await _client
          .get(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return get(
            endpoint: endpoint,
            token: newToken,
            queryParams: queryParams,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// PATCH request — JSON body (name, email only)
  Future<ApiResponse<Map<String, dynamic>>> patch({
    required String endpoint,
    required Map<String, dynamic> body,
    String? token,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      final uri = _buildUri(endpoint);
      final headers = _defaultHeaders(token: token);
      final caller = _resolveCallerFrame();

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 PATCH → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📨 Headers: ${jsonEncode(_safeHeaders(headers))}');
      debugPrint('📤 Request Body: ${jsonEncode(body)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await _client
          .patch(uri, headers: headers, body: jsonEncode(body))
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return patch(
            endpoint: endpoint,
            body: body,
            token: newToken,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// PATCH multipart request — for profile update with image file
  /// Sends name/email as form fields and image as file
  Future<ApiResponse<Map<String, dynamic>>> patchMultipart({
    required String endpoint,
    required Map<String, String> fields,
    File? imageFile,
    String imageFieldName = 'image',
    String? token,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest('PATCH', uri);
      final caller = _resolveCallerFrame();

      // Authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Text fields (name, email)
      request.fields.addAll(fields);

      // Image file (optional)
      if (imageFile != null) {
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        final multipartFile = http.MultipartFile(
          imageFieldName,
          stream,
          length,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 PATCH multipart → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📤 Fields: $fields');
      debugPrint('📤 Has Image: ${imageFile != null}');
      if (imageFile != null) {
        debugPrint('📤 Image Name: ${imageFile.path.split('/').last}');
        debugPrint('📤 Image Path: ${imageFile.path}');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return patchMultipart(
            endpoint: endpoint,
            fields: fields,
            imageFile: imageFile,
            imageFieldName: imageFieldName,
            token: newToken,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// POST multipart request — standardizes post requests with files
  Future<ApiResponse<Map<String, dynamic>>> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    File? imageFile,
    String imageFieldName = 'image',
    String? token,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      final uri = _buildUri(endpoint);
      final request = http.MultipartRequest('POST', uri);
      final caller = _resolveCallerFrame();

      // Authorization header
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // Text fields
      request.fields.addAll(fields);

      // Image file (optional)
      if (imageFile != null) {
        final stream = http.ByteStream(imageFile.openRead());
        final length = await imageFile.length();
        final multipartFile = http.MultipartFile(
          imageFieldName,
          stream,
          length,
          filename: imageFile.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 POST multipart → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📤 Fields: $fields');
      debugPrint('📤 Has Image: ${imageFile != null}');
      if (imageFile != null) {
        debugPrint('📤 Image Name: ${imageFile.path.split('/').last}');
        debugPrint('📤 Image Path: ${imageFile.path}');
      }
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));
      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return postMultipart(
            endpoint: endpoint,
            fields: fields,
            imageFile: imageFile,
            imageFieldName: imageFieldName,
            token: newToken,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// DELETE request — with optional Bearer token
  Future<ApiResponse<Map<String, dynamic>>> delete({
    required String endpoint,
    String? token,
    bool isRetry = false,
  }) async {
    final requestId = ++_requestCounter;
    final stopwatch = Stopwatch()..start();
    try {
      final uri = _buildUri(endpoint);
      final headers = _defaultHeaders(token: token);
      final caller = _resolveCallerFrame();

      debugPrint('');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('🆔 Request #$requestId');
      debugPrint('📁 File: lib/services/api_service.dart');
      debugPrint('📍 Caller: $caller');
      debugPrint('🌐 DELETE → $uri');
      debugPrint('🔑 Token: ${token != null && token.isNotEmpty ? 'Bearer ${token.substring(0, token.length.clamp(0, 20))}...' : 'None'}');
      debugPrint('📨 Headers: ${jsonEncode(_safeHeaders(headers))}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      final response = await _client
          .delete(uri, headers: headers)
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));

      stopwatch.stop();
      debugPrint('📥 Status: ${response.statusCode}');
      debugPrint('📥 Response Body: ${response.body}');
      debugPrint('⏱️ Duration: ${stopwatch.elapsedMilliseconds}ms');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('');

      // Check for 401 and try auto refresh
      if (response.statusCode == 401 && !isRetry && !_isAuthEndpoint(endpoint)) {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry request with new token
          return delete(
            endpoint: endpoint,
            token: newToken,
            isRetry: true,
          );
        } else {
          // Refresh failed, log out user
          await _forceLogout();
        }
      }

      return _handleResponse(response);
    } on SocketException {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'No internet connection. Please check your network.',
        statusCode: 0,
      );
    } catch (e) {
      stopwatch.stop();
      return ApiResponse.error(
        message: 'Something went wrong: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Handles HTTP response and converts to ApiResponse
  ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final trimmedBody = response.body.trim();
      final Map<String, dynamic> data;
      if (trimmedBody.isEmpty) {
        data = <String, dynamic>{};
      } else {
        final decoded = jsonDecode(trimmedBody);
        data = decoded is Map<String, dynamic>
            ? decoded
            : <String, dynamic>{'data': decoded};
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse.success(data: data, statusCode: response.statusCode);
      } else {
        // Extract error message from response
        final errorMsg = _extractErrorMessage(data, response.statusCode);
        return ApiResponse.error(message: errorMsg, statusCode: response.statusCode);
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Failed to parse response.',
        statusCode: response.statusCode,
      );
    }
  }

  /// Extracts human-readable error message from API error response
  /// Handles: flat errors, nested "errors" object, list errors, non_field_errors
  String _extractErrorMessage(Map<String, dynamic> data, int statusCode) {
    // Try common top-level keys
    if (data.containsKey('detail')) return data['detail'].toString();
    if (data.containsKey('message')) return data['message'].toString();
    if (data.containsKey('msg')) return data['msg'].toString();
    if (data.containsKey('error')) return data['error'].toString();

    // Handle non_field_errors list
    if (data.containsKey('non_field_errors')) {
      final errors = data['non_field_errors'];
      if (errors is List && errors.isNotEmpty) return errors.first.toString();
    }

    // Handle nested "errors" object: { "errors": { "email": ["Account is already activated."] } }
    if (data.containsKey('errors')) {
      final errorsObj = data['errors'];
      if (errorsObj is Map<String, dynamic>) {
        for (final key in errorsObj.keys) {
          final value = errorsObj[key];
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value is String) return value;
        }
      }
      if (errorsObj is String) return errorsObj;
    }

    // Try field-level errors (e.g., {"email": ["This field is required."]})
    for (final key in data.keys) {
      final value = data[key];
      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }
      if (value is String && key != 'msg') {
        return value;
      }
    }

    return 'Request failed with status $statusCode';
  }

  /// Refreshes the access token using the stored refresh token
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await TokenStorageService.instance.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return null;

      final uri = _buildUri(AppConstants.tokenRefreshEndpoint);
      final headers = _defaultHeaders();
      final body = jsonEncode({'refresh': refreshToken});

      final response = await _client
          .post(uri, headers: headers, body: body)
          .timeout(Duration(seconds: AppConstants.connectTimeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final newAccessToken = decoded['access']?.toString() ?? decoded['access_token']?.toString();
          final newRefreshToken = decoded['refresh']?.toString() ?? decoded['refresh_token']?.toString();
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await TokenStorageService.instance.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken ?? refreshToken,
            );
            return newAccessToken;
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Auto-token refresh failed: $e');
    }
    return null;
  }

  /// Checks if the endpoint is an authentication endpoint that shouldn't auto-refresh tokens
  bool _isAuthEndpoint(String endpoint) {
    return endpoint == AppConstants.registerEndpoint ||
        endpoint == AppConstants.verifyOtpSignupEndpoint ||
        endpoint == AppConstants.loginEndpoint ||
        endpoint == AppConstants.forgotPasswordEndpoint ||
        endpoint == AppConstants.sendResetPasswordEmailEndpoint ||
        endpoint == AppConstants.resetPasswordOtpEndpoint ||
        endpoint == AppConstants.setNewPasswordEndpoint ||
        endpoint == AppConstants.verifyOtpForgotEndpoint ||
        endpoint == AppConstants.resendOtpEndpoint ||
        endpoint == AppConstants.tokenRefreshEndpoint ||
        endpoint == AppConstants.tokenVerifyEndpoint;
  }

  /// Forces user logout, clears stored tokens, and redirects to login screen
  Future<void> _forceLogout() async {
    try {
      debugPrint('🚨 Force logout: Session expired and token refresh failed.');
      await TokenStorageService.instance.clearAll();
      AuthStateService.instance.reset(); // clear cached auth state
      AuthStateService.instance.setUnauthenticated();
      
      // Navigate to login screen
      RoutePath.router.go(AppPath.login);
    } catch (e) {
      debugPrint('❌ Error during force logout: $e');
    }
  }

  /// Dispose HTTP client
  void dispose() {
    _client.close();
  }

  Map<String, String> _safeHeaders(Map<String, String> headers) {
    final safe = Map<String, String>.from(headers);
    if (safe.containsKey('Authorization')) {
      safe['Authorization'] = 'Bearer ***';
    }
    return safe;
  }

  String _resolveCallerFrame() {
    final frames = StackTrace.current.toString().split('\n');
    for (final frame in frames) {
      if (frame.contains('api_service.dart')) continue;
      if (frame.contains('.dart')) return frame.trim();
    }
    return 'unknown-caller';
  }
}
