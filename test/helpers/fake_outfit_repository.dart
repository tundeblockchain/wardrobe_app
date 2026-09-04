import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_repository.dart';

/// In-memory [OutfitRepository] for unit tests.
class FakeOutfitRepository implements OutfitRepository {
  FakeOutfitRepository({List<Outfit>? seed}) : outfits = [...?seed];

  final List<Outfit> outfits;
  ApiException? nextFailure;
  int listCalls = 0;
  int getCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;
  List<OutfitItem>? lastItems;

  @override
  Future<List<Outfit>> listOutfits(String wardrobeId) async {
    listCalls++;
    _maybeFail();
    return [
      for (final outfit in outfits)
        if (outfit.wardrobeId == wardrobeId) outfit,
    ];
  }

  @override
  Future<Outfit> getOutfit({
    required String wardrobeId,
    required String outfitId,
  }) async {
    getCalls++;
    _maybeFail();
    return outfits.firstWhere(
      (outfit) => outfit.wardrobeId == wardrobeId && outfit.id == outfitId,
      orElse: () => throw const ApiException(
        message: 'Outfit not found.',
        code: 'OUTFIT_NOT_FOUND',
        statusCode: 404,
      ),
    );
  }

  @override
  Future<Outfit> createOutfit({
    required String wardrobeId,
    required String name,
    required List<OutfitItem> items,
  }) async {
    createCalls++;
    lastItems = items;
    _maybeFail();
    final now = DateTime.utc(2026, 9, 4, 20);
    final outfit = Outfit(
      id: 'outfit_${outfits.length + 1}',
      wardrobeId: wardrobeId,
      name: name,
      items: items,
      createdAt: now,
      updatedAt: now,
    );
    outfits.add(outfit);
    return outfit;
  }

  @override
  Future<Outfit> updateOutfit({
    required String wardrobeId,
    required String outfitId,
    String? name,
    List<OutfitItem>? items,
  }) async {
    updateCalls++;
    if (items != null) {
      lastItems = items;
    }
    _maybeFail();
    final index = outfits.indexWhere(
      (outfit) => outfit.wardrobeId == wardrobeId && outfit.id == outfitId,
    );
    if (index < 0) {
      throw const ApiException(
        message: 'Outfit not found.',
        code: 'OUTFIT_NOT_FOUND',
        statusCode: 404,
      );
    }
    final current = outfits[index];
    final updated = current.copyWith(
      name: name ?? current.name,
      items: items ?? current.items,
      updatedAt: DateTime.utc(2026, 9, 4, 21),
    );
    outfits[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteOutfit({
    required String wardrobeId,
    required String outfitId,
  }) async {
    deleteCalls++;
    _maybeFail();
    outfits.removeWhere(
      (outfit) => outfit.wardrobeId == wardrobeId && outfit.id == outfitId,
    );
  }

  void _maybeFail() {
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

Outfit testOutfit({
  String id = 'outfit_123',
  String wardrobeId = 'wd_abc123',
  String name = 'Friday Night',
}) {
  return Outfit(
    id: id,
    wardrobeId: wardrobeId,
    name: name,
    items: const [
      OutfitItem(itemId: 'item_top123', slot: ItemCategory.top),
      OutfitItem(itemId: 'item_bottom456', slot: ItemCategory.bottom),
      OutfitItem(itemId: 'item_shoes789', slot: ItemCategory.shoes),
    ],
    createdAt: DateTime.utc(2026, 9, 4, 18),
    updatedAt: DateTime.utc(2026, 9, 4, 18),
  );
}
