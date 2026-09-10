import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_status_display.dart';

import '../../../helpers/fake_ai_profile_repository.dart';

void main() {
  test('maps READY / PROCESSING / FAILED for the UI', () {
    expect(AiProfileStatusDisplay.of(AiProfileStatus.ready).label, 'Ready');
    expect(
      AiProfileStatusDisplay.of(AiProfileStatus.processing).tone,
      AiProfileStatusTone.processing,
    );
    expect(AiProfileStatusDisplay.of(AiProfileStatus.failed).label, 'Failed');
    expect(AiProfileStatusDisplay.of(AiProfileStatus.pending).label, 'Pending');
  });

  test(
    'canUseForTryOn requires READY PERSONAL with photos or GENERIC_MODEL',
    () {
      expect(testGenericModel().canUseForTryOn, isTrue);
      expect(testPersonalProfile().canUseForTryOn, isFalse);
      expect(
        testPersonalProfile(referenceImages: const ['users/uid/ref.jpg'])
            .canUseForTryOn,
        isTrue,
      );
      expect(
        testPersonalProfile(referenceImages: const ['users/uid/ref.jpg'])
            .bodyContext
            .isEmpty,
        isTrue,
      );
    },
  );

  test('pickerImageUrl stays null for S3 keys and uses a stored URL', () {
    expect(testGenericModel().pickerImageUrl, isNull);
    expect(
      testPersonalProfile(
        referenceImages: const ['users/uid/ai-profiles/p/ref.jpg'],
      ).pickerImageUrl,
      isNull,
    );
    expect(
      testGenericModel(
        previewImageUrl: 'https://cdn.example.com/alex/front.png',
      ).pickerImageUrl,
      'https://cdn.example.com/alex/front.png',
    );
    expect(
      testPersonalProfile(
        referenceImages: const ['https://cdn.example.com/me/front.png'],
      ).pickerImageUrl,
      'https://cdn.example.com/me/front.png',
    );
  });
}
