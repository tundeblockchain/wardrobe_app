import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/profile/data/dio_support_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  late ScriptedHttpAdapter adapter;
  late DioSupportRepository repository;

  DioSupportRepository buildRepository(List<HttpScript> scripts) {
    adapter = ScriptedHttpAdapter(scripts);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    return DioSupportRepository(dio);
  }

  test('sendContact posts WARDROBE-38 contact contract', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 202,
        body: {'status': 'sent', 'kind': 'contact', 'id': 'email_1'},
      ),
    ]);

    await repository.sendContact(
      subject: 'Hello',
      body: 'Please help with my wardrobe.',
      replyTo: 'user@example.com',
      meta: {
        'appVersion': '1.0.0+1',
        'platform': 'android',
        'deviceModel': 'Pixel 8',
        'osVersion': '14',
      },
    );

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/support/contact');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer token');
    expect(_requestBody(adapter.requests.single), {
      'subject': 'Hello',
      'body': 'Please help with my wardrobe.',
      'replyTo': 'user@example.com',
      'meta': {
        'appVersion': '1.0.0+1',
        'platform': 'android',
        'deviceModel': 'Pixel 8',
        'osVersion': '14',
      },
    });
  });

  test('sendBug posts WARDROBE-38 bug contract', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 202,
        body: {'status': 'sent', 'kind': 'bug'},
      ),
    ]);

    await repository.sendBug(
      subject: 'Crash',
      body: 'The add-item screen froze after picking a photo.',
      replyTo: 'user@example.com',
      meta: {'appVersion': '1.0.0+1', 'platform': 'ios'},
    );

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/support/bug');
    expect(_requestBody(adapter.requests.single), {
      'subject': 'Crash',
      'body': 'The add-item screen froze after picking a photo.',
      'replyTo': 'user@example.com',
      'meta': {'appVersion': '1.0.0+1', 'platform': 'ios'},
    });
  });

  test('omits optional fields when they are null', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 202,
        body: {'status': 'sent', 'kind': 'contact'},
      ),
    ]);

    await repository.sendContact(
      subject: 'Hello',
      body: 'Please help with my wardrobe.',
    );

    expect(_requestBody(adapter.requests.single), {
      'subject': 'Hello',
      'body': 'Please help with my wardrobe.',
    });
    expect(
      _requestBody(adapter.requests.single).containsKey('message'),
      isFalse,
    );
  });

  test('maps nested backend error envelope to ApiException', () async {
    repository = buildRepository([
      const HttpScript(
        statusCode: 404,
        body: {
          'error': {'code': 'NOT_FOUND', 'message': 'Not found.'},
        },
      ),
    ]);

    expect(
      () => repository.sendContact(
        subject: 'Hello',
        body: 'Please help with my wardrobe.',
      ),
      throwsA(
        isA<ApiException>()
            .having((error) => error.code, 'code', 'NOT_FOUND')
            .having((error) => error.statusCode, 'statusCode', 404),
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
