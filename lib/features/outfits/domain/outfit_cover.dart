import '../../items/domain/item.dart';
import '../../items/domain/item_image_source.dart';
import 'outfit.dart';

/// Where an outfit card photo came from.
enum OutfitCoverKind { render, item, none }

/// Resolved cover for an outfit card or carousel slide.
class OutfitCover {
  const OutfitCover({this.networkUrl, this.item, required this.kind});

  /// First usable http(s) URL. Never derived from an S3 `imageKey`.
  final String? networkUrl;

  /// Assigned wardrobe item when [kind] is [OutfitCoverKind.item].
  final Item? item;

  final OutfitCoverKind kind;

  bool get hasPhoto {
    final url = networkUrl?.trim();
    return url != null && url.isNotEmpty;
  }
}

/// Existing Backend try-on `imageUrl` when present. Never built from `imageKey`.
String? outfitPreviewImageUrl(Outfit outfit) {
  final url = outfit.render?.imageUrl?.trim();
  if (url == null || url.isEmpty) {
    return null;
  }
  return url;
}

/// Outfit photo: try-on `render.imageUrl`, else first assigned item http(s)
/// photo, else none (hanger).
///
/// Inspected Backend fields:
/// - Outfit get/list: optional `render.imageUrl` (presigned GET). `render.imageKey`
///   is storage-only and is never turned into a URL.
/// - Item get/list: `originalImageUrl` / `processedImageUrl` (WARDROBE-54),
///   mapped onto [Item.originalImageKey] / [Item.processedImageKey]. S3 keys
///   alone cannot be displayed.
/// - Recommendation get: no image fields — suggestions use item photos only.
OutfitCover resolveOutfitCover(
  Outfit outfit, [
  List<Item> wardrobeItems = const [],
]) {
  final renderUrl = outfitPreviewImageUrl(outfit);
  if (renderUrl != null) {
    return OutfitCover(networkUrl: renderUrl, kind: OutfitCoverKind.render);
  }
  final itemsById = {for (final item in wardrobeItems) item.id: item};
  for (final assignment in outfit.items) {
    final item = itemsById[assignment.itemId];
    if (item == null) {
      continue;
    }
    final url = ItemImageSource.fromItem(item).networkUrl;
    if (url != null) {
      return OutfitCover(
        networkUrl: url,
        item: item,
        kind: OutfitCoverKind.item,
      );
    }
  }
  return const OutfitCover(kind: OutfitCoverKind.none);
}
