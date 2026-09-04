import 'package:dio/dio.dart';

/// API failure mapped from the shared backend error envelope.
///
/// Accepts both the ticket contract `{ "code", "message" }` and the backend
/// wrapper `{ "error": { "code", "message" } }` so the client stays compatible
/// when WARDROBE-5 lands.
class ApiException implements Exception {
  const ApiException({required this.message, this.code, this.statusCode});

  final String message;
  final String? code;
  final int? statusCode;

  /// Maps a [DioException] into a user-facing [ApiException].
  factory ApiException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final parsed = parseErrorEnvelope(error.response?.data);
    if (parsed != null) {
      return ApiException(
        message: parsed.message,
        code: parsed.code,
        statusCode: statusCode,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return ApiException(
          message: 'Request timed out. Please try again.',
          code: 'TIMEOUT',
          statusCode: statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Unable to reach the server. Check your connection.',
          code: 'NETWORK_ERROR',
          statusCode: statusCode,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Request failed. Please try again.',
          code: 'BAD_RESPONSE',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled.',
          code: 'CANCELLED',
          statusCode: statusCode,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return ApiException(
          message: 'Something went wrong. Please try again.',
          code: 'UNKNOWN',
          statusCode: statusCode,
        );
    }
  }

  @override
  String toString() => 'ApiException($code, $statusCode, $message)';
}

/// Parsed `{ code, message }` pair from an API error body.
class ApiErrorEnvelope {
  const ApiErrorEnvelope({required this.message, this.code});

  final String message;
  final String? code;
}

/// Extracts `{ code, message }` from a flat or nested error payload.
ApiErrorEnvelope? parseErrorEnvelope(dynamic data) {
  if (data is! Map) {
    return null;
  }
  final map = Map<String, dynamic>.from(data);

  final nested = map['error'];
  if (nested is Map) {
    final fromNested = _envelopeFromMap(Map<String, dynamic>.from(nested));
    if (fromNested != null) {
      return fromNested;
    }
  }

  return _envelopeFromMap(map);
}

ApiErrorEnvelope? _envelopeFromMap(Map<String, dynamic> map) {
  final code = map['code'];
  final message = map['message'];
  if (code is! String && message is! String) {
    return null;
  }
  return ApiErrorEnvelope(
    code: code is String ? code : null,
    message: message is String ? message : 'Request failed.',
  );
}
