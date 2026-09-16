import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/shopping_links/data/dio_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/data/stub_shopping_links_repository.dart';
import 'package:wardrobe_app/features/shopping_links/domain/shopping_link.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const link = {
    'title': 'Black cotton tee',
    'price': '12.99',
    'currency': 'GBP',
    'merchant': 'Example Shop',
    'url': 'https://shop.example.com/tee',
  };

  const itemEnvelope = {
    'itemId': 'item_xyz123',
    'wardrobeId': 'wd_abc123',
    'keywords': ['black tee'],
    'cached': false,
    'links': [link],
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

  test(
    'listHomeShoppingLinks hits GET /shopping-links?limit=5&linksPerItem=8',
    () async {
      final repository = buildRepository([
        const HttpScript(
          statusCode: 200,
          body: {
            'items': [itemEnvelope],
          },
        ),
      ]);

      final result = await repository.listHomeShoppingLinks();

      expect(result.flattenedLinks, hasLength(1));
      expect(result.flattenedLinks.single.currency, 'GBP');
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, ShoppingLinksContract.homePath);
      expect(adapter.requests.single.queryParameters, {
        'limit': '5',
        'linksPerItem': '8',
      });
    },
  );

  test('listItemShoppingLinks hits the locked item path', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: itemEnvelope),
    ]);

    final result = await repository.listItemShoppingLinks(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
    );

    expect(result.itemId, 'item_xyz123');
    expect(result.keywords, ['black tee']);
    expect(result.links.single.url, 'https://shop.example.com/tee');
    expect(
      adapter.requests.single.path,
      ShoppingLinksContract.itemPath(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      ),
    );
    expect(adapter.requests.single.queryParameters, isEmpty);
  });

  test('200 with empty items is a soft empty home, not an error', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {'items': <Map<String, dynamic>>[]},
      ),
    ]);

    final result = await repository.listHomeShoppingLinks();
    expect(result.items, isEmpty);
    expect(result.upstreamWarning, isNull);
  });

  test('200 with warning keeps empty links for upstream blips', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'itemId': 'item_xyz123',
          'wardrobeId': 'wd_abc123',
          'keywords': <String>[],
          'cached': false,
          'links': <Map<String, dynamic>>[],
          'warning': {
            'code': 'SHOPPING_UPSTREAM_UNAVAILABLE',
            'message': 'Similar products are unavailable right now.',
          },
        },
      ),
    ]);

    final result = await repository.listItemShoppingLinks(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
    );
    expect(result.links, isEmpty);
    expect(result.warning?.code, ShoppingLinksWarning.upstreamUnavailable);
  });

  test('404 ITEM_NOT_FOUND / WARDROBE_NOT_FOUND is an empty section', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {'code': 'ITEM_NOT_FOUND', 'message': 'Item not found.'},
      ),
    ]);

    final result = await repository.listItemShoppingLinks(
      wardrobeId: 'wd_abc123',
      itemId: 'missing',
    );
    expect(result.links, isEmpty);
    expect(result.itemId, 'missing');
  });

  test('maps a 500 envelope to ApiException', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 500,
        body: {
          'error': {'code': 'UNKNOWN', 'message': 'Internal error.'},
        },
      ),
    ]);

    expect(
      () => repository.listHomeShoppingLinks(),
      throwsA(
        isA<ApiException>().having((error) => error.code, 'code', 'UNKNOWN'),
      ),
    );
  });

  test('liveEnabled is on for wardrobe-backend#47 aaf46cd on main', () {
    expect(ShoppingLinksContract.liveEnabled, isTrue);
  });

  test('shoppingLinksRepositoryProvider serves DioShoppingLinksRepository', () {
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(
          createDioClient(
            baseUrl: 'https://api.example.com',
            tokenSource: _TokenSource(),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    expect(
      container.read(shoppingLinksRepositoryProvider),
      isA<DioShoppingLinksRepository>(),
    );
  });

  test('stub repository returns empty envelopes', () async {
    const stub = StubShoppingLinksRepository();
    expect((await stub.listHomeShoppingLinks()).items, isEmpty);
    expect(
      (await stub.listItemShoppingLinks(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      )).links,
      isEmpty,
    );
  });
}
