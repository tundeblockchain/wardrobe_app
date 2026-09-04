import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_validators.dart';

void main() {
  group('OutfitValidators.name', () {
    test('rejects empty names', () {
      expect(OutfitValidators.name(''), 'Enter an outfit name.');
      expect(OutfitValidators.name('   '), 'Enter an outfit name.');
    });

    test('rejects names over the max length', () {
      expect(
        OutfitValidators.name('a' * (OutfitValidators.maxNameLength + 1)),
        'Name must be ${OutfitValidators.maxNameLength} characters or fewer.',
      );
    });

    test('accepts a trimmed name', () {
      expect(OutfitValidators.name('  Friday Night  '), isNull);
    });
  });

  group('OutfitValidators.items', () {
    test('requires at least one slot assignment', () {
      expect(
        OutfitValidators.items(const []),
        'Add at least one item to this outfit.',
      );
    });

    test('accepts a filled slot', () {
      expect(
        OutfitValidators.items(const [
          OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
        ]),
        isNull,
      );
    });
  });

  test('assignOutfitItem replaces the slot and unique item id', () {
    const current = [
      OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
      OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
    ];

    final next = assignOutfitItem(
      current: current,
      assignment: const OutfitItem(
        itemId: 'item_top123',
        slot: ItemCategory.shoes,
      ),
    );

    expect(next, hasLength(2));
    expect(
      next,
      contains(
        const OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
      ),
    );
    expect(
      next,
      contains(
        const OutfitItem(itemId: 'item_top123', slot: ItemCategory.shoes),
      ),
    );
  });
}
