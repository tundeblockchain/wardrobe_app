import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/data/stub_shopping_links_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const payload = {
    'title': 'Black cotton tee',
    'price': 12.99,
    'merchant': 'Example Shop',
    'url': 'https://shop.example.com/tee',
  };

  late ScriptedHttpAdapter adapter;

  DioShoppingLinksRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioShoppingLinksRepository(dio);
  }

  test('listHomeShoppingLinks hits GET /shopping-links', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'links': [payload],
        },
      ),
    ]);

    final result = await repository.listHomeShoppingLinks();

    expect(result, hasLength(1));
    expect(result.single.title, 'Black cotton tee');
    expect(result.single.price, '12.99');
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, ShoppingLinksApi.homePath);
  });

  test('listItemShoppingLinks hits the provisional item path', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: [payload]),
    ]);

    final result = await repository.listItemShoppingLinks(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
    );

    expect(result.single.url, 'https://shop.example.com/tee');
    expect(
      adapter.requests.single.path,
      ShoppingLinksApi.itemPath(wardrobeId: 'wd_abc123', itemId: 'item_xyz123'),
    );
  });

  test(
    '404 is an empty list so a missing Backend route is a soft stub',
    () async {
      final repository = buildRepository([
        const HttpScript(statusCode: 404, body: {'code': 'NOT_FOUND'}),
      ]);

      expect(await repository.listHomeShoppingLinks(), isEmpty);
    },
  );

  test('maps a 500 envelope to ApiException', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 500,
        body: {
          'error': {'code': 'UPSTREAM_ERROR', 'message': 'SERP unavailable.'},
        },
      ),
    ]);

    expect(
      () => repository.listHomeShoppingLinks(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'UPSTREAM_ERROR',
        ),
      ),
    );
  });

  test('liveEnabled stays off until Backend confirms the contract', () {
    expect(ShoppingLinksApi.liveEnabled, isFalse);
  });

  test('stub repository returns empty lists', () async {
    const stub = StubShoppingLinksRepository();
    expect(await stub.listHomeShoppingLinks(), isEmpty);
    expect(
      await stub.listItemShoppingLinks(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      ),
      isEmpty,
    );
  });
}
