import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/items/domain/item.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_render.dart';
import 'package:wardrobe_app/features/outfits/domain/outfit_repository.dart';
import 'package:wardrobe_app/features/outfits/domain/try_on_history.dart';

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
  int requestRenderCalls = 0;
  int getRenderCalls = 0;
  List<OutfitItem>? lastItems;
  List<String>? lastItemIds;
  String? lastAiProfileId;
  OutfitRender? nextRender;
  final List<OutfitRender> renderPollQueue = [];

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

  @override
  Future<Outfit> requestRender({
    required String wardrobeId,
    required String outfitId,
    required String aiProfileId,
    List<OutfitItem>? items,
    List<String>? itemIds,
  }) async {
    requestRenderCalls++;
    lastAiProfileId = aiProfileId;
    if (items != null) {
      lastItems = items;
    }
    lastItemIds = itemIds;
    _maybeFail();
    final index = _indexOf(wardrobeId, outfitId);
    final current = outfits[index];
    final render =
        nextRender ??
        OutfitRender(
          status: OutfitRenderStatus.pending,
          aiProfileId: aiProfileId,
        );
    nextRender = null;
    final updated = current.copyWith(render: render);
    outfits[index] = updated;
    return updated;
  }

  @override
  Future<OutfitRender> getRender({
    required String wardrobeId,
    required String outfitId,
  }) async {
    getRenderCalls++;
    _maybeFail();
    if (renderPollQueue.isNotEmpty) {
      final render = renderPollQueue.removeAt(0);
      final index = _indexOf(wardrobeId, outfitId);
      outfits[index] = outfits[index].copyWith(render: render);
      return render;
    }
    final current = outfits[_indexOf(wardrobeId, outfitId)];
    final render = current.render;
    if (render == null) {
      throw const ApiException(
        message: 'No render yet.',
        code: 'RENDER_NOT_FOUND',
        statusCode: 404,
      );
    }
    return render;
  }

  int _indexOf(String wardrobeId, String outfitId) {
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
    return index;
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
  OutfitRender? render,
  List<TryOnHistoryEntry> renderHistory = const [],
  List<String> renderImageUrls = const [],
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
    render: render,
    renderHistory: renderHistory,
    renderImageUrls: renderImageUrls,
    createdAt: DateTime.utc(2026, 9, 4, 18),
    updatedAt: DateTime.utc(2026, 9, 4, 18),
  );
}

OutfitRender testOutfitRender({
  OutfitRenderStatus status = OutfitRenderStatus.ready,
  String aiProfileId = 'profile_generic_01',
  String? imageKey = 'users/uid/outfits/outfit_123/render.png',
  String? imageUrl = 'https://cdn.example.com/try-on/outfit_123.png',
  String? error,
}) {
  return OutfitRender(
    status: status,
    aiProfileId: aiProfileId,
    imageKey: status == OutfitRenderStatus.ready ? imageKey : null,
    imageUrl: status == OutfitRenderStatus.ready ? imageUrl : null,
    error: error,
  );
}

TryOnHistoryEntry testTryOnHistoryEntry({
  String imageKey = 'users/uid/outfits/outfit_123/renders/rend_1.png',
  DateTime? createdAt,
  String aiProfileId = 'profile_generic_01',
  String? imageUrl = 'https://cdn.example.com/try-on/outfit_123.png',
}) {
  return TryOnHistoryEntry(
    imageKey: imageKey,
    createdAt: createdAt ?? DateTime.utc(2026, 9, 10, 8),
    aiProfileId: aiProfileId,
    imageUrl: imageUrl,
  );
}
