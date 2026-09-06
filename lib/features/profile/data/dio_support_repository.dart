import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/support_repository.dart';
import 'support_dtos.dart';

/// Dio implementation of [SupportRepository] against `/support/*`.
///
/// Flutter never talks to Resend and never opens mailto. Email delivery is
/// owned by Backend WARDROBE-38.
class DioSupportRepository implements SupportRepository {
  DioSupportRepository(this._dio);

  final Dio _dio;

  static const contactPath = '/support/contact';
  static const bugPath = '/support/bug';

  @override
  Future<void> sendContact({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  }) {
    return _post(
      contactPath,
      SupportRequest(
        subject: subject,
        message: message,
        device: device,
        appVersion: appVersion,
      ),
    );
  }

  @override
  Future<void> sendBug({
    required String subject,
    required String message,
    String? device,
    String? appVersion,
  }) {
    return _post(
      bugPath,
      SupportRequest(
        subject: subject,
        message: message,
        device: device,
        appVersion: appVersion,
      ),
    );
  }

  Future<void> _post(String path, SupportRequest request) {
    return _guard(() async {
      await _dio.post<dynamic>(path, data: request.toJson());
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

/// Default [SupportRepository] using the shared authenticated Dio client.
final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return DioSupportRepository(ref.watch(dioProvider));
});
