import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_fade_in.dart';
import '../../../core/widgets/entity_delete.dart';
import '../../items/application/items_controller.dart';
import '../application/outfits_controller.dart';
import '../domain/outfit.dart';
import 'widgets/outfit_carousel.dart';
import 'widgets/outfit_list_tile.dart';
import '../../../core/widgets/app_gloss.dart';

/// Saved outfits for one wardrobe.
class OutfitsScreen extends ConsumerWidget {
  const OutfitsScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const createButtonKey = Key('outfits_create');
  static const emptyStateKey = Key('outfits_empty');
  static const retryButtonKey = Key('outfits_retry');
  static const recommendationsButtonKey = Key('outfits_recommendations');
  static const dressingRoomButtonKey = Key('outfits_dressing_room');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitsControllerProvider(wardrobeId));
    final wardrobeItems = ref.watch(itemsControllerProvider(wardrobeId)).items;

    return Scaffold(
      appBar: AppGlossBar(
        title: const Text('Outfits'),
        actions: [
          IconButton(
            key: dressingRoomButtonKey,
            tooltip: 'Dressing room',
            onPressed: () => context.push(AppRoutes.dressingRoom(wardrobeId)),
            icon: const Icon(Icons.face_retouching_natural_outlined),
          ),
          IconButton(
            key: recommendationsButtonKey,
            tooltip: 'Suggested outfits',
            onPressed: () =>
                context.push(AppRoutes.recommendations(wardrobeId)),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: createButtonKey,
        tooltip: 'Create outfit',
        onPressed: () => context.push(AppRoutes.createOutfit(wardrobeId)),
        child: const Icon(Icons.checkroom_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(outfitsControllerProvider(wardrobeId).notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            if (state.isLoading && state.outfits.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.outfits.isEmpty)
              AppErrorState(
                message: state.errorMessage!,
                retryKey: OutfitsScreen.retryButtonKey,
                onRetry: () => ref
                    .read(outfitsControllerProvider(wardrobeId).notifier)
                    .refresh(),
              )
            else if (state.isEmpty)
              AppEmptyState(
                key: OutfitsScreen.emptyStateKey,
                icon: Icons.checkroom_outlined,
                title: 'No outfits yet',
                message: 'Build a look from items in this wardrobe.',
                actionLabel: 'Create outfit',
                onAction: () =>
                    context.push(AppRoutes.createOutfit(wardrobeId)),
              )
            else ...[
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              AppFadeIn(
                child: OutfitCarousel(
                  wardrobeId: wardrobeId,
                  outfits: state.outfits,
                  wardrobeItems: wardrobeItems,
                  onDelete: (outfit) => _deleteOutfit(context, ref, outfit),
                  cardKeyFor: (outfit) =>
                      OutfitListTile.defaultTileKey(outfit.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _deleteOutfit(
    BuildContext context,
    WidgetRef ref,
    Outfit outfit,
  ) {
    return EntityDelete.confirmAndRun(
      context,
      title: EntityDelete.outfitTitle,
      message: EntityDelete.outfitMessage,
      action: () => ref
          .read(outfitsControllerProvider(wardrobeId).notifier)
          .deleteOutfit(outfit.id),
      fallbackError: EntityDelete.outfitError,
      errorMessage: () =>
          ref.read(outfitsControllerProvider(wardrobeId)).errorMessage,
    );
  }
}
