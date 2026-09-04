import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/wardrobe.dart';
import '../domain/wardrobe_repository.dart';
import 'wardrobe_dtos.dart';

/// Dio implementation of [WardrobeRepository] against `/wardrobes`.
class DioWardrobeRepository implements WardrobeRepository {
  DioWardrobeRepository(this._dio);

  final Dio _dio;

  static const _path = '/wardrobes';

  @override
  Future<List<Wardrobe>> listWardrobes() {
    return _guard(() async {
      final response = await _dio.get<dynamic>(_path);
      return parseWardrobeList(response.data);
    });
  }

  @override
  Future<Wardrobe> getWardrobe(String id) {
    return _guard(() async {
      final response = await _dio.get<dynamic>('$_path/$id');
      return _parseWardrobe(response.data);
    });
  }

  @override
  Future<Wardrobe> createWardrobe({required String name}) {
    return _guard(() async {
      final response = await _dio.post<dynamic>(
        _path,
        data: CreateWardrobeRequest(name: name).toJson(),
      );
      return _parseWardrobe(response.data);
    });
  }

  @override
  Future<Wardrobe> updateWardrobe({required String id, required String name}) {
    return _guard(() async {
      final response = await _dio.patch<dynamic>(
        '$_path/$id',
        data: UpdateWardrobeRequest(name: name).toJson(),
      );
      return _parseWardrobe(response.data);
    });
  }

  @override
  Future<void> deleteWardrobe(String id) {
    return _guard(() async {
      await _dio.delete<dynamic>('$_path/$id');
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

/// Parses `GET /wardrobes` as `{ "wardrobes": [...] }` or a bare array.
List<Wardrobe> parseWardrobeList(dynamic data) {
  if (data is List) {
    return data
        .whereType<Map>()
        .map(
          (item) =>
              WardrobeResponse.fromJson(Map<String, dynamic>.from(item))
                  .toDomain(),
        )
        .toList();
  }
  if (data is Map) {
    return WardrobeListResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected wardrobes response.',
    code: 'INVALID_RESPONSE',
  );
}

Wardrobe _parseWardrobe(dynamic data) {
  if (data is Map) {
    return WardrobeResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected wardrobe response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [WardrobeRepository] using the shared Dio client.
final wardrobeRepositoryProvider = Provider<WardrobeRepository>((ref) {
  return DioWardrobeRepository(ref.watch(dioProvider));
});
