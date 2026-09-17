import '../../../core/router/app_routes.dart';
import '../../items/domain/item.dart';
import '../../items/domain/item_image_source.dart';
import '../../items/domain/item_taxonomy.dart';
import '../../outfits/domain/outfit.dart';
import '../../outfits/domain/outfit_cover.dart';
import '../../wardrobes/domain/wardrobe.dart';

/// Kind of entity a header-search hit points at (WARDROBE-89).
enum AppSearchHitKind { item, outfit, wardrobe }

/// One navigable match from client-side search.
class AppSearchHit {
  const AppSearchHit({
    required this.kind,
    required this.id,
    required this.wardrobeId,
    required this.title,
    this.subtitle,
    this.imageUrl,
  });

  final AppSearchHitKind kind;
  final String id;
  final String wardrobeId;
  final String title;
  final String? subtitle;

  /// Presigned http(s) thumbnail from the already-loaded list/get DTO.
  ///
  /// Items prefer `processedImageUrl`, else `originalImageUrl`. Null when
  /// missing — the row still renders a placeholder.
  final String? imageUrl;

  /// Route for the matched entity. Backend `q=` can keep this mapping.
  String get location {
    return switch (kind) {
      AppSearchHitKind.item => AppRoutes.itemDetail(wardrobeId, id),
      AppSearchHitKind.outfit => AppRoutes.outfitDetail(wardrobeId, id),
      AppSearchHitKind.wardrobe => AppRoutes.wardrobeDetail(id),
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppSearchHit &&
            kind == other.kind &&
            id == other.id &&
            wardrobeId == other.wardrobeId &&
            title == other.title &&
            subtitle == other.subtitle &&
            imageUrl == other.imageUrl;
  }

  @override
  int get hashCode =>
      Object.hash(kind, id, wardrobeId, title, subtitle, imageUrl);
}

/// Already-loaded (or list-API) snapshot used by MVP search.
///
/// When Backend ships a `q=` endpoint, replace [loadedListAppSearch] at
/// [appSearchEngineProvider] — do not add a permanent local-only HTTP protocol.
class AppSearchCatalog {
  const AppSearchCatalog({
    this.wardrobes = const [],
    this.items = const [],
    this.outfits = const [],
    this.isLoading = false,
  });

  final List<Wardrobe> wardrobes;
  final List<Item> items;
  final List<Outfit> outfits;
  final bool isLoading;
}

/// Grouped hits for the header results panel.
class AppSearchResults {
  const AppSearchResults({
    this.items = const [],
    this.outfits = const [],
    this.wardrobes = const [],
    this.isLoading = false,
  });

  static const empty = AppSearchResults();

  final List<AppSearchHit> items;
  final List<AppSearchHit> outfits;
  final List<AppSearchHit> wardrobes;
  final bool isLoading;

  bool get isEmpty => items.isEmpty && outfits.isEmpty && wardrobes.isEmpty;

  List<AppSearchHit> get allHits => [...items, ...outfits, ...wardrobes];
}

/// Signature for the search engine. Swap the provider for a Backend client.
typedef AppSearchEngine = AppSearchResults Function({
  required String query,
  required AppSearchCatalog catalog,
});

/// Trimmed lowercase query. Empty means "soft-omit" — no results panel.
String normalizeAppSearchQuery(String query) => query.trim().toLowerCase();

bool isAppSearchQueryEmpty(String query) =>
    normalizeAppSearchQuery(query).isEmpty;

const _maxHitsPerKind = 12;

/// Client-side substring filter over loaded wardrobes, items, and outfits.
AppSearchResults loadedListAppSearch({
  required String query,
  required AppSearchCatalog catalog,
}) {
  final needle = normalizeAppSearchQuery(query);
  if (needle.isEmpty) {
    return const AppSearchResults();
  }

  final wardrobeNames = <String, String>{
    for (final wardrobe in catalog.wardrobes) wardrobe.id: wardrobe.name,
  };

  final items = <AppSearchHit>[];
  for (final item in catalog.items) {
    if (!_itemMatches(item, needle)) {
      continue;
    }
    items.add(
      AppSearchHit(
        kind: AppSearchHitKind.item,
        id: item.id,
        wardrobeId: item.wardrobeId,
        title: item.name,
        subtitle: _itemSubtitle(item, wardrobeNames[item.wardrobeId]),
        imageUrl: itemSearchThumbnailUrl(item),
      ),
    );
    if (items.length >= _maxHitsPerKind) {
      break;
    }
  }

  final outfits = <AppSearchHit>[];
  for (final outfit in catalog.outfits) {
    if (!_contains(outfit.name, needle)) {
      continue;
    }
    outfits.add(
      AppSearchHit(
        kind: AppSearchHitKind.outfit,
        id: outfit.id,
        wardrobeId: outfit.wardrobeId,
        title: outfit.name,
        subtitle: _joinSubtitle(['Outfit', wardrobeNames[outfit.wardrobeId]]),
        imageUrl: outfitSearchThumbnailUrl(outfit),
      ),
    );
    if (outfits.length >= _maxHitsPerKind) {
      break;
    }
  }

  final wardrobes = <AppSearchHit>[];
  for (final wardrobe in catalog.wardrobes) {
    if (!_contains(wardrobe.name, needle)) {
      continue;
    }
    wardrobes.add(
      AppSearchHit(
        kind: AppSearchHitKind.wardrobe,
        id: wardrobe.id,
        wardrobeId: wardrobe.id,
        title: wardrobe.name,
        subtitle: 'Wardrobe',
      ),
    );
    if (wardrobes.length >= _maxHitsPerKind) {
      break;
    }
  }

  return AppSearchResults(
    items: items,
    outfits: outfits,
    wardrobes: wardrobes,
    isLoading: catalog.isLoading,
  );
}

/// Item-list/get thumbnail. No Backend search API.
///
/// Prefers wire `processedImageUrl` when it is http(s), else
/// `originalImageUrl`. Storage keys on `image` are not displayable.
String? itemSearchThumbnailUrl(Item item) {
  return ItemImageSource.fromItem(item).networkUrl;
}

/// Cover/hero try-on URL already on the outfit model, if any.
String? outfitSearchThumbnailUrl(Outfit outfit) {
  return latestOutfitTryOnUrl(outfit);
}

bool _itemMatches(Item item, String needle) {
  if (_contains(item.name, needle)) {
    return true;
  }
  if (_contains(item.category.label, needle) ||
      _contains(item.category.wireValue, needle)) {
    return true;
  }
  final raw = item.subcategory?.trim();
  if (raw == null || raw.isEmpty) {
    return false;
  }
  if (_contains(raw, needle)) {
    return true;
  }
  final parsed = ItemSubcategory.tryParse(raw);
  return parsed != null && _contains(parsed.label, needle);
}

String? _itemSubtitle(Item item, String? wardrobeName) {
  final subcategory = item.subcategory?.trim();
  final parsed = ItemSubcategory.tryParse(subcategory);
  return _joinSubtitle([
    item.category.label,
    parsed?.label ?? (subcategory?.isEmpty == true ? null : subcategory),
    wardrobeName,
  ]);
}

String? _joinSubtitle(List<String?> parts) {
  final visible = [
    for (final part in parts)
      if (part != null && part.trim().isNotEmpty) part.trim(),
  ];
  if (visible.isEmpty) {
    return null;
  }
  return visible.join(' · ');
}

bool _contains(String haystack, String needle) {
  return haystack.toLowerCase().contains(needle);
}
