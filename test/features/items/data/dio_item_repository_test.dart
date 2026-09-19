import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/items/data/dio_item_repository.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/items/domain/item_acquired_at_patch.dart';
import 'package:wardrobe_app/features/items/domain/item_list_filters.dart';
import 'package:wardrobe_app/features/items/domain/item_subcategory_patch.dart';
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

  test('listItems sends acquiredAfter and acquiredBefore ISO dates', () async {
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
      filters: ItemListFilters(
        acquiredAfter: DateTime.utc(2024, 1, 1),
        acquiredBefore: DateTime.utc(2025, 12, 31),
      ),
    );

    expect(adapter.requests.single.queryParameters, {
      'acquiredAfter': '2024-01-01',
      'acquiredBefore': '2025-12-31',
    });
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

  test('parseItem maps Backend #26 PROCESSING contract', () {
    final item = parseItem({
      'itemId': 'item_xyz123abcd',
      'wardrobeId': 'wd_abc123xyz0',
      'name': 'Black T-Shirt',
      'category': 'TOP',
      'image': {'originalKey': 'users/uid/uploads/photo.jpg'},
      'originalImageUrl': 'https://s3.example.com/users/uid/uploads/photo.jpg?X-Amz-Expires=900',
      'processingStatus': 'PROCESSING',
      'createdAt': '2026-09-03T18:45:00Z',
      'updatedAt': '2026-09-03T18:45:00Z',
    });

    expect(item.processingStatus, ItemProcessingStatus.processing);
    expect(
      item.originalImageKey,
      'https://s3.example.com/users/uid/uploads/photo.jpg?X-Amz-Expires=900',
    );
    expect(item.processedImageKey, isNull);
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

  test('createItem posts acquiredAt as YYYY-MM-DD', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 201,
        body: {...payload, 'acquiredAt': '2024-03-09'},
      ),
    ]);

    final result = await repository.createItem(
      wardrobeId: 'wd_abc123',
      name: 'Black Nike T-Shirt',
      category: ItemCategory.top,
      imageKey: 'users/uid/uploads/uuid.jpg',
      acquiredAt: DateTime.utc(2024, 3, 9),
    );

    expect(result.acquiredAt, DateTime.utc(2024, 3, 9));
    expect(_requestBody(adapter.requests.single)['acquiredAt'], '2024-03-09');
  });

  test('createItem omits acquiredAt when unset', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: payload),
    ]);

    await repository.createItem(
      wardrobeId: 'wd_abc123',
      name: 'Black Nike T-Shirt',
      category: ItemCategory.top,
      imageKey: 'users/uid/uploads/uuid.jpg',
    );

    expect(
      _requestBody(adapter.requests.single).containsKey('acquiredAt'),
      isFalse,
    );
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
    expect(
      _requestBody(adapter.requests.single).containsKey('subcategory'),
      isFalse,
    );
  });

  test('updateItem omits subcategory when the patch is omit', () async {
    repository = buildRepository([HttpScript(statusCode: 200, body: payload)]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      name: 'Navy Tee',
      subcategory: const ItemSubcategoryPatch.omit(),
    );

    expect(_requestBody(adapter.requests.single), {'name': 'Navy Tee'});
  });

  test('updateItem PATCHes JSON null to clear subcategory', () async {
    repository = buildRepository([HttpScript(statusCode: 200, body: payload)]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      subcategory: const ItemSubcategoryPatch.clear(),
    );

    expect(_requestBody(adapter.requests.single), {'subcategory': null});
  });

  test('updateItem PATCHes a trimmed subcategory token', () async {
    repository = buildRepository([
      HttpScript(statusCode: 200, body: {...payload, 'subcategory': 'SHIRT'}),
    ]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      subcategory: const ItemSubcategoryPatch.set('SHIRT'),
    );

    expect(_requestBody(adapter.requests.single), {'subcategory': 'SHIRT'});
  });

  test('updateItem omits acquiredAt when the patch is omit', () async {
    repository = buildRepository([HttpScript(statusCode: 200, body: payload)]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      name: 'Navy Tee',
      acquiredAt: const ItemAcquiredAtPatch.omit(),
    );

    expect(
      _requestBody(adapter.requests.single).containsKey('acquiredAt'),
      isFalse,
    );
  });

  test('updateItem PATCHes JSON null to clear acquiredAt', () async {
    repository = buildRepository([HttpScript(statusCode: 200, body: payload)]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      acquiredAt: const ItemAcquiredAtPatch.clear(),
    );

    expect(_requestBody(adapter.requests.single), {'acquiredAt': null});
  });

  test('updateItem PATCHes acquiredAt as YYYY-MM-DD', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 200,
        body: {...payload, 'acquiredAt': '2024-03-09'},
      ),
    ]);

    await repository.updateItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      acquiredAt: ItemAcquiredAtPatch.set(DateTime.utc(2024, 3, 9)),
    );

    expect(_requestBody(adapter.requests.single), {'acquiredAt': '2024-03-09'});
  });

  test('createItem still omits empty subcategory', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: payload),
    ]);

    await repository.createItem(
      wardrobeId: 'wd_abc123',
      name: 'Black Nike T-Shirt',
      category: ItemCategory.top,
      subcategory: '  ',
      imageKey: 'users/uid/uploads/uuid.jpg',
    );

    expect(
      _requestBody(adapter.requests.single).containsKey('subcategory'),
      isFalse,
    );
  });

  test(
    'reprocessItem posts the WARDROBE-123 path and maps 202 PENDING',
    () async {
      repository = buildRepository([
        HttpScript(
          statusCode: 202,
          body: {...payload, 'processingStatus': 'PENDING'},
        ),
      ]);

      final result = await repository.reprocessItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      );

      expect(result.id, 'item_xyz123');
      expect(result.processingStatus, ItemProcessingStatus.pending);
      expect(result.processingError, isNull);
      expect(adapter.requests.single.method, 'POST');
      expect(
        adapter.requests.single.path,
        '/wardrobes/wd_abc123/items/item_xyz123/reprocess',
      );
      expect(_requestBody(adapter.requests.single), isEmpty);
    },
  );

  test('reprocessItem maps 409 PROCESSING_IN_PROGRESS', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 409,
        body: {
          'error': {
            'code': 'PROCESSING_IN_PROGRESS',
            'message': 'Item is already processing.',
          },
        },
      ),
    ]);

    expect(
      () => repository.reprocessItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'PROCESSING_IN_PROGRESS')
            .having((error) => error.statusCode, 'statusCode', 409),
      ),
    );
  });

  test('reprocessItem maps 403 ENTITLEMENT_AI_REQUIRED', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 403,
        body: {
          'error': {
            'code': 'ENTITLEMENT_AI_REQUIRED',
            'message': 'Premium is required for AI processing.',
          },
        },
      ),
    ]);

    expect(
      () => repository.reprocessItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'ENTITLEMENT_AI_REQUIRED')
            .having((error) => error.statusCode, 'statusCode', 403),
      ),
    );
  });

  test('deleteItem accepts 204 with an empty body', () async {
    repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.deleteItem(wardrobeId: 'wd_abc123', itemId: 'item_xyz123');

    expect(adapter.requests.single.method, 'DELETE');
  });

  test('moveItem posts targetWardrobeId and maps 200 ClothingItem', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 200,
        body: {...payload, 'wardrobeId': 'wd_other12ab'},
      ),
    ]);

    final result = await repository.moveItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      targetWardrobeId: 'wd_other12ab',
    );

    expect(result.id, 'item_xyz123');
    expect(result.wardrobeId, 'wd_other12ab');
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/items/item_xyz123/move',
    );
    expect(_requestBody(adapter.requests.single), {
      'targetWardrobeId': 'wd_other12ab',
    });
  });

  test('copyItem posts targetWardrobeId and maps 201 ClothingItem', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 201,
        body: {
          ...payload,
          'itemId': 'item_copy12ab',
          'wardrobeId': 'wd_other12ab',
        },
      ),
    ]);

    final result = await repository.copyItem(
      wardrobeId: 'wd_abc123',
      itemId: 'item_xyz123',
      targetWardrobeId: 'wd_other12ab',
    );

    expect(result.id, 'item_copy12ab');
    expect(result.wardrobeId, 'wd_other12ab');
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/items/item_xyz123/copy',
    );
    expect(_requestBody(adapter.requests.single), {
      'targetWardrobeId': 'wd_other12ab',
    });
  });

  test('moveItem maps 400 VALIDATION_ERROR for in-flight items', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 400,
        body: {
          'error': {
            'code': 'VALIDATION_ERROR',
            'message': 'Item is still processing. Wait until READY or FAILED before moving or copying.',
          },
        },
      ),
    ]);

    expect(
      () => repository.moveItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
        targetWardrobeId: 'wd_other12ab',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'VALIDATION_ERROR')
            .having((error) => error.statusCode, 'statusCode', 400),
      ),
    );
  });

  test('copyItem maps 403 ENTITLEMENT_ITEM_LIMIT', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 403,
        body: {
          'error': {
            'code': 'ENTITLEMENT_ITEM_LIMIT',
            'message': 'Free includes 5 clothing items.',
          },
        },
      ),
    ]);

    expect(
      () => repository.copyItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
        targetWardrobeId: 'wd_other12ab',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'ENTITLEMENT_ITEM_LIMIT')
            .having((error) => error.statusCode, 'statusCode', 403),
      ),
    );
  });

  test('moveItem maps 404 WARDROBE_NOT_FOUND for a missing target', () async {
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
      () => repository.moveItem(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
        targetWardrobeId: 'wd_missing',
      ),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'WARDROBE_NOT_FOUND',
        ),
      ),
    );
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
