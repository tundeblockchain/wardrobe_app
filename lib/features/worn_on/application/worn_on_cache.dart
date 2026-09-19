import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../outfits/application/outfit_scope.dart';
import 'outfit_worn_on_controller.dart';
import 'wardrobe_worn_on_controller.dart';

/// Drops worn-on caches after a mark / unmark so the other surface refetches.
void invalidateWornOnCaches(
  WidgetRef ref, {
  required String wardrobeId,
  String? outfitId,
}) {
  ref.invalidate(wardrobeWornOnControllerProvider(wardrobeId));
  if (outfitId != null) {
    ref.invalidate(
      outfitWornOnControllerProvider(
        OutfitScope(wardrobeId: wardrobeId, outfitId: outfitId),
      ),
    );
  }
}
