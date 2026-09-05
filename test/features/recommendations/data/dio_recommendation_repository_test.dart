import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/recommendations/data/dio_recommendation_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const payload = {
    'name': 'Navy + Beige look',
    'items': [
      {'itemId': 'item_top123', 'slot': 'TOP'},
      {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
    ],
  };

  late ScriptedHttpAdapter adapter;
  late DioRecommendationRepository repository;

  DioRecommendationRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioRecommendationRepository(dio);
  }

  test('listRecommendations unwraps { recommendations: [...] }', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'recommendations': [payload],
        },
      ),
    ]);

    final result = await repository.listRecommendations('wd_abc123');

    expect(result, hasLength(1));
    expect(result.single.name, 'Navy + Beige look');
    expect(result.single.items.first.slot, ItemCategory.top);
    expect(adapter.requests.single.method, 'GET');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/recommendations',
    );
  });

  test('listRecommendations accepts a bare array', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: [payload]),
    ]);

    final result = await repository.listRecommendations('wd_abc123');
    expect(result.single.name, 'Navy + Beige look');
  });

  test('listRecommendations accepts an empty envelope', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: {'recommendations': []}),
    ]);

    final result = await repository.listRecommendations('wd_abc123');
    expect(result, isEmpty);
  });

  test('maps nested backend error envelope to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {
            'code': 'WARDROBE_NOT_FOUND',
            'message': 'Wardrobe not found.',
          },
        },
      ),
    ]);

    expect(
      () => repository.listRecommendations('missing'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'WARDROBE_NOT_FOUND',
        ),
      ),
    );
  });
}
