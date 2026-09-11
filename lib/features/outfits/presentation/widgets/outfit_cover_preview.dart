import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../items/domain/item.dart';
import '../../application/outfit_hero_selection.dart';
import '../../application/outfit_scope.dart';
import '../../application/try_on_history_controller.dart';
import '../../domain/outfit.dart';
import '../../domain/outfit_cover.dart';
import 'outfit_list_preview.dart';

/// List/carousel photo that prefers history or a session hero pick.
class OutfitCoverPreview extends ConsumerWidget {
  const OutfitCoverPreview({
    super.key,
    required this.outfit,
    this.wardrobeItems = const [],
    this.width = 56,
    this.height = 72,
  });

  final Outfit outfit;
  final List<Item> wardrobeItems;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = OutfitScope(
      wardrobeId: outfit.wardrobeId,
      outfitId: outfit.id,
    );
    final history = ref.watch(tryOnHistoryControllerProvider(scope));
    final selected = ref.watch(outfitHeroSelectionProvider(scope));
    return OutfitListPreview(
      outfit: outfit,
      wardrobeItems: wardrobeItems,
      heroImageUrl: latestOutfitTryOnUrl(
        outfit,
        history: history.entries,
        selectedUrl: selected,
      ),
      width: width,
      height: height,
    );
  }
}
