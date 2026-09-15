import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../outfits/application/wardrobe_outfits_provider.dart';
import '../../wardrobes/application/wardrobe_items_provider.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../domain/app_search.dart';

/// Current header-search text. Empty / whitespace is a soft-omit.
class AppSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;

  void clear() => state = '';
}

final appSearchQueryProvider = NotifierProvider<AppSearchQuery, String>(
  AppSearchQuery.new,
);

/// MVP engine: client-side filter. Override when Backend ships `q=`.
final appSearchEngineProvider = Provider<AppSearchEngine>((ref) {
  return loadedListAppSearch;
});

/// Loaded lists (existing list APIs). Watched only when the query is non-empty.
final appSearchCatalogProvider = Provider<AppSearchCatalog>((ref) {
  final wardrobesState = ref.watch(wardrobesControllerProvider);
  final wardrobes = wardrobesState.wardrobes;
  var loading = wardrobesState.isLoading;
  final clothing = [
    for (final wardrobe in wardrobes)
      ref.watch(wardrobeItemsProvider(wardrobe.id)),
  ];
  final savedOutfits = [
    for (final wardrobe in wardrobes)
      ref.watch(wardrobeOutfitsProvider(wardrobe.id)),
  ];
  for (final asyncItems in clothing) {
    loading = loading || asyncItems.isLoading;
  }
  for (final asyncOutfits in savedOutfits) {
    loading = loading || asyncOutfits.isLoading;
  }
  return AppSearchCatalog(
    wardrobes: wardrobes,
    items: [for (final asyncItems in clothing) ...?asyncItems.asData?.value],
    outfits: [
      for (final asyncOutfits in savedOutfits) ...?asyncOutfits.asData?.value,
    ],
    isLoading: loading,
  );
});

/// Results for the current query. Empty query never reads the catalog.
final appSearchResultsProvider = Provider<AppSearchResults>((ref) {
  final query = ref.watch(appSearchQueryProvider);
  if (isAppSearchQueryEmpty(query)) {
    return AppSearchResults.empty;
  }
  final engine = ref.watch(appSearchEngineProvider);
  return engine(query: query, catalog: ref.watch(appSearchCatalogProvider));
});
