import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/data/item_dtos.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';

void main() {
  final json = {
    'itemId': 'item_xyz123',
    'wardrobeId': 'wd_abc123',
    'name': 'Black Nike T-Shirt',
    'category': 'TOP',
    'subcategory': 'TSHIRT',
    'colours': ['BLACK'],
    'brand': 'Nike',
    'image': {
      'originalKey': 'users/uid/uploads/uuid.jpg',
      'processedKey': 'users/uid/items/item_xyz123/processed.png',
    },
    'processingStatus': 'READY',
    'createdAt': '2026-09-03T18:45:00Z',
    'updatedAt': '2026-09-03T18:45:00Z',
  };

  group('ItemResponse', () {
    test('fromJson maps itemId to domain id without leaking backend names', () {
      final domain = ItemResponse.fromJson(json).toDomain();

      expect(domain.id, 'item_xyz123');
      expect(domain.wardrobeId, 'wd_abc123');
      expect(domain.name, 'Black Nike T-Shirt');
      expect(domain.category, ItemCategory.top);
      expect(domain.category.label, 'Top');
      expect(domain.subcategory, 'TSHIRT');
      expect(domain.colours, ['BLACK']);
      expect(domain.brand, 'Nike');
      expect(domain.originalImageKey, 'users/uid/uploads/uuid.jpg');
      expect(
        domain.processedImageKey,
        'users/uid/items/item_xyz123/processed.png',
      );
      expect(domain.processingStatus, ItemProcessingStatus.ready);
      expect(domain.processingError, isNull);
      expect(domain.ai, isNull);
      expect(domain.toString(), isNot(contains('itemId')));
    });

    test('maps optional ai metadata and processingError', () {
      final domain = ItemResponse.fromJson({
        ...json,
        'processingStatus': 'FAILED',
        'processingError': 'Background removal failed.',
        'ai': {
          'detectedCategory': 'TOP',
          'detectedSubcategory': 'TSHIRT',
          'detectedColours': ['BLACK', 'WHITE'],
          'backgroundRemoved': false,
        },
      }).toDomain();

      expect(domain.processingStatus, ItemProcessingStatus.failed);
      expect(domain.processingError, 'Background removal failed.');
      expect(domain.ai?.detectedCategory, ItemCategory.top);
      expect(domain.ai?.detectedSubcategory, 'TSHIRT');
      expect(domain.ai?.detectedColours, ['BLACK', 'WHITE']);
      expect(domain.ai?.backgroundRemoved, isFalse);
    });

    test('maps failureReason alias onto processingError', () {
      final domain = ItemResponse.fromJson({
        ...json,
        'processingStatus': 'FAILED',
        'failureReason': 'Classifier unavailable.',
      }).toDomain();

      expect(domain.processingError, 'Classifier unavailable.');
    });

    test('maps Backend WARDROBE-54 originalImageUrl and processedImageUrl', () {
      final processing = ItemResponse.fromJson({
        ...json,
        'image': {'originalKey': 'users/uid/uploads/uuid.jpg'},
        'originalImageUrl':
            'https://cdn.example.com/original.jpg?X-Amz-Expires=900',
        'processingStatus': 'PROCESSING',
      }).toDomain();

      expect(processing.processingStatus, ItemProcessingStatus.processing);
      expect(
        processing.originalImageKey,
        'https://cdn.example.com/original.jpg?X-Amz-Expires=900',
      );
      expect(processing.processedImageKey, isNull);

      final ready = ItemResponse.fromJson({
        ...json,
        'originalImageUrl':
            'https://cdn.example.com/original.jpg?X-Amz-Expires=900',
        'processedImageUrl':
            'https://cdn.example.com/processed.png?X-Amz-Expires=900',
      }).toDomain();

      expect(
        ready.originalImageKey,
        'https://cdn.example.com/original.jpg?X-Amz-Expires=900',
      );
      expect(
        ready.processedImageKey,
        'https://cdn.example.com/processed.png?X-Amz-Expires=900',
      );
    });

    test('falls back to flat imageKey when nested image is absent', () {
      final domain = ItemResponse.fromJson({
        ...json,
        'image': null,
        'imageKey': 'users/uid/uploads/flat.jpg',
      }).toDomain();

      expect(domain.originalImageKey, 'users/uid/uploads/flat.jpg');
      expect(domain.processedImageKey, isNull);
    });

    test('defaults missing processingStatus to ready', () {
      final payload = Map<String, dynamic>.from(json)
        ..remove('processingStatus');
      final domain = ItemResponse.fromJson(payload).toDomain();
      expect(domain.processingStatus, ItemProcessingStatus.ready);
    });

    test('rejects an unknown category', () {
      expect(
        () => ItemResponse.fromJson({...json, 'category': 'HAT'}).toDomain(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.code,
            'code',
            'INVALID_RESPONSE',
          ),
        ),
      );
    });
  });

  group('ItemListResponse', () {
    test('maps nested items array to domain list', () {
      final domain = ItemListResponse.fromJson({
        'items': [json],
      }).toDomain();

      expect(domain, hasLength(1));
      expect(domain.single.id, 'item_xyz123');
    });
  });

  group('write request DTOs', () {
    test('create serializes required fields and omits empty optionals', () {
      expect(
        const CreateItemRequest(
          name: 'Black T-Shirt',
          category: 'TOP',
          imageKey: 'users/uid/uploads/uuid.jpg',
        ).toJson(),
        {
          'name': 'Black T-Shirt',
          'category': 'TOP',
          'imageKey': 'users/uid/uploads/uuid.jpg',
        },
      );
    });

    test('create includes optional metadata when present', () {
      expect(
        const CreateItemRequest(
          name: 'Black T-Shirt',
          category: 'TOP',
          subcategory: 'TSHIRT',
          colours: ['BLACK'],
          brand: 'Nike',
          imageKey: 'users/uid/uploads/uuid.jpg',
        ).toJson(),
        {
          'name': 'Black T-Shirt',
          'category': 'TOP',
          'subcategory': 'TSHIRT',
          'colours': ['BLACK'],
          'brand': 'Nike',
          'imageKey': 'users/uid/uploads/uuid.jpg',
        },
      );
    });

    test('update serializes only provided fields', () {
      expect(const UpdateItemRequest(name: 'Navy Tee').toJson(), {
        'name': 'Navy Tee',
      });
    });
  });
}
