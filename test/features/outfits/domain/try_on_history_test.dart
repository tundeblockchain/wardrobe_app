import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/outfits/domain/try_on_history.dart';

import '../../../helpers/fake_outfit_repository.dart';

void main() {
  group('tryOnDisplayUrls', () {
    test('uses history first and does not duplicate the latest render', () {
      const latest = 'https://cdn.example.com/try-on/latest.png';
      const older = 'https://cdn.example.com/try-on/older.png';
      final urls = tryOnDisplayUrls(
        latestRender: testOutfitRender(imageUrl: latest),
        history: [
          testTryOnHistoryEntry(render: testOutfitRender(imageUrl: latest)),
          testTryOnHistoryEntry(render: testOutfitRender(imageUrl: older)),
        ],
      );

      expect(urls, [latest, older]);
    });

    test('falls back to the current render when history is empty', () {
      expect(tryOnDisplayUrls(latestRender: testOutfitRender()), [
        'https://cdn.example.com/try-on/outfit_123.png',
      ]);
      expect(tryOnDisplayUrls(), isEmpty);
    });
  });

  group('outfitHeroImageUrl', () {
    test('defaults to the first history URL and can pick another', () {
      const latest = 'https://cdn.example.com/try-on/latest.png';
      const older = 'https://cdn.example.com/try-on/older.png';
      final history = [
        testTryOnHistoryEntry(render: testOutfitRender(imageUrl: latest)),
        testTryOnHistoryEntry(render: testOutfitRender(imageUrl: older)),
      ];

      expect(
        outfitHeroImageUrl(
          latestRender: testOutfitRender(imageUrl: latest),
          history: history,
        ),
        latest,
      );
      expect(
        outfitHeroImageUrl(
          latestRender: testOutfitRender(imageUrl: latest),
          history: history,
          selectedUrl: older,
        ),
        older,
      );
    });
  });

  group('isTryOnHistoryGap', () {
    test('treats missing-route statuses and codes as a soft empty', () {
      expect(
        isTryOnHistoryGap(
          const ApiException(message: 'Missing.', statusCode: 404),
        ),
        isTrue,
      );
      expect(
        isTryOnHistoryGap(
          const ApiException(
            message: 'Missing.',
            code: 'RENDER_HISTORY_NOT_FOUND',
          ),
        ),
        isTrue,
      );
      expect(
        isTryOnHistoryGap(
          const ApiException(
            message: 'Boom.',
            code: 'BAD_RESPONSE',
            statusCode: 500,
          ),
        ),
        isFalse,
      );
    });
  });

  test('skips history rows that are not READY with an imageUrl', () {
    final urls = tryOnDisplayUrls(
      history: [
        testTryOnHistoryEntry(
          render: testOutfitRender(status: OutfitRenderStatus.failed),
        ),
      ],
    );
    expect(urls, isEmpty);
  });
}
