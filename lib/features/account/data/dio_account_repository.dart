import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/account_repository.dart';
import '../domain/account_wipe_summary.dart';

/// Dio implementation of [AccountRepository] against `/me` (WARDROBE-36).
class DioAccountRepository implements AccountRepository {
  DioAccountRepository(this._dio);

  final Dio _dio;

  static const _wipeTimeout = Duration(seconds: 60);

  @override
  Future<AccountWipeSummary> clearContent() {
    return _wipe('/me/content');
  }

  @override
  Future<AccountWipeSummary> deleteAccount() {
    return _wipe('/me');
  }

  Future<AccountWipeSummary> _wipe(String path) {
    return _guard(() async {
      final response = await _dio.delete<dynamic>(
        path,
        options: Options(receiveTimeout: _wipeTimeout),
      );
      return _parseSummary(response.data);
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

AccountWipeSummary _parseSummary(dynamic data) {
  if (data is Map) {
    return AccountWipeSummary.fromJson(Map<String, dynamic>.from(data));
  }
  throw const ApiException(
    message: 'Unexpected account wipe response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [AccountRepository] using the shared Dio client.
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return DioAccountRepository(ref.watch(dioProvider));
});
