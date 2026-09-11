import 'package:freezed_annotation/freezed_annotation.dart';

import '../../items/domain/item.dart';
import 'outfit_render.dart';
import 'try_on_history.dart';

part 'outfit.freezed.dart';

/// One clothing item assigned to a slot. Backend `itemId` stays a foreign key
/// (same pattern as [Item.wardrobeId]); the outfit's own id is [Outfit.id].
@freezed
abstract class OutfitItem with _$OutfitItem {
  const factory OutfitItem({
    required String itemId,
    required ItemCategory slot,
  }) = _OutfitItem;
}

/// Saved outfit as used by controllers and UI. Backend `outfitId` is [id].
///
/// Slots use the same categories as clothing items
/// (`TOP` / `BOTTOM` / `DRESS` / `OUTERWEAR` / `SHOES` / `ACCESSORY` / `BAG`).
@freezed
abstract class Outfit with _$Outfit {
  const factory Outfit({
    required String id,
    required String wardrobeId,
    required String name,
    @Default([]) List<OutfitItem> items,
    OutfitRender? render,
    @Default([]) List<TryOnHistoryEntry> renderHistory,
    @Default([]) List<String> renderImageUrls,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Outfit;
}
