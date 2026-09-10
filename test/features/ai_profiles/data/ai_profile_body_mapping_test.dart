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

  test('missing WARDROBE-80 keys map to an empty body context', () {
    expect(parseAiProfileBodyContext(personalJson), AiProfileBodyContext.empty);
    expect(aiProfileBodyContextToJson(AiProfileBodyContext.empty), isEmpty);
  });

  test('reads the WARDROBE-80 pairing-set keys when present', () {
    final context = parseAiProfileBodyContext({
      ...personalJson,
      'height': 170,
      'age': 28,
      'bust': 90,
      'hips': 100.5,
      'size': 'M',
      'weight': '65',
      'unknownField': 'ignore-me',
    });

    expect(
      context,
      const AiProfileBodyContext(
        height: 170,
        age: 28,
        bust: 90,
        hips: 100.5,
        size: 'M',
        weight: 65,
      ),
    );
  });

  test('toJson emits only filled WARDROBE-80 names', () {
    expect(
      aiProfileBodyContextToJson(
        const AiProfileBodyContext(height: 170, size: 'M', weight: 65.5),
      ),
      {'height': 170, 'size': 'M', 'weight': 65.5},
    );
  });

  test(
    'list/get mapping attaches body context without changing create DTO',
    () {
      final domain = mapAiProfileJson({
        ...personalJson,
        'height': 170,
        'age': 28,
        'size': '10',
      });

      expect(domain.id, 'profile_abc123xyz0');
      expect(domain.bodyContext.height, 170);
      expect(domain.bodyContext.age, 28);
      expect(domain.bodyContext.size, '10');
      expect(domain.canUseForTryOn, isTrue);
      expect(const CreateAiProfileRequest().toJson(), {'type': 'PERSONAL'});
    },
  );

  test('empty body context does not block try-on', () {
    final domain = mapAiProfileJson(personalJson);
    expect(domain.bodyContext.isEmpty, isTrue);
    expect(domain.canUseForTryOn, isTrue);
    expect(domain.status, AiProfileStatus.ready);
  });

  test('invalid numeric strings are skipped, not thrown', () {
    final context = parseAiProfileBodyContext({
      'height': 'tall',
      'age': 'twenty',
      'size': '  ',
    });
    expect(context, AiProfileBodyContext.empty);
  });
}
