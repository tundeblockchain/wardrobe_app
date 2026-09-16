import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entitlement.dart';
import '../domain/entitlement_repository.dart';
import '../domain/entitlement_wire.dart';

/// `GET /me` — locked WARDROBE-91 entitlement read (wardrobe-backend#46 `a837463`).
class DioEntitlementRepository implements EntitlementRepository {
  DioEntitlementRepository(this._dio);

  final Dio _dio;

  static const path = EntitlementWire.mePath;

  @override
  Future<Entitlement> fetchEntitlements() {
    return _guard(() async {
      final response = await _dio.get<dynamic>(path);
      final data = response.data;
      if (data is Map) {
        return Entitlement.fromJson(Map<String, dynamic>.from(data));
      }
      throw const ApiException(
        message: 'Unexpected entitlement response.',
        code: 'INVALID_RESPONSE',
      );
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

/// Production entitlement client. Tests override this provider.
final entitlementRepositoryProvider = Provider<EntitlementRepository>((ref) {
  return DioEntitlementRepository(ref.watch(dioProvider));
});
