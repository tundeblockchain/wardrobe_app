import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/network/dio_client.dart';
import '../domain/recommendation.dart';
import '../domain/recommendation_repository.dart';
import 'recommendation_dtos.dart';

/// Dio implementation of [RecommendationRepository].
class DioRecommendationRepository implements RecommendationRepository {
  DioRecommendationRepository(this._dio);

  final Dio _dio;

  String _path(String wardrobeId) => '/wardrobes/$wardrobeId/recommendations';

  @override
  Future<List<Recommendation>> listRecommendations(String wardrobeId) {
    return _guard(() async {
      final response = await _dio.get<dynamic>(_path(wardrobeId));
      return parseRecommendationList(response.data);
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

/// Parses `{ "recommendations": [...] }` or a bare array.
List<Recommendation> parseRecommendationList(dynamic data) {
  if (data is List) {
    return data
        .whereType<Map>()
        .map((item) => parseRecommendation(item))
        .toList();
  }
  if (data is Map) {
    return RecommendationListResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected recommendations response.',
    code: 'INVALID_RESPONSE',
  );
}

Recommendation parseRecommendation(dynamic data) {
  if (data is Map) {
    return RecommendationResponse.fromJson(Map<String, dynamic>.from(data))
        .toDomain();
  }
  throw const ApiException(
    message: 'Unexpected recommendation response.',
    code: 'INVALID_RESPONSE',
  );
}

/// Default [RecommendationRepository] using the shared authenticated Dio client.
final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return DioRecommendationRepository(ref.watch(dioProvider));
});
