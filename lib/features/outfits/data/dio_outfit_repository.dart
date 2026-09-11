import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/outfit.dart';
import '../domain/outfit_render.dart';
import '../domain/outfit_repository.dart';
import 'outfit_dtos.dart';

/// Dio implementation of [OutfitRepository] against `/wardrobes/{id}/outfits`.
class DioOutfitRepository implements OutfitRepository {
  DioOutfitRepository(this._dio);

  final Dio _dio;

  String _collectionPath(String wardrobeId) => '/wardrobes/$wardrobeId/outfits';

  String _outfitPath(String wardrobeId, String outfitId) =>
      '${_collectionPath(wardrobeId)}/$outfitId';

  String _renderPath(String wardrobeId, String outfitId) =>
      '${_outfitPath(wardrobeId, outfitId)}/render';

  @override
  Future<List<Outfit>> listOutfits(String wardrobeId) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(_collectionPath(wardrobeId));
      return parseOutfitList(response.data);
    });
  }

  @override
  Future<Outfit> getOutfit({
    required String wardrobeId,
    required String outfitId,
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        _outfitPath(wardrobeId, outfitId),
      );
      return parseOutfit(response.data);
    });
  }

  @override
  Future<Outfit> createOutfit({
    required String wardrobeId,
    required String name,
    required List<OutfitItem> items,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        _collectionPath(wardrobeId),
        data: CreateOutfitRequest.fromDomain(name: name, items: items).toJson(),
      );
      return parseOutfit(response.data);
    });
  }

  @override
  Future<Outfit> updateOutfit({
    required String wardrobeId,
    required String outfitId,
    String? name,
    List<OutfitItem>? items,
  }) {
    return _guard(() async {
      final response = await _dio.patch<dynamic>(
        _outfitPath(wardrobeId, outfitId),
        data: UpdateOutfitRequest(
          name: name,
          items: items == null
              ? null
              : [for (final item in items) OutfitItemRequest.fromDomain(item)],
        ).toJson(),
      );
      return parseOutfit(response.data);
    });
  }

  @override
  Future<void> deleteOutfit({
    required String wardrobeId,
    required String outfitId,
  }) {
    return _guard(() async {
      await _dio.delete<dynamic>(_outfitPath(wardrobeId, outfitId));
    });
  }

  @override
  Future<Outfit> requestRender({
    required String wardrobeId,
    required String outfitId,
    required String aiProfileId,
    List<OutfitItem>? items,
    List<String>? itemIds,
  }) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        _renderPath(wardrobeId, outfitId),
        data: RequestOutfitRenderRequest(
          aiProfileId: aiProfileId,
          items: items == null
              ? null
              : [for (final item in items) OutfitItemRequest.fromDomain(item)],
          itemIds: itemIds,
        ).toJson(),
      );
      return parseOutfit(response.data);
    });
  }

  @override
  Future<OutfitRender> getRender({
    required String wardrobeId,
    required String outfitId,
  }) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(
        _renderPath(wardrobeId, outfitId),
      );
      return parseOutfitRender(response.data);
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

/// Parses `GET /wardrobes/{id}/outfits` as `{ "outfits": [...] }` or a bare array.
List<Outfit> parseOutfitList(dynamic data) {
  if (data is List) {
    return data.whereType<Map>().map((item) => parseOutfit(item)).toList();
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final nested = map['outfits'];
    if (nested is List) {
      return [
        for (final item in nested)
          if (item is Map) parseOutfit(item),
      ];
    }
    return OutfitListResponse.fromJson(map).toDomain();
  }
  throw const ApiException(
    message: 'Unexpected outfits response.',
    code: 'INVALID_RESPONSE',
  );
}

Outfit parseOutfit(dynamic data) {
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final outfit = OutfitResponse.fromJson(map).toDomain();
    return outfit.copyWith(
      renderHistory: parseRenderHistory(map['renderHistory']),
      renderImageUrls: parseRenderImageUrls(map['renderImageUrls']),
    );
  }
  throw const ApiException(
    message: 'Unexpected outfit response.',
    code: 'INVALID_RESPONSE',
  );
}

OutfitRender parseOutfitRender(dynamic data) {
  if (data is Map) {
    return OutfitRenderResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected outfit render response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [OutfitRepository] using the shared authenticated Dio client.
final outfitRepositoryProvider = Provider<OutfitRepository>((ref) {
  return DioOutfitRepository(ref.watch(dioProvider));
});
