import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/auth_interceptor.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/items/data/dio_upload_repository.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  late ScriptedHttpAdapter apiAdapter;
  late ScriptedHttpAdapter uploadAdapter;
  late DioUploadRepository repository;

  DioUploadRepository buildRepository({
    required List<HttpScript> apiScripts,
    List<HttpScript> uploadScripts = const [],
  }) {
    apiAdapter = ScriptedHttpAdapter(apiScripts);
    uploadAdapter = ScriptedHttpAdapter(uploadScripts);
    final api = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    api.httpClientAdapter = apiAdapter;
    final upload = createUploadDio();
    upload.httpClientAdapter = uploadAdapter;
    return DioUploadRepository(api: api, uploadClient: upload);
  }

  test('createWardrobeItemUpload posts the contract body', () async {
    repository = buildRepository(
      apiScripts: [
        const HttpScript(
          statusCode: 201,
          body: {
            'uploadUrl': 'https://s3.example.com/put',
            'objectKey': 'users/uid/uploads/uuid.jpg',
            'expiresIn': 900,
          },
        ),
      ],
    );

    final ticket = await repository.createWardrobeItemUpload(
      contentType: 'image/jpeg',
    );

    expect(ticket.objectKey, 'users/uid/uploads/uuid.jpg');
    expect(ticket.expiresIn, 900);
    expect(apiAdapter.requests.single.method, 'POST');
    expect(apiAdapter.requests.single.path, '/uploads');
    expect(_requestBody(apiAdapter.requests.single), {
      'contentType': 'image/jpeg',
      'purpose': 'WARDROBE_ITEM',
    });
    expect(
      apiAdapter.requests.single.headers[AuthInterceptor.authorizationHeader],
      'Bearer token',
    );
  });

  test(
    'uploadFile PUTs bytes with the exact content-type and no Bearer',
    () async {
      repository = buildRepository(
        apiScripts: const [],
        uploadScripts: [const HttpScript(statusCode: 200)],
      );
      final bytes = Uint8List.fromList([1, 2, 3, 4]);

      await repository.uploadFile(
        uploadUrl: 'https://s3.example.com/bucket/key',
        bytes: bytes,
        contentType: 'image/jpeg',
      );

      final request = uploadAdapter.requests.single;
      expect(request.method, 'PUT');
      expect(request.uri.toString(), 'https://s3.example.com/bucket/key');
      expect(request.data, bytes);
      expect(request.headers[Headers.contentTypeHeader], 'image/jpeg');
      expect(request.headers[AuthInterceptor.authorizationHeader], isNull);
    },
  );

  test('maps upload API errors to ApiException', () async {
    repository = buildRepository(
      apiScripts: [
        const HttpScript(
          statusCode: 400,
          body: {
            'error': {
              'code': 'UPLOAD_INVALID',
              'message': 'purpose must be WARDROBE_ITEM.',
            },
          },
        ),
      ],
    );

    expect(
      () => repository.createWardrobeItemUpload(contentType: 'text/plain'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'UPLOAD_INVALID',
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
