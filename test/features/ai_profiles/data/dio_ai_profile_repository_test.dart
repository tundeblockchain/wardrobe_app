import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/core/network/dio_client.dart';
import 'package:wardrobe_app/core/network/id_token_source.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';

import '../../../helpers/scripted_http_adapter.dart';

class _TokenSource implements IdTokenSource {
  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'token';
}

void main() {
  const personal = {
    'aiProfileId': 'profile_abc123xyz0',
    'type': 'PERSONAL',
    'referenceImages': <String>[],
    'status': 'READY',
    'createdAt': '2026-09-06T08:00:00.000Z',
    'updatedAt': '2026-09-06T08:00:00.000Z',
  };

  const alex = {
    'aiProfileId': 'profile_generic_01',
    'type': 'GENERIC_MODEL',
    'label': 'Alex',
    'referenceImages': ['shared/ai-profiles/generic/alex/front.jpg'],
    'status': 'READY',
    'createdAt': '2026-09-06T00:00:00.000Z',
    'updatedAt': '2026-09-06T00:00:00.000Z',
  };

  late ScriptedHttpAdapter adapter;
  late ScriptedHttpAdapter uploadAdapter;
  late DioAiProfileRepository repository;

  DioAiProfileRepository buildRepository({
    required List<HttpScript> api,
    List<HttpScript> uploads = const [],
  }) {
    adapter = ScriptedHttpAdapter(api);
    uploadAdapter = ScriptedHttpAdapter(uploads);
    final dio = createDioClient(
      baseUrl: 'https://api.example.com',
      tokenSource: _TokenSource(),
    );
    dio.httpClientAdapter = adapter;
    final uploadDio = createUploadDio();
    uploadDio.httpClientAdapter = uploadAdapter;
    return DioAiProfileRepository(api: dio, uploadClient: uploadDio);
  }

  test('listPersonal unwraps { aiProfiles: [...] }', () async {
    repository = buildRepository(
      api: [
        const HttpScript(
          statusCode: 200,
          body: {
            'aiProfiles': [personal],
          },
        ),
      ],
    );

    final result = await repository.listPersonal();

    expect(result, hasLength(1));
    expect(result.single.id, 'profile_abc123xyz0');
    expect(adapter.requests.single.method, 'GET');
    expect(adapter.requests.single.path, '/ai-profiles');
    expect(adapter.requests.single.queryParameters, isEmpty);
  });

  test('listGenericModels hits /ai-profiles/models', () async {
    repository = buildRepository(
      api: [
        const HttpScript(
          statusCode: 200,
          body: {
            'aiProfiles': [alex],
          },
        ),
      ],
    );

    final result = await repository.listGenericModels();

    expect(result.single.id, 'profile_generic_01');
    expect(result.single.label, 'Alex');
    expect(result.single.pickerImageUrl, isNull);
    expect(adapter.requests.single.path, '/ai-profiles/models');
  });

  test(
    'listGenericModels prefers a frontal URL when get/list returns one',
    () async {
      repository = buildRepository(
        api: [
          HttpScript(
            statusCode: 200,
            body: {
              'aiProfiles': [
                {
                  ...alex,
                  'referenceImages': [
                    'shared/ai-profiles/generic/alex/front.jpg',
                  ],
                  'frontImageUrl': 'https://cdn.example.com/alex/front.png',
                },
              ],
            },
          ),
        ],
      );

      final result = await repository.listGenericModels();

      expect(
        result.single.pickerImageUrl,
        'https://cdn.example.com/alex/front.png',
      );
      expect(result.single.referenceImages, [
        'shared/ai-profiles/generic/alex/front.jpg',
      ]);
    },
  );

  test('listPersonal accepts a bare array', () async {
    repository = buildRepository(
      api: [
        const HttpScript(statusCode: 200, body: [personal]),
      ],
    );

    final result = await repository.listPersonal();
    expect(result.single.type, AiProfileType.personal);
  });

  test('getProfile maps aiProfileId to domain id', () async {
    repository = buildRepository(
      api: [const HttpScript(statusCode: 200, body: personal)],
    );

    final result = await repository.getProfile('profile_abc123xyz0');

    expect(result.id, 'profile_abc123xyz0');
    expect(adapter.requests.single.path, '/ai-profiles/profile_abc123xyz0');
  });

  test('createPersonal posts PERSONAL and maps the response', () async {
    repository = buildRepository(
      api: [const HttpScript(statusCode: 201, body: personal)],
    );

    final result = await repository.createPersonal();

    expect(result.status, AiProfileStatus.ready);
    expect(adapter.requests.single.method, 'POST');
    expect(adapter.requests.single.path, '/ai-profiles');
    expect(_requestBody(adapter.requests.single), {'type': 'PERSONAL'});
  });

  test('createPersonal sends filled WARDROBE-80 fields only', () async {
    repository = buildRepository(
      api: [
        HttpScript(
          statusCode: 201,
          body: {...personal, 'heightCm': 170, 'gender': 'FEMALE'},
        ),
      ],
    );

    final result = await repository.createPersonal(
      body: const AiProfileBodyContext(heightCm: 170, gender: 'FEMALE'),
    );

    expect(result.bodyContext.heightCm, 170);
    expect(result.bodyContext.gender, 'FEMALE');
    expect(_requestBody(adapter.requests.single), {
      'type': 'PERSONAL',
      'heightCm': 170,
      'gender': 'FEMALE',
    });
  });

  test('updatePersonal PATCHes all WARDROBE-80 keys including nulls', () async {
    repository = buildRepository(
      api: [
        HttpScript(statusCode: 200, body: {...personal, 'heightCm': 170}),
      ],
    );

    final result = await repository.updatePersonal(
      aiProfileId: 'profile_abc123xyz0',
      body: const AiProfileBodyContext(heightCm: 170),
    );

    expect(result.bodyContext.heightCm, 170);
    expect(adapter.requests.single.method, 'PATCH');
    expect(adapter.requests.single.path, '/ai-profiles/profile_abc123xyz0');
    expect(_requestBody(adapter.requests.single), {
      'heightCm': 170,
      'weightKg': null,
      'bustCm': null,
      'hipsCm': null,
      'clothingSize': null,
      'braSize': null,
      'ageYears': null,
      'bodyType': null,
      'gender': null,
    });
  });

  test('listPersonal maps WARDROBE-80 fields and frontImageUrl', () async {
    repository = buildRepository(
      api: [
        HttpScript(
          statusCode: 200,
          body: {
            'aiProfiles': [
              {
                ...personal,
                'frontImageUrl': 'https://cdn.example.com/front.png',
                'heightCm': 168,
                'weightKg': 60,
                'clothingSize': '10',
              },
            ],
          },
        ),
      ],
    );

    final result = await repository.listPersonal();

    expect(result.single.previewImageUrl, 'https://cdn.example.com/front.png');
    expect(result.single.bodyContext.heightCm, 168);
    expect(result.single.bodyContext.weightKg, 60);
    expect(result.single.bodyContext.clothingSize, '10');
  });

  test('createPersonal and getProfile map braSize when present', () async {
    repository = buildRepository(
      api: [
        HttpScript(statusCode: 201, body: {...personal, 'braSize': '34B'}),
        HttpScript(statusCode: 200, body: {...personal, 'braSize': '34B'}),
      ],
    );

    final created = await repository.createPersonal(
      body: const AiProfileBodyContext(braSize: '34B'),
    );
    expect(created.bodyContext.braSize, '34B');
    expect(_requestBody(adapter.requests.first), {
      'type': 'PERSONAL',
      'braSize': '34B',
    });

    final fetched = await repository.getProfile('profile_abc123xyz0');
    expect(fetched.bodyContext.braSize, '34B');
  });

  test('deletePersonal accepts 204 with an empty body', () async {
    repository = buildRepository(api: [const HttpScript(statusCode: 204)]);

    await repository.deletePersonal('profile_abc123xyz0');

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/ai-profiles/profile_abc123xyz0');
  });

  test('createReferenceUpload posts the WARDROBE-44 contract', () async {
    repository = buildRepository(
      api: [
        const HttpScript(
          statusCode: 201,
          body: {
            'uploadUrl': 'https://s3.example.com/put',
            'objectKey': 'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
            'expiresIn': 900,
          },
        ),
      ],
    );

    final ticket = await repository.createReferenceUpload(
      aiProfileId: 'profile_abc123xyz0',
      contentType: 'image/jpeg',
      contentLength: 2048,
    );

    expect(
      ticket.objectKey,
      'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
    );
    expect(
      adapter.requests.single.path,
      '/ai-profiles/profile_abc123xyz0/uploads',
    );
    expect(_requestBody(adapter.requests.single), {
      'contentType': 'image/jpeg',
      'purpose': 'AI_PROFILE_REFERENCE',
      'contentLength': 2048,
    });
  });

  test('uploadFile PUTs bytes without using the API client', () async {
    repository = buildRepository(
      api: const [],
      uploads: [const HttpScript(statusCode: 200)],
    );

    await repository.uploadFile(
      uploadUrl: 'https://s3.example.com/put',
      bytes: Uint8List.fromList(const [1, 2, 3]),
      contentType: 'image/jpeg',
    );

    expect(adapter.requests, isEmpty);
    expect(uploadAdapter.requests.single.method, 'PUT');
    expect(
      uploadAdapter.requests.single.uri.toString(),
      'https://s3.example.com/put',
    );
  });

  test('attachReferenceImages posts objectKey and maps the profile', () async {
    repository = buildRepository(
      api: [
        HttpScript(
          statusCode: 200,
          body: {
            ...personal,
            'referenceImages': [
              'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
            ],
          },
        ),
      ],
    );

    final result = await repository.attachReferenceImages(
      aiProfileId: 'profile_abc123xyz0',
      objectKey: 'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
    );

    expect(result.referenceImages, [
      'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
    ]);
    expect(
      adapter.requests.single.path,
      '/ai-profiles/profile_abc123xyz0/reference-images',
    );
    expect(_requestBody(adapter.requests.single), {
      'objectKey': 'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
    });
  });

  test('maps nested backend error envelope to ApiException', () async {
    repository = buildRepository(
      api: [
        const HttpScript(
          statusCode: 404,
          body: {
            'error': {
              'code': 'AI_PROFILE_NOT_FOUND',
              'message': 'AI profile not found.',
            },
          },
        ),
      ],
    );

    expect(
      () => repository.getProfile('missing'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          'AI_PROFILE_NOT_FOUND',
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
