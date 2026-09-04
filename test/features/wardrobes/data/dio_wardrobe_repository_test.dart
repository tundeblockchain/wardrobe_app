import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const payload = {
    'wardrobeId': 'wd_abc123',
    'name': 'Summer Clothes',
    'createdAt': '2026-09-03T18:35:00Z',
    'updatedAt': '2026-09-03T18:35:00Z',
  };

  late ScriptedHttpAdapter adapter;
  late DioWardrobeRepository repository;

  DioWardrobeRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioWardrobeRepository(dio);
  }

  test('listWardrobes unwraps { wardrobes: [...] }', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'wardrobes': [payload],
        },
      ),
    ]);

    final result = await repository.listWardrobes();

    expect(result, hasLength(1));
    expect(result.single.id, 'wd_abc123');
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/wardrobes');
  });

  test('listWardrobes accepts a bare array', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: [payload]),
    ]);

    final result = await repository.listWardrobes();
    expect(result.single.name, 'Summer Clothes');
  });

  test('getWardrobe maps wardrobeId to domain id', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: payload),
    ]);

    final result = await repository.getWardrobe('wd_abc123');

    expect(result.id, 'wd_abc123');
    expect(adapter.requests.single.path, '/wardrobes/wd_abc123');
  });

  test('createWardrobe posts {name} and maps the response', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: payload),
    ]);

    final result = await repository.createWardrobe(name: 'Summer Clothes');

    expect(result.id, 'wd_abc123');
    expect(adapter.requests.single.method, 'POST');
    expect(_requestBody(adapter.requests.single), {'name': 'Summer Clothes'});
  });

  test('updateWardrobe patches {name}', () async {
    repository = buildRepository([
      HttpScript(statusCode: 200, body: {...payload, 'name': 'Work Clothes'}),
    ]);

    final result = await repository.updateWardrobe(
      id: 'wd_abc123',
      name: 'Work Clothes',
    );

    expect(result.name, 'Work Clothes');
    expect(adapter.requests.single.method, 'PATCH');
    expect(adapter.requests.single.path, '/wardrobes/wd_abc123');
  });

  test('deleteWardrobe accepts 204 with an empty body', () async {
    repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.deleteWardrobe('wd_abc123');

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/wardrobes/wd_abc123');
  });

  test('maps flat error envelope to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 400,
        body: {'code': 'VALIDATION_ERROR', 'message': 'name is required.'},
      ),
    ]);

    expect(
      () => repository.createWardrobe(name: ''),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'VALIDATION_ERROR')
            .having((error) => error.message, 'message', 'name is required.')
            .having((error) => error.statusCode, 'statusCode', 400),
      ),
    );
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
      () => repository.getWardrobe('missing'),
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
