import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/ai_profiles/data/ai_profile_dtos.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';

void main() {
  final personalJson = {
    'aiProfileId': 'profile_abc123xyz0',
    'type': 'PERSONAL',
    'referenceImages': <String>[],
    'status': 'READY',
    'createdAt': '2026-09-06T08:00:00.000Z',
    'updatedAt': '2026-09-06T08:00:00.000Z',
  };

  final genericJson = {
    'aiProfileId': 'profile_generic_01',
    'type': 'GENERIC_MODEL',
    'label': 'Alex',
    'referenceImages': ['shared/ai-profiles/generic/alex/front.jpg'],
    'status': 'READY',
    'createdAt': '2026-09-06T00:00:00.000Z',
    'updatedAt': '2026-09-06T00:00:00.000Z',
  };

  group('AiProfileResponse', () {
    test('maps aiProfileId to domain id without leaking backend names', () {
      final domain = AiProfileResponse.fromJson(personalJson).toDomain();

      expect(domain.id, 'profile_abc123xyz0');
      expect(domain.type, AiProfileType.personal);
      expect(domain.label, isNull);
      expect(domain.referenceImages, isEmpty);
      expect(domain.status, AiProfileStatus.ready);
      expect(domain.displayName, 'Your profile');
      expect(domain.toString(), isNot(contains('aiProfileId')));
    });

    test('maps optional label on seeded GENERIC_MODEL rows', () {
      final domain = AiProfileResponse.fromJson(genericJson).toDomain();

      expect(domain.id, 'profile_generic_01');
      expect(domain.type, AiProfileType.genericModel);
      expect(domain.label, 'Alex');
      expect(domain.displayName, 'Alex');
      expect(domain.referenceImages, [
        'shared/ai-profiles/generic/alex/front.jpg',
      ]);
      expect(domain.pickerImageUrl, isNull);
    });

    test('maps a frontal http(s) reference after WARDROBE-72 style URLs', () {
      final domain = AiProfileResponse.fromJson({
        ...genericJson,
        'referenceImages': [
          'https://cdn.example.com/alex/side.jpg',
          'https://cdn.example.com/alex/front.png',
        ],
      }).toDomain();

      expect(domain.pickerImageUrl, 'https://cdn.example.com/alex/front.png');
    });

    test('keeps PERSONAL picker empty when only S3 keys are present', () {
      final domain = AiProfileResponse.fromJson({
        ...personalJson,
        'referenceImages': ['users/uid/ai-profiles/profile_abc123xyz0/ref.jpg'],
      }).toDomain();

      expect(domain.referenceImages, hasLength(1));
      expect(domain.pickerImageUrl, isNull);
    });

    test('parses PROCESSING and FAILED statuses', () {
      expect(
        AiProfileResponse.fromJson({...personalJson, 'status': 'PROCESSING'})
            .toDomain()
            .status,
        AiProfileStatus.processing,
      );
      expect(
        AiProfileResponse.fromJson({...personalJson, 'status': 'FAILED'})
            .toDomain()
            .status,
        AiProfileStatus.failed,
      );
    });

    test('defaults missing status to ready', () {
      final payload = Map<String, dynamic>.from(personalJson)..remove('status');
      expect(
        AiProfileResponse.fromJson(payload).toDomain().status,
        AiProfileStatus.ready,
      );
    });

    test('rejects an unknown type', () {
      expect(
        () =>
            AiProfileResponse.fromJson({...personalJson, 'type': 'OTHER'})
                .toDomain(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.code,
            'code',
            'INVALID_RESPONSE',
          ),
        ),
      );
    });
  });

  group('AiProfileListResponse', () {
    test('maps nested aiProfiles array to domain list', () {
      final domain = AiProfileListResponse.fromJson({
        'aiProfiles': [personalJson, genericJson],
      }).toDomain();

      expect(domain, hasLength(2));
      expect(domain.first.id, 'profile_abc123xyz0');
      expect(domain.last.label, 'Alex');
    });
  });

  group('write request DTOs', () {
    test('create sends PERSONAL', () {
      expect(const CreateAiProfileRequest().toJson(), {'type': 'PERSONAL'});
    });

    test('upload includes purpose and optional contentLength', () {
      expect(
        const CreateAiProfileUploadRequest(
          contentType: 'image/jpeg',
          contentLength: 2048,
        ).toJson(),
        {
          'contentType': 'image/jpeg',
          'purpose': 'AI_PROFILE_REFERENCE',
          'contentLength': 2048,
        },
      );
    });

    test('upload omits contentLength when null', () {
      expect(
        const CreateAiProfileUploadRequest(contentType: 'image/png').toJson(),
        {'contentType': 'image/png', 'purpose': 'AI_PROFILE_REFERENCE'},
      );
    });

    test('attach serializes objectKey or objectKeys', () {
      expect(
        const AttachAiProfileImagesRequest(
          objectKey: 'users/uid/ai-profiles/p/a.jpg',
        ).toJson(),
        {'objectKey': 'users/uid/ai-profiles/p/a.jpg'},
      );
      expect(
        const AttachAiProfileImagesRequest(
          objectKeys: ['users/uid/ai-profiles/p/a.jpg'],
        ).toJson(),
        {
          'objectKeys': ['users/uid/ai-profiles/p/a.jpg'],
        },
      );
    });
  });
}
