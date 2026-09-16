import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/entitlement.dart';
import '../domain/entitlement_repository.dart';

/// Catalog snapshot used until Backend WARDROBE-91 is reachable.
///
/// Same [Entitlement] shape as `GET /me/entitlements` — not a separate protocol.
class CatalogEntitlementRepository implements EntitlementRepository {
  const CatalogEntitlementRepository({this.seed});

  final Entitlement? seed;

  @override
  Future<Entitlement> fetchEntitlements() async {
    return seed ?? Entitlement.free;
  }
}

/// `GET /me/entitlements` — provisional Flutter read owned by Backend.
class DioEntitlementRepository implements EntitlementRepository {
  DioEntitlementRepository(this._dio);

  final Dio _dio;

  static const path = '/me/entitlements';

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

/// Prefers Backend when Firebase is configured; otherwise the catalog stub.
///
/// 404 / 501 / network failures fall back to Free so CI and pre-WARDROBE-91
/// builds stay usable without inventing a second entitlement API.
class SwitchingEntitlementRepository implements EntitlementRepository {
  SwitchingEntitlementRepository({
    required this.remote,
    this.fallback = const CatalogEntitlementRepository(),
    this.useRemote = true,
  });

  final EntitlementRepository remote;
  final EntitlementRepository fallback;
  final bool useRemote;

  @override
  Future<Entitlement> fetchEntitlements() async {
    if (!useRemote) {
      return fallback.fetchEntitlements();
    }
    try {
      return await remote.fetchEntitlements();
    } on ApiException catch (error) {
      if (_shouldFallback(error)) {
        return fallback.fetchEntitlements();
      }
      rethrow;
    }
  }

  bool _shouldFallback(ApiException error) {
    final status = error.statusCode;
    if (status == 401 || status == 404 || status == 501) {
      return true;
    }
    const softCodes = {'NETWORK_ERROR', 'TIMEOUT', 'UNKNOWN', 'BAD_RESPONSE'};
    return error.code != null && softCodes.contains(error.code);
  }
}

/// Default entitlement repository. Tests override this provider.
final entitlementRepositoryProvider = Provider<EntitlementRepository>((ref) {
  return SwitchingEntitlementRepository(
    remote: DioEntitlementRepository(ref.watch(dioProvider)),
    useRemote: Firebase.apps.isNotEmpty,
  );
});
