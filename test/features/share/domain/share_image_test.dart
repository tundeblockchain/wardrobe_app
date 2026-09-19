import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/share/domain/share_image.dart';

import '../../../helpers/fake_item_repository.dart';
import '../../../helpers/fake_outfit_repository.dart';

void main() {
  test('itemUrl prefers processed http(s) then original', () {
    expect(
      ShareImage.itemUrl(
        testItem(processedImageUrl: 'https://cdn.example.com/processed.jpg'),
      ),
      'https://cdn.example.com/processed.jpg',
    );
    expect(
      ShareImage.itemUrl(
        testItem(originalImageUrl: 'https://cdn.example.com/original.jpg'),
      ),
      'https://cdn.example.com/original.jpg',
    );
    expect(ShareImage.itemUrl(testItem()), isNull);
  });

  test('outfitUrl uses selected hero then first try-on URL', () {
    final outfit = testOutfit(
      render: testOutfitRender(
        imageUrl: 'https://cdn.example.com/try-on/outfit_123.png',
      ),
    );
    expect(
      ShareImage.outfitUrl(
        outfit,
        selectedHeroUrl: 'https://cdn.example.com/hero.png',
      ),
      'https://cdn.example.com/hero.png',
    );
    expect(
      ShareImage.outfitUrl(outfit),
      'https://cdn.example.com/try-on/outfit_123.png',
    );
    expect(ShareImage.outfitUrl(testOutfit()), isNull);
  });

  test('outfitUrl ignores S3 keys that are not http(s)', () {
    expect(
      ShareImage.outfitUrl(
        testOutfit(
          render: OutfitRender(
            status: OutfitRenderStatus.ready,
            aiProfileId: 'profile_generic_01',
            imageKey: 'users/uid/outfits/outfit_123/render.png',
          ),
        ),
      ),
      isNull,
    );
  });
}
