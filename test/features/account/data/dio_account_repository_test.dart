import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/account/data/dio_account_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const summary = {
    'keepAccount': true,
    'deletedWardrobes': 1,
    'deletedItems': 2,
    'deletedOutfits': 1,
    'deletedS3Objects': 3,
    's3Failures': 0,
  };

  late ScriptedHttpAdapter adapter;
  late DioAccountRepository repository;

  DioAccountRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioAccountRepository(dio);
  }

  test('clearContent deletes /me/content and maps the summary', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 200, body: summary),
    ]);

    final result = await repository.clearContent();

    expect(result.keepAccount, isTrue);
    expect(result.deletedWardrobes, 1);
    expect(result.deletedItems, 2);
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/me/content');
  });

  test('deleteAccount deletes /me with keepAccount false', () async {
    repository = buildRepository([
      HttpScript(statusCode: 200, body: {...summary, 'keepAccount': false}),
    ]);

    final result = await repository.deleteAccount();

    expect(result.keepAccount, isFalse);
    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/me');
  });

  test('empty account still returns 200 zeros', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 200,
        body: {
          'keepAccount': true,
          'deletedWardrobes': 0,
          'deletedItems': 0,
          'deletedOutfits': 0,
          'deletedS3Objects': 0,
          's3Failures': 0,
        },
      ),
    ]);

    final result = await repository.clearContent();
    expect(result.deletedWardrobes, 0);
    expect(result.deletedItems, 0);
  });

  test('maps UNAUTHENTICATED to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 401,
        body: {'code': 'UNAUTHENTICATED', 'message': 'Missing token.'},
      ),
    ]);

    expect(
      () => repository.clearContent(),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'UNAUTHENTICATED')
            .having((error) => error.statusCode, 'statusCode', 401),
      ),
    );
  });

  test('rejects a non-object wipe body', () async {
    repository = buildRepository([const HttpScript(statusCode: 200, body: '')]);

    expect(
      () => repository.deleteAccount(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'INVALID_RESPONSE',
        ),
      ),
    );
  });
}
