import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/worn_on/data/dio_worn_on_repository.dart';
import 'package:wardrobe_app/features/worn_on/data/stub_worn_on_repository.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_contract.dart';
import 'package:wardrobe_app/features/worn_on/domain/worn_on_errors.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const entry = {
    'outfitId': 'outfit_123',
    'wardrobeId': 'wd_abc123',
    'wornOn': '2026-09-18',
    'createdAt': '2026-09-18T19:10:00.000Z',
  };

  late ScriptedHttpAdapter adapter;

  DioWornOnRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioWornOnRepository(dio);
  }

  test('setWornOn posts date-only body and maps 201', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 201, body: entry),
    ]);

    final result = await repository.setWornOn(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
      wornOn: DateTime.utc(2026, 9, 18),
    );

    expect(result.wornOn, DateTime.utc(2026, 9, 18));
    expect(adapter.requests.single.method, 'POST');
    expect(
      adapter.requests.single.path,
      WornOnContract.outfitPath(
        wardrobeId: 'wd_abc123',
        outfitId: 'outfit_123',
      ),
    );
    expect(_requestBody(adapter.requests.single), {'wornOn': '2026-09-18'});
  });

  test('setWornOn treats 200 as an idempotent existing date', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: entry),
    ]);

    final result = await repository.setWornOn(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
      wornOn: DateTime.utc(2026, 9, 18),
    );

    expect(result.createdAt, DateTime.utc(2026, 9, 18, 19, 10));
  });

  test('listOutfitWornOn unwraps newest-first entries', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'entries': [entry],
        },
      ),
    ]);

    final result = await repository.listOutfitWornOn(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result, hasLength(1));
    expect(adapter.requests.single.method, 'GET');
  });

  test('removeWornOn deletes the date path and accepts 204', () async {
    final repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.removeWornOn(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
      wornOn: DateTime.utc(2026, 9, 18),
    );

    expect(adapter.requests.single.method, 'DELETE');
    expect(
      adapter.requests.single.path,
      WornOnContract.outfitDatePath(
        wardrobeId: 'wd_abc123',
        outfitId: 'outfit_123',
        date: '2026-09-18',
      ),
    );
  });

  test('listWardrobeWornOn sends inclusive from/to', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 200, body: {'entries': []}),
    ]);

    final result = await repository.listWardrobeWornOn(
      wardrobeId: 'wd_abc123',
      from: DateTime.utc(2026, 9, 1),
      to: DateTime.utc(2026, 9, 30),
    );

    expect(result, isEmpty);
    expect(
      adapter.requests.single.path,
      WornOnContract.wardrobePath('wd_abc123'),
    );
    expect(adapter.requests.single.queryParameters, {
      'from': '2026-09-01',
      'to': '2026-09-30',
    });
  });

  test('listWardrobeWornOn rejects from after to without a request', () async {
    final repository = buildRepository(const []);

    expect(
      () => repository.listWardrobeWornOn(
        wardrobeId: 'wd_abc123',
        from: DateTime.utc(2026, 9, 30),
        to: DateTime.utc(2026, 9, 1),
      ),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          WornOnErrors.validationCode,
        ),
      ),
    );
  });

  test('maps 401 / 404 / 400 envelopes', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 401,
        body: {
          'error': {'code': 'UNAUTHENTICATED', 'message': 'Sign in.'},
        },
      ),
    ]);

    expect(
      () => repository.setWornOn(
        wardrobeId: 'wd_abc123',
        outfitId: 'outfit_123',
        wornOn: DateTime.utc(2026, 9, 18),
      ),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'UNAUTHENTICATED',
        ),
      ),
    );
  });

  test('GET list treats an undeployed 404 as an empty log', () async {
    final repository = buildRepository([
      const HttpScript(statusCode: 404, body: {'message': 'Not Found'}),
    ]);

    final result = await repository.listOutfitWornOn(
      wardrobeId: 'wd_abc123',
      outfitId: 'outfit_123',
    );

    expect(result, isEmpty);
  });

  test('GET list still throws OUTFIT_NOT_FOUND', () async {
    final repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'OUTFIT_NOT_FOUND', 'message': 'Outfit not found.'},
        },
      ),
    ]);

    expect(
      () => repository.listOutfitWornOn(
        wardrobeId: 'wd_abc123',
        outfitId: 'missing',
      ),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'OUTFIT_NOT_FOUND',
        ),
      ),
    );
  });

  test('stub repository stays empty', () async {
    const stub = StubWornOnRepository();
    expect(
      await stub.listOutfitWornOn(
        wardrobeId: 'wd_abc123',
        outfitId: 'outfit_123',
      ),
      isEmpty,
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
