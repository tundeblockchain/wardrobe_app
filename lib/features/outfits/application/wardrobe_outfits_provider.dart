import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/session/session_gate.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../data/dio_outfit_repository.dart';
import '../domain/outfit.dart';

/// Outfits for one wardrobe via the existing list API (no render hydration).
///
/// Used by header search so outfits are available without opening a wardrobe.
final wardrobeOutfitsProvider = FutureProvider.family<List<Outfit>, String>((
  ref,
  wardrobeId,
) async {
  if (!watchAllowsUserDataFetch(ref)) {
    return const [];
  }
  return ref.watch(outfitRepositoryProvider).listOutfits(wardrobeId);
});

/// Flattened outfits from every wardrobe, in wardrobe-list order.
final homeOutfitsProvider = Provider<List<Outfit>>((ref) {
  final wardrobes = ref.watch(wardrobesControllerProvider).wardrobes;
  final outfits = <Outfit>[];
  for (final wardrobe in wardrobes) {
    final asyncOutfits = ref.watch(wardrobeOutfitsProvider(wardrobe.id));
    outfits.addAll(asyncOutfits.asData?.value ?? const []);
  }
  return outfits;
});
