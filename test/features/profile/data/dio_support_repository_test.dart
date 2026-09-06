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

  test('sendContact posts subject, message, and optional context', () async {
    repository = buildRepository([const HttpScript(statusCode: 204)]);

    await repository.sendContact(
      subject: 'Hello',
      message: 'Please help with my wardrobe.',
      device: 'Pixel 8 (Android 14)',
      appVersion: '1.0.0+1',
    );

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/support/contact');
    expect(adapter.requests.single.headers['Authorization'], 'Bearer token');
    expect(_requestBody(adapter.requests.single), {
      'subject': 'Hello',
      'message': 'Please help with my wardrobe.',
      'device': 'Pixel 8 (Android 14)',
      'appVersion': '1.0.0+1',
    });
  });

  test('sendBug posts to /support/bug with bug context', () async {
    repository = buildRepository([
      const HttpScript(statusCode: 201, body: {'id': 'sup_1'}),
    ]);

    await repository.sendBug(
      subject: 'Crash',
      message: 'The add-item screen froze after picking a photo.',
      device: 'iOS 18.0',
      appVersion: '1.0.0+1',
    );

    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/support/bug');
    expect(_requestBody(adapter.requests.single), {
      'subject': 'Crash',
      'message': 'The add-item screen froze after picking a photo.',
      'device': 'iOS 18.0',
      'appVersion': '1.0.0+1',
    });
  });

  test('omits optional fields when they are null', () async {
    repository = buildRepository([const HttpScript(statusCode: 200, body: {})]);

    await repository.sendContact(
      subject: 'Hello',
      message: 'Please help with my wardrobe.',
    );

    expect(_requestBody(adapter.requests.single), {
      'subject': 'Hello',
      'message': 'Please help with my wardrobe.',
    });
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
        message: 'Please help with my wardrobe.',
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
