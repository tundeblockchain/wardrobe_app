import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/auth_interceptor.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';

class _FakeTokenSource implements IdTokenSource {
  _FakeTokenSource(this.token);

  String? token;
  int calls = 0;

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    calls++;
    return token;
  }
}

class _RecordingAdapter implements HttpClientAdapter {
  RequestOptions? lastOptions;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastOptions = options;
    return ResponseBody.fromString(
      '{}',
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('AuthInterceptor', () {
    test('attaches Bearer token when signed in', () async {
      final tokens = _FakeTokenSource('id-token-123');
      final adapter = _RecordingAdapter();
      final dio = createDioClient(
        baseUrl: 'https://api.example.com',
        tokenSource: tokens,
      );
      dio.httpClientAdapter = adapter;

      await dio.get<void>('/wardrobes');

      expect(
        adapter.lastOptions?.headers[AuthInterceptor.authorizationHeader],
        'Bearer id-token-123',
      );
      expect(tokens.calls, 1);
    });

    test('omits Authorization when signed out', () async {
      final tokens = _FakeTokenSource(null);
      final adapter = _RecordingAdapter();
      final dio = createDioClient(
        baseUrl: 'https://api.example.com',
        tokenSource: tokens,
      );
      dio.httpClientAdapter = adapter;

      await dio.get<void>('/health');

      expect(
        adapter.lastOptions?.headers[AuthInterceptor.authorizationHeader],
        isNull,
      );
    });

    test(
      'fetches a fresh token on every request and does not persist it',
      () async {
        final tokens = _FakeTokenSource('first');
        final adapter = _RecordingAdapter();
        final dio = createDioClient(
          baseUrl: 'https://api.example.com',
          tokenSource: tokens,
        );
        dio.httpClientAdapter = adapter;

        await dio.get<void>('/one');
        expect(
          adapter.lastOptions?.headers[AuthInterceptor.authorizationHeader],
          'Bearer first',
        );

        tokens.token = 'second';
        await dio.get<void>('/two');
        expect(
          adapter.lastOptions?.headers[AuthInterceptor.authorizationHeader],
          'Bearer second',
        );
        expect(tokens.calls, 2);
      },
    );

    test('skips empty tokens', () async {
      final tokens = _FakeTokenSource('');
      final adapter = _RecordingAdapter();
      final dio = createDioClient(
        baseUrl: 'https://api.example.com',
        tokenSource: tokens,
      );
      dio.httpClientAdapter = adapter;

      await dio.get<void>('/empty');

      expect(
        adapter.lastOptions?.headers[AuthInterceptor.authorizationHeader],
        isNull,
      );
    });
  });
}
