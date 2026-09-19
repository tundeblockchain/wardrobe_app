import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/share/data/dio_share_repository.dart';
import 'package:wardrobe_app/features/share/data/stub_share_repository.dart';
import 'package:wardrobe_app/features/share/domain/share.dart';
import 'package:wardrobe_app/features/share/domain/share_errors.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const itemShare = {
    'token': 'shr_itemtoken21charsxx',
    'resourceType': 'ITEM',
    'wardrobeId': 'wd_abc123',
    'itemId': 'item_xyz123',
    'sharePath': '/share/shr_itemtoken21charsxx',
    'expiresAt': '2026-10-19T12:00:00.000Z',
    'createdAt': '2026-09-19T12:00:00.000Z',
  };

  const outfitShare = {
    'token': 'shr_outfittoken21charsx',
    'resourceType': 'OUTFIT',
    'wardrobeId': 'wd_abc123',
    'outfitId': 'outfit_123',
    'sharePath': '/share/shr_outfittoken21charsx',
    'expiresAt': '2026-10-19T12:00:00.000Z',
    'createdAt': '2026-09-19T12:00:00.000Z',
  };

  late ScriptedHttpAdapter adapter;

  DioShareRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioShareRepository(dio);
  }

  test(
    'createItemShare posts the item path with no body and maps 201',
    () async {
      final repository = buildRepository([
        const HttpScript(statusCode: 201, body: itemShare),
      ]);

      final result = await repository.createItemShare(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      );

      expect(result.resourceType, ShareResourceType.item);
      expect(result.token, 'shr_itemtoken21charsxx');
      expect(adapter.requests.single.method, 'POST');
      expect(
        adapter.requests.single.path,
        ShareContract.itemPath(wardrobeId: 'wd_abc123', itemId: 'item_xyz123'),
      );
      expect(adapter.requests.single.data, isNull);
    },
  );

  test('createOutfitShare posts the outfit path and maps 201', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 201, body: outfitShare),
    ]);

    final result = await repository.createOutfitShare(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result.resourceType, ShareResourceType.outfit);
    expect(result.outfitId, 'outfit_123');
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      ShareContract.outfitPath(wardrobeId: 'wd_abc123', outfitId: 'outfit_123'),
    );
  });

  test('createItemShare maps 404 ITEM_NOT_FOUND', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {'code': 'ITEM_NOT_FOUND', 'message': 'Item not found.'},
      ),
    ]);

    expect(
      () => repository.createItemShare(
        wardrobeId: 'wd_abc123',
        itemId: 'item_missing',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'ITEM_NOT_FOUND')
            .having((error) => error.statusCode, 'statusCode', 404),
      ),
    );
  });

  test('createItemShare maps 401', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 401,
        body: {'code': 'UNAUTHENTICATED', 'message': 'Sign in.'},
      ),
    ]);

    expect(
      () => repository.createItemShare(
        wardrobeId: 'wd_abc123',
        itemId: 'item_xyz123',
      ),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          ShareErrors.unauthenticatedCode,
        ),
      ),
    );
  });

  test('revokeShare deletes the token path and accepts 204', () async {
    final repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.revokeShare('shr_itemtoken21charsxx');

    expect(adapter.requests.single.method, 'DELETE');
    expect(
      adapter.requests.single.path,
      ShareContract.revokePath('shr_itemtoken21charsxx'),
    );
  });

  test('revokeShare treats 404 as idempotent success', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {'code': 'SHARE_NOT_FOUND', 'message': 'Gone.'},
      ),
    ]);

    await repository.revokeShare('shr_already_gone');
    expect(adapter.requests, hasLength(1));
  });

  test('liveEnabled is on for wardrobe-backend#54 a7a10ab on main', () {
    expect(ShareContract.liveEnabled, isTrue);
    expect(ShareContract.backendSha, 'a7a10ab');
  });

  test('stub never invents a token', () async {
    const stub = StubShareRepository();
    expect(
      () =>
          stub.createItemShare(wardrobeId: 'wd_abc123', itemId: 'item_xyz123'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          ShareErrors.unavailable,
        ),
      ),
    );
    await stub.revokeShare('shr_x');
  });
}
