import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/item_image_urls.dart';

void main() {
  group('extractOriginalImageUrl', () {
    test('reads originalImageUrl before generic imageUrl', () {
      expect(
        extractOriginalImageUrl({
          'originalImageUrl': 'https://cdn.example.com/original.jpg',
          'imageUrl': 'https://cdn.example.com/processed.png',
        }),
        'https://cdn.example.com/original.jpg',
      );
    });

    test('reads nested image.rawImageUrl', () {
      expect(
        extractOriginalImageUrl({
          'image': {
            'originalKey': 'users/uid/uploads/uuid.jpg',
            'rawImageUrl': 'https://cdn.example.com/raw.jpg',
          },
        }),
        'https://cdn.example.com/raw.jpg',
      );
    });

    test('falls back to imageUrl when no original* field exists', () {
      expect(
        extractOriginalImageUrl({
          'imageUrl': 'https://cdn.example.com/photo.jpg',
        }),
        'https://cdn.example.com/photo.jpg',
      );
    });

    test('ignores S3 object keys and uploadUrl PUT aliases', () {
      expect(
        extractOriginalImageUrl({
          'image': {'originalKey': 'users/uid/uploads/uuid.jpg'},
          'imageKey': 'users/uid/uploads/uuid.jpg',
          'uploadUrl': 'https://s3.example.com/put?X-Amz-Signature=abc',
        }),
        isNull,
      );
    });
  });

  group('extractProcessedImageUrl', () {
    test('reads processedImageUrl and nested processedUrl', () {
      expect(
        extractProcessedImageUrl({
          'processedImageUrl': 'https://cdn.example.com/processed.png',
        }),
        'https://cdn.example.com/processed.png',
      );
      expect(
        extractProcessedImageUrl({
          'image': {
            'processedKey': 'users/uid/items/item_1/processed.png',
            'processedUrl': 'https://cdn.example.com/cutout.png',
          },
        }),
        'https://cdn.example.com/cutout.png',
      );
    });

    test('does not treat imageUrl as processed', () {
      expect(
        extractProcessedImageUrl({
          'imageUrl': 'https://cdn.example.com/photo.jpg',
        }),
        isNull,
      );
    });
  });
}
