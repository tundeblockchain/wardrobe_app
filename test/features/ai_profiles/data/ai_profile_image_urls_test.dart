import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/data/ai_profile_image_urls.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_preview.dart';

void main() {
  group('extractAiProfileImageUrl', () {
    test('returns null for current Backend keys-only get/list payload', () {
      expect(
        extractAiProfileImageUrl({
          'aiProfileId': 'profile_generic_01',
          'type': 'GENERIC_MODEL',
          'label': 'Alex',
          'referenceImages': ['shared/ai-profiles/generic/alex/front.jpg'],
          'status': 'READY',
          'createdAt': '2026-09-06T00:00:00.000Z',
          'updatedAt': '2026-09-06T00:00:00.000Z',
        }),
        isNull,
      );
      expect(
        extractAiProfileImageUrl({
          'aiProfileId': 'profile_abc123xyz0',
          'type': 'PERSONAL',
          'referenceImages': [
            'users/uid/ai-profiles/profile_abc123xyz0/ref.jpg',
          ],
          'status': 'READY',
          'createdAt': '2026-09-06T08:00:00.000Z',
          'updatedAt': '2026-09-06T08:00:00.000Z',
        }),
        isNull,
      );
    });

    test('prefers frontal http(s) in referenceImages after a path fix', () {
      expect(
        extractAiProfileImageUrl({
          'referenceImages': [
            'https://cdn.example.com/alex/side.jpg',
            'https://cdn.example.com/alex/front.png',
          ],
        }),
        'https://cdn.example.com/alex/front.png',
      );
    });

    test('uses dedicated URL aliases when Backend adds them', () {
      expect(
        extractAiProfileImageUrl({
          'referenceImages': ['shared/ai-profiles/generic/alex/front.jpg'],
          'frontImageUrl': 'https://cdn.example.com/alex/front.png',
        }),
        'https://cdn.example.com/alex/front.png',
      );
      expect(
        extractAiProfileImageUrl({
          'referenceImageUrls': ['https://cdn.example.com/me/ref.jpg'],
        }),
        'https://cdn.example.com/me/ref.jpg',
      );
    });

    test('reads url from object-shaped referenceImages entries', () {
      expect(
        extractAiProfileImageUrl({
          'referenceImages': [
            {
              'objectKey': 'shared/ai-profiles/generic/alex/front.jpg',
              'url': 'https://cdn.example.com/alex/front.jpg',
            },
          ],
        }),
        'https://cdn.example.com/alex/front.jpg',
      );
    });

    test('ignores uploadUrl PUT tickets', () {
      expect(
        extractAiProfileImageUrl({
          'uploadUrl': 'https://s3.example.com/put?X-Amz-Signature=abc',
          'referenceImages': ['users/uid/ai-profiles/p/ref.jpg'],
        }),
        isNull,
      );
    });
  });

  group('pickFrontalHttpUrl', () {
    test('skips S3 keys and picks the first remaining URL', () {
      expect(
        pickFrontalHttpUrl([
          'shared/ai-profiles/generic/alex/front.jpg',
          'https://cdn.example.com/jordan.jpg',
        ]),
        'https://cdn.example.com/jordan.jpg',
      );
    });
  });

  group('isFrontalReferencePath', () {
    test('matches front.png / front.jpg style paths', () {
      expect(
        isFrontalReferencePath(
          'https://cdn.example.com/shared/ai-profiles/generic/alex/front.png',
        ),
        isTrue,
      );
      expect(isFrontalReferencePath('side.jpg'), isFalse);
    });
  });

  group('parseReferenceImageKeys', () {
    test('keeps strings and objectKey from maps', () {
      expect(
        parseReferenceImageKeys([
          'shared/ai-profiles/generic/alex/front.jpg',
          {'objectKey': 'users/uid/ai-profiles/p/ref.jpg'},
        ]),
        [
          'shared/ai-profiles/generic/alex/front.jpg',
          'users/uid/ai-profiles/p/ref.jpg',
        ],
      );
    });
  });
}
