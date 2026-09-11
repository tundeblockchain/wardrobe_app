import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/outfits/domain/try_on_history.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  group('presignedTryOnUrl', () {
    test('keeps http(s) GETs and drops keys', () {
      expect(
        presignedTryOnUrl('https://signed.example/outfits/rend.png?X-Amz=1'),
        'https://signed.example/outfits/rend.png?X-Amz=1',
      );
      expect(
        presignedTryOnUrl('users/uid/outfits/outfit_123/renders/rend_1.png'),
        isNull,
      );
      expect(presignedTryOnUrl('   '), isNull);
    });
  });

  group('tryOnDisplayUrls', () {
    test('binds to renderImageUrls first and skips a missing history URL', () {
      const latest = 'https://cdn.example.com/try-on/latest.png';
      const older = 'https://cdn.example.com/try-on/older.png';
      final urls = tryOnDisplayUrls(
        latestRender: testOutfitRender(imageUrl: latest),
        renderImageUrls: const [latest, older],
        history: [
          testTryOnHistoryEntry(imageUrl: latest),
          testTryOnHistoryEntry(
            imageKey: 'users/uid/outfits/outfit_123/renders/rend_old.png',
            imageUrl: null,
            createdAt: DateTime.utc(2026, 9, 1),
          ),
        ],
      );

      expect(urls, [latest, older]);
    });

    test('falls back to the current render when history arrays are empty', () {
      expect(tryOnDisplayUrls(latestRender: testOutfitRender()), [
        'https://cdn.example.com/try-on/outfit_123.png',
      ]);
      expect(tryOnDisplayUrls(), isEmpty);
    });
  });

  group('outfitHeroImageUrl', () {
    test('defaults to index 0 and can pick another signed URL', () {
      const latest = 'https://cdn.example.com/try-on/latest.png';
      const older = 'https://cdn.example.com/try-on/older.png';

      expect(
        outfitHeroImageUrl(
          latestRender: testOutfitRender(imageUrl: latest),
          renderImageUrls: const [latest, older],
        ),
        latest,
      );
      expect(
        outfitHeroImageUrl(
          latestRender: testOutfitRender(imageUrl: latest),
          renderImageUrls: const [latest, older],
          selectedUrl: older,
        ),
        older,
      );
    });
  });

  test('skips FAILED current render when it has no URL', () {
    final urls = tryOnDisplayUrls(
      latestRender: testOutfitRender(status: OutfitRenderStatus.failed),
    );
    expect(urls, isEmpty);
  });
}
