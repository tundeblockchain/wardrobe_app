import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_taxonomy.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const payload = {
    'itemId': 'item_xyz123',
    'wardrobeId': 'wd_abc123',
    'name': 'Black Nike T-Shirt',
    'category': 'TOP',
    'image': {'originalKey': 'users/uid/uploads/uuid.jpg'},
    'processingStatus': 'READY',
    'createdAt': '2026-09-03T18:45:00Z',
    'updatedAt': '2026-09-03T18:45:00Z',
  };

  late ScriptedHttpAdapter adapter;
  late DioItemRepository repository;

  DioItemRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioItemRepository(dio);
  }

  test('listItems unwraps { items: [...] }', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'items': [payload],
        },
      ),
    ]);

    final result = await repository.listItems('wd_abc123');

    expect(result, hasLength(1));
    expect(result.single.id, 'item_xyz123');
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/wardrobes/wd_abc123/items');
    expect(adapter.requests.single.queryParameters, isEmpty);
  });

  test(
    'listItems sends category, colour, and subcategory query params',
    () async {
      repository = buildRepository([
        const HttpScript(
          statusCode: 200,
          body: {
            'items': [payload],
          },
        ),
      ]);

      final result = await repository.listItems(
        'wd_abc123',
        filters: const ItemListFilters(
          category: ItemCategory.top,
          colour: ItemColour.black,
          subcategory: ItemSubcategory.tshirt,
        ),
      );

      expect(result, hasLength(1));
      expect(adapter.requests.single.method, 'GET');
      expect(adapter.requests.single.path, '/wardrobes/wd_abc123/items');
      expect(adapter.requests.single.queryParameters, {
        'category': 'TOP',
        'colour': 'BLACK',
        'subcategory': 'TSHIRT',
      });
    },
  );

  test('listItems sends only the selected filter params', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'items': [payload],
        },
      ),
    ]);

    await repository.listItems(
      'wd_abc123',
      filters: const ItemListFilters(category: ItemCategory.top),
    );

    expect(adapter.requests.single.queryParameters, {'category': 'TOP'});
  });

  test('listItems accepts a bare array', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: [payload]),
    ]);

    final result = await repository.listItems('wd_abc123');
    expect(result.single.name, 'Black Nike T-Shirt');
  });

  test('getItem maps itemId to domain id', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: payload),
    ]);

    final result = await repository.getItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
    );

    expect(result.id, 'item_xyz123');
    expect(result.category, ItemCategory.top);
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/items/item_xyz123',
    );
  });

  test('parseItem keeps PROCESSING keys and overlays originalImageUrl', () {
    const processingPayload = {
      'itemId': 'item_xyz123',
      'wardrobeId': 'wd_abc123',
      'name': 'Black Nike T-Shirt',
      'category': 'TOP',
      'subcategory': 'TSHIRT',
      'colours': ['BLACK'],
      'brand': 'Nike',
      'image': {'originalKey': 'users/uid/uploads/uuid.jpg'},
      'processingStatus': 'PROCESSING',
      'createdAt': '2026-09-03T18:45:00Z',
      'updatedAt': '2026-09-03T18:45:00Z',
    };

    final keysOnly = parseItem(processingPayload);
    expect(keysOnly.processingStatus, ItemProcessingStatus.processing);
    expect(keysOnly.originalImageKey, 'users/uid/uploads/uuid.jpg');
    expect(keysOnly.processedImageKey, isNull);

    final withUrl = parseItem({
      ...processingPayload,
      'originalImageUrl': 'https://cdn.example.com/original.jpg',
    });
    expect(withUrl.originalImageKey, 'https://cdn.example.com/original.jpg');
    expect(withUrl.processingStatus, ItemProcessingStatus.processing);
  });

  test('parseItem prefers processedImageUrl when READY', () {
    final item = parseItem({
      ...payload,
      'image': {
        'originalKey': 'users/uid/uploads/uuid.jpg',
        'processedKey': 'users/uid/items/item_xyz123/processed.png',
      },
      'processedImageUrl': 'https://cdn.example.com/processed.png',
      'originalImageUrl': 'https://cdn.example.com/original.jpg',
    });

    expect(item.processedImageKey, 'https://cdn.example.com/processed.png');
    expect(item.originalImageKey, 'https://cdn.example.com/original.jpg');
  });

  test('createItem posts contract body and maps the response', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: payload),
    ]);

    final result = await repository.createItem(
      wardrobeId: 'wd_abc123',
      name: 'Black Nike T-Shirt',
      category: ItemCategory.top,
      imageKey: 'users/uid/uploads/uuid.jpg',
    );

    expect(result.id, 'item_xyz123');
    expect(adapter.requests.single.method, 'POST');
    expect(_requestBody(adapter.requests.single), {
      'name': 'Black Nike T-Shirt',
      'category': 'TOP',
      'imageKey': 'users/uid/uploads/uuid.jpg',
    });
  });

  test('updateItem patches provided fields', () async {
    repository = buildRepository([
      HttpScript(statusCode: 200, body: {...payload, 'name': 'Navy Tee'}),
    ]);

    final result = await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      name: 'Navy Tee',
    );

    expect(result.name, 'Navy Tee');
    expect(adapter.requests.single.method, 'PATCH');
    expect(_requestBody(adapter.requests.single), {'name': 'Navy Tee'});
  });

  test('deleteItem accepts 204 with an empty body', () async {
    repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.deleteItem(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

    expect(adapter.requests.single.method, 'DELETE');
  });

  test('maps nested backend error envelope to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'ITEM_NOT_FOUND', 'message': 'Item not found.'},
        },
      ),
    ]);

    expect(
      () => repository.getItem(wardrobeId: 'wd_abc123', itemId: 'missing'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'ITEM_NOT_FOUND',
        ),
      ),
    );
  });
}

Map<String, dynamic> _requestBody(RequestOptions options) {
  final data = options.data;
  if (data is Map<String, dynamic>) {
    return data;
  }
  if (data is Map) {
    return Map<String, dynamic>.from(data);
  }
  if (data is String && data.isNotEmpty) {
    return Map<String, dynamic>.from(jsonDecode(data) as Map);
  }
  return const {};
}
