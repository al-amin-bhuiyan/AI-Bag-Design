/// ApiResponse - Generic wrapper for all API responses
/// Provides a unified structure for success and error states
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorMessage;
  final int? statusCode;

  const ApiResponse._({
    required this.success,
    this.data,
    this.errorMessage,
    this.statusCode,
  });

  /// Factory constructor for successful response
  factory ApiResponse.success({required T data, int? statusCode}) {
    return ApiResponse._(
      success: true,
      data: data,
      statusCode: statusCode,
    );
  }

  /// Factory constructor for error response
  factory ApiResponse.error({
    required String message,
    int? statusCode,
  }) {
    final normalized = _normalizeMessage(message, statusCode: statusCode);
    return ApiResponse._(
      success: false,
      errorMessage: normalized,
      statusCode: statusCode,
    );
  }

  static String _normalizeMessage(String message, {int? statusCode}) {
    final raw = message.trim();
    if (raw.isEmpty) return 'Something went wrong. Please try again.';

    return raw;
  }

  /// Whether the response has data
  bool get hasData => data != null;

  @override
  String toString() =>
      'ApiResponse(success: $success, statusCode: $statusCode, error: $errorMessage)';
}