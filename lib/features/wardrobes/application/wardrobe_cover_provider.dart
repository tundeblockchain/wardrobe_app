import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../items/data/dio_item_repository.dart';
import '../domain/wardrobe_cover.dart';

/// Loads a wardrobe list-card cover from the existing items API.
///
/// Cover image is the first listed item's photo (client-side). Failures stay
/// on the card as an empty placeholder so the wardrobe list still renders.
final wardrobeCoverProvider = FutureProvider.family<WardrobeCover, String>((
  ref,
  wardrobeId,
) async {
  final items = await ref.watch(itemRepositoryProvider).listItems(wardrobeId);
  return WardrobeCover.fromItems(items);
});
