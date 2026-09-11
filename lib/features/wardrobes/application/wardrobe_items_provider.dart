import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../../items/data/dio_item_repository.dart';
import '../../items/domain/item.dart';
import 'wardrobes_controller.dart';

/// Clothing items for one wardrobe (cover cards + home carousel).
final wardrobeItemsProvider = FutureProvider.family<List<Item>, String>((
  ref,
  wardrobeId,
) async {
  if (!watchAllowsUserDataFetch(ref)) {
    return const [];
  }
  return ref.watch(itemRepositoryProvider).listItems(wardrobeId);
});

/// Flattened clothing items from every wardrobe, in wardrobe-list order.
final homeClothingItemsProvider = Provider<List<Item>>((ref) {
  final wardrobes = ref.watch(wardrobesControllerProvider).wardrobes;
  final items = <Item>[];
  for (final wardrobe in wardrobes) {
    final asyncItems = ref.watch(wardrobeItemsProvider(wardrobe.id));
    items.addAll(asyncItems.asData?.value ?? const []);
  }
  return items;
});

/// When false, the home clothing carousel does not auto-scroll.
///
/// Widget tests override this so [WidgetTester.pumpAndSettle] can complete.
final homeClothingCarouselAutoScrollProvider = Provider<bool>((ref) => true);
