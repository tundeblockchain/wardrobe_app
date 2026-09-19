import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/share.dart';
import '../domain/share_contract.dart';
import '../domain/share_repository.dart';
import 'share_dtos.dart';
import 'stub_share_repository.dart';

export '../domain/share_contract.dart';

/// Dio implementation of [ShareRepository] against WARDROBE-126.
class DioShareRepository implements ShareRepository {
  DioShareRepository(this._dio);

  final Dio _dio;

  @override
  Future<Share> createItemShare({
    required String wardrobeId,
    required String itemId,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        ShareContract.itemPath(wardrobeId: wardrobeId, itemId: itemId),
      );
      return parseShare(response.data);
    });
  }

  @override
  Future<Share> createOutfitShare({
    required String wardrobeId,
    required String outfitId,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        ShareContract.outfitPath(wardrobeId: wardrobeId, outfitId: outfitId),
      );
      return parseShare(response.data);
    });
  }

  @override
  Future<void> revokeShare(String token) {
    return _guardRevoke(() async {
      await _dio.delete<dynamic>(ShareContract.revokePath(token));
    });
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  /// Revoke is idempotent — missing / already-revoked tokens stay successful.
  Future<void> _guardRevoke(Future<void> Function() action) async {
    try {
      await action();
    } on DioException catch (error) {
      final mapped = ApiException.fromDio(error);
      if (mapped.statusCode == 404 || mapped.statusCode == 204) {
        return;
      }
      throw mapped;
    }
  }
}

/// Default [ShareRepository]. Live Dio unless [ShareContract.liveEnabled] is off.
final shareRepositoryProvider = Provider<ShareRepository>((ref) {
  if (!ShareContract.liveEnabled) {
    return const StubShareRepository();
  }
  return DioShareRepository(ref.watch(dioProvider));
});
