import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/data/dio_outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const payload = {
    'outfitId': 'outfit_123',
    'wardrobeId': 'wd_abc123',
    'name': 'Friday Night',
    'items': [
      {'itemId': 'item_top123', 'slot': 'TOP'},
      {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
      {'itemId': 'item_shoes789', 'slot': 'SHOES'},
    ],
    'createdAt': '2026-09-04T18:00:00Z',
    'updatedAt': '2026-09-04T18:00:00Z',
  };

  late ScriptedHttpAdapter adapter;
  late DioOutfitRepository repository;

  DioOutfitRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioOutfitRepository(dio);
  }

  test('listOutfits unwraps { outfits: [...] }', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'outfits': [payload],
        },
      ),
    ]);

    final result = await repository.listOutfits('wd_abc123');

    expect(result, hasLength(1));
    expect(result.single.id, 'outfit_123');
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/wardrobes/wd_abc123/outfits');
  });

  test('listOutfits accepts a bare array', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: [payload]),
    ]);

    final result = await repository.listOutfits('wd_abc123');
    expect(result.single.name, 'Friday Night');
  });

  test('getOutfit maps outfitId to domain id', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: payload),
    ]);

    final result = await repository.getOutfit(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result.id, 'outfit_123');
    expect(result.items.first.slot, ItemCategory.top);
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/outfits/outfit_123',
    );
  });

  test('createOutfit posts contract body and maps the response', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: payload),
    ]);

    final result = await repository.createOutfit(
      wardrobeId: 'wd_abc123',
      name: 'Friday Night',
      items: const [
        OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
        OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
        OutfitItem(itemId: 'item_shoes789', slot: ItemCategory.shoes),
      ],
    );

    expect(result.id, 'outfit_123');
    expect(adapter.requests.single.method, 'POST');
    expect(_requestBody(adapter.requests.single), {
      'name': 'Friday Night',
      'items': [
        {'itemId': 'item_top123', 'slot': 'TOP'},
        {'itemId': 'item_bottom456', 'slot': 'BOTTOM'},
        {'itemId': 'item_shoes789', 'slot': 'SHOES'},
      ],
    });
  });

  test('updateOutfit patches provided fields', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 200,
        body: {...payload, 'name': 'Saturday Brunch'},
      ),
    ]);

    final result = await repository.updateOutfit(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
      name: 'Saturday Brunch',
    );

    expect(result.name, 'Saturday Brunch');
    expect(adapter.requests.single.method, 'PATCH');
    expect(_requestBody(adapter.requests.single), {'name': 'Saturday Brunch'});
  });

  test('deleteOutfit accepts 204 with an empty body', () async {
    repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.deleteOutfit(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(adapter.requests.single.method, 'DELETE');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/outfits/outfit_123',
    );
  });

  test('requestRender posts aiProfileId and maps 202 outfit', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 202,
        body: {
          ...payload,
          'render': {'status': 'PENDING', 'aiProfileId': 'profile_generic_01'},
        },
      ),
    ]);

    final result = await repository.requestRender(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
      aiProfileId: 'profile_generic_01',
    );

    expect(result.render?.status.wireValue, 'PENDING');
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/outfits/outfit_123/render',
    );
    expect(_requestBody(adapter.requests.single), {
      'aiProfileId': 'profile_generic_01',
    });
  });

  test('getRender polls OutfitRender including READY imageUrl', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'status': 'READY',
          'aiProfileId': 'profile_generic_01',
          'imageKey': 'users/uid/outfits/outfit_123/render.png',
          'imageUrl': 'https://cdn.example.com/try-on.png',
        },
      ),
    ]);

    final result = await repository.getRender(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result.status.wireValue, 'READY');
    expect(result.imageUrl, 'https://cdn.example.com/try-on.png');
    expect(adapter.requests.single.method, 'GET');
    expect(
      adapter.requests.single.path,
      '/wardrobes/wd_abc123/outfits/outfit_123/render',
    );
  });

  test('getOutfit maps renderHistory and renderImageUrls', () async {
    repository = buildRepository([
      HttpScript(
        statusCode: 200,
        body: {
          ...payload,
          'render': {
            'status': 'READY',
            'aiProfileId': 'profile_generic_01',
            'imageKey': 'users/uid/outfits/outfit_123/renders/rend_new.png',
            'imageUrl': 'https://cdn.example.com/try-on/newer.png',
          },
          'renderHistory': [
            {
              'imageKey': 'users/uid/outfits/outfit_123/renders/rend_new.png',
              'imageUrl': 'https://cdn.example.com/try-on/newer.png',
              'createdAt': '2026-09-10T00:00:00Z',
              'aiProfileId': 'profile_generic_01',
            },
            {
              'imageKey': 'users/uid/outfits/outfit_123/render.png',
              'createdAt': '2026-09-01T00:00:00Z',
              'aiProfileId': 'profile_generic_01',
            },
          ],
          'renderImageUrls': ['https://cdn.example.com/try-on/newer.png'],
        },
      ),
    ]);

    final result = await repository.getOutfit(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result.renderImageUrls, [
      'https://cdn.example.com/try-on/newer.png',
    ]);
    expect(result.renderHistory, hasLength(2));
    expect(result.renderHistory.first.imageUrl, contains('newer.png'));
    expect(result.renderHistory[1].imageUrl, isNull);
  });

  test('getRender maps RENDER_NOT_FOUND', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'RENDER_NOT_FOUND', 'message': 'No render yet.'},
        },
      ),
    ]);

    expect(
      () =>
          repository.getRender(wardrobeId: 'wd_abc123', outfitId: 'outfit_123'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'RENDER_NOT_FOUND',
        ),
      ),
    );
  });

  test('maps nested backend error envelope to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'OUTFIT_NOT_FOUND', 'message': 'Outfit not found.'},
        },
      ),
    ]);

    expect(
      () => repository.getOutfit(wardrobeId: 'wd_abc123', outfitId: 'missing'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'OUTFIT_NOT_FOUND',
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
