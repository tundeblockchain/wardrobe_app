import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/data/ai_profile_body_mapping.dart';
import 'package:wardrobe_app/features/ai_profiles/data/ai_profile_dtos.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';

void main() {
  const personalJson = {
    'aiProfileId': 'profile_abc123xyz0',
    'type': 'PERSONAL',
    'referenceImages': <String>[
      'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
    ],
    'status': 'READY',
    'createdAt': '2026-09-06T08:00:00.000Z',
    'updatedAt': '2026-09-06T08:00:00.000Z',
  };

  const filledBody = AiProfileBodyContext(
    heightCm: 170,
    weightKg: 65.5,
    bustCm: 90,
    hipsCm: 100.5,
    clothingSize: 'M',
    braSize: '34B',
    ageYears: 28,
    bodyType: 'AVERAGE',
    gender: 'FEMALE',
  );

  test('missing WARDROBE-80 keys map to an empty body context', () {
    expect(parseAiProfileBodyContext(personalJson), AiProfileBodyContext.empty);
    expect(aiProfileBodyContextToJson(AiProfileBodyContext.empty), isEmpty);
    expect(
      aiProfileBodyContextWireKeys,
      containsAll(['heightCm', 'braSize', 'gender']),
    );
  });

  test('reads the WARDROBE-80 contract keys when present', () {
    final context = parseAiProfileBodyContext({
      ...personalJson,
      'heightCm': 170,
      'weightKg': '65.5',
      'bustCm': 90,
      'hipsCm': 100.5,
      'clothingSize': 'M',
      'braSize': '34B',
      'ageYears': 28,
      'bodyType': 'AVERAGE',
      'gender': 'FEMALE',
      'unknownField': 'ignore-me',
    });

    expect(context, filledBody);
  });

  test('toJson emits only filled WARDROBE-80 names', () {
    expect(
      aiProfileBodyContextToJson(
        const AiProfileBodyContext(
          heightCm: 170,
          clothingSize: 'M',
          weightKg: 65.5,
        ),
      ),
      {'heightCm': 170, 'clothingSize': 'M', 'weightKg': 65.5},
    );
    expect(
      aiProfileBodyContextToJson(const AiProfileBodyContext(braSize: '34B')),
      {'braSize': '34B'},
    );
    expect(
      aiProfileBodyContextToJson(const AiProfileBodyContext(braSize: '  ')),
      isEmpty,
    );
  });

  test('PATCH JSON always includes every contract key, null to clear', () {
    expect(aiProfileBodyContextToPatchJson(AiProfileBodyContext.empty), {
      'heightCm': null,
      'weightKg': null,
      'bustCm': null,
      'hipsCm': null,
      'clothingSize': null,
      'braSize': null,
      'ageYears': null,
      'bodyType': null,
      'gender': null,
    });
    expect(aiProfileBodyContextToPatchJson(filledBody), {
      'heightCm': 170,
      'weightKg': 65.5,
      'bustCm': 90,
      'hipsCm': 100.5,
      'clothingSize': 'M',
      'ageYears': 28,
      'bodyType': 'AVERAGE',
      'gender': 'FEMALE',
      'braSize': '34B',
    });
  });

  test(
    'list/get mapping attaches body context without changing empty create',
    () {
      final domain = mapAiProfileJson({
        ...personalJson,
        'heightCm': 170,
        'ageYears': 28,
        'clothingSize': '10',
      });

      expect(domain.id, 'profile_abc123xyz0');
      expect(domain.bodyContext.heightCm, 170);
      expect(domain.bodyContext.ageYears, 28);
      expect(domain.bodyContext.clothingSize, '10');
      expect(
        parseAiProfileBodyContext({...personalJson, 'braSize': '34B'}).braSize,
        '34B',
      );
      expect(domain.canUseForTryOn, isTrue);
      expect(const CreateAiProfileRequest().toJson(), {'type': 'PERSONAL'});
    },
  );

  test('keeps frontImageUrl when WARDROBE-80 fields are present', () {
    final domain = mapAiProfileJson({
      ...personalJson,
      'frontImageUrl': 'https://cdn.example.com/front.png',
      'heightCm': 170,
      'gender': 'FEMALE',
    });

    expect(domain.previewImageUrl, 'https://cdn.example.com/front.png');
    expect(domain.bodyContext.heightCm, 170);
    expect(domain.bodyContext.gender, 'FEMALE');
  });

  test('empty body context does not block try-on', () {
    final domain = mapAiProfileJson(personalJson);
    expect(domain.bodyContext.isEmpty, isTrue);
    expect(domain.canUseForTryOn, isTrue);
    expect(domain.status, AiProfileStatus.ready);
  });

  test('invalid numeric strings are skipped, not thrown', () {
    final context = parseAiProfileBodyContext({
      'heightCm': 'tall',
      'ageYears': 'twenty',
      'clothingSize': '  ',
      'braSize': '  ',
    });
    expect(context, AiProfileBodyContext.empty);
  });
}
