import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item_image_source.dart';

import '../../../helpers/fake_item_repository.dart';

void main() {
  group('ItemImageSource.fromItem', () {
    test('prefers a processed image key over the original', () {
      final source = ItemImageSource.fromItem(
        testItem(
          originalImageKey: 'users/uid/uploads/original.jpg',
          processedImageKey: 'users/uid/items/item_xyz123/processed.png',
        ),
      );

      expect(source.key, 'users/uid/items/item_xyz123/processed.png');
      expect(source.isNetwork, isFalse);
    });

    test('falls back to the original key when processed is missing', () {
      final source = ItemImageSource.fromItem(testItem());

      expect(source.key, 'users/uid/uploads/uuid.jpg');
      expect(source.hasImage, isTrue);
      expect(source.networkUrl, isNull);
    });

    test('treats blank processed keys as missing', () {
      final source = ItemImageSource.fromItem(
        testItem(
          originalImageKey: 'users/uid/uploads/original.jpg',
          processedImageKey: '   ',
        ),
      );

      expect(source.key, 'users/uid/uploads/original.jpg');
    });

    test('exposes http(s) keys as network URLs', () {
      final source = ItemImageSource.fromItem(
        testItem(
          originalImageKey: 'https://cdn.example.com/original.jpg',
          processedImageKey: 'https://cdn.example.com/processed.png',
        ),
      );

      expect(source.key, 'https://cdn.example.com/processed.png');
      expect(source.networkUrl, 'https://cdn.example.com/processed.png');
      expect(source.isNetwork, isTrue);
    });

    test('has no image when both keys are empty', () {
      final source = ItemImageSource.fromItem(
        testItem(originalImageKey: null, processedImageKey: null),
      );

      expect(source.key, isNull);
      expect(source.hasImage, isFalse);
      expect(source.isNetwork, isFalse);
    });
  });
}
