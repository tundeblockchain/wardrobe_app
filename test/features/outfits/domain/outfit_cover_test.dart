import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_cover.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  group('outfitPreviewImageUrl', () {
    test('uses render.imageUrl and ignores empty', () {
      expect(outfitPreviewImageUrl(testOutfit()), isNull);
      expect(
        outfitPreviewImageUrl(testOutfit(render: testOutfitRender())),
        'https://cdn.example.com/try-on/outfit_123.png',
      );
      expect(
        outfitPreviewImageUrl(
          testOutfit(render: testOutfitRender(imageUrl: '   ')),
        ),
        isNull,
      );
    });
  });

  group('resolveOutfitCover', () {
    test('prefers a try-on render.imageUrl over an item photo', () {
      final cover = resolveOutfitCover(testOutfit(render: testOutfitRender()), [
        testItem(
          id: 'item_top123',
          originalImageUrl: 'https://cdn.example.com/top.jpg',
        ),
      ]);

      expect(cover.kind, OutfitCoverKind.render);
      expect(cover.networkUrl, 'https://cdn.example.com/try-on/outfit_123.png');
    });

    test('falls back to the first assigned item http(s) photo', () {
      final cover = resolveOutfitCover(testOutfit(), [
        testItem(
          id: 'item_top123',
          originalImageKey: 'users/uid/uploads/top.jpg',
        ),
        testItem(
          id: 'item_bottom456',
          originalImageUrl: 'https://cdn.example.com/jeans.jpg',
        ),
      ]);

      expect(cover.kind, OutfitCoverKind.item);
      expect(cover.networkUrl, 'https://cdn.example.com/jeans.jpg');
      expect(cover.item?.id, 'item_bottom456');
    });

    test('does not invent a URL from an S3 imageKey', () {
      final cover = resolveOutfitCover(testOutfit(), [
        testItem(
          id: 'item_top123',
          originalImageKey: 'users/uid/uploads/top.jpg',
        ),
      ]);

      expect(cover.kind, OutfitCoverKind.none);
      expect(cover.hasPhoto, isFalse);
    });

    test('uses hanger when neither render nor item photo exists', () {
      final cover = resolveOutfitCover(testOutfit());

      expect(cover.kind, OutfitCoverKind.none);
      expect(cover.hasPhoto, isFalse);
    });

    test('prefers an explicit try-on URL over render and item photos', () {
      const hero = 'https://cdn.example.com/try-on/picked.png';
      final cover = resolveOutfitCover(testOutfit(render: testOutfitRender()), [
        testItem(
          id: 'item_top123',
          originalImageUrl: 'https://cdn.example.com/top.jpg',
        ),
      ], hero);

      expect(cover.kind, OutfitCoverKind.render);
      expect(cover.networkUrl, hero);
    });
  });

  group('latestOutfitTryOnUrl', () {
    test('uses history then render, and honors a selected URL', () {
      final older = testTryOnHistoryEntry(
        render: testOutfitRender(
          imageUrl: 'https://cdn.example.com/try-on/older.png',
        ),
        createdAt: DateTime.utc(2026, 9, 1),
      );
      final latest = testTryOnHistoryEntry(
        render: testOutfitRender(
          imageUrl: 'https://cdn.example.com/try-on/latest.png',
        ),
        createdAt: DateTime.utc(2026, 9, 10),
      );
      final outfit = testOutfit(render: testOutfitRender());

      expect(
        latestOutfitTryOnUrl(outfit, history: [latest, older]),
        'https://cdn.example.com/try-on/latest.png',
      );
      expect(
        latestOutfitTryOnUrl(
          outfit,
          history: [latest, older],
          selectedUrl: older.imageUrl,
        ),
        older.imageUrl,
      );
    });
  });
}
