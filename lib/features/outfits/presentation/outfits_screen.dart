import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/outfits_controller.dart';
import '../domain/outfit.dart';

/// Saved outfits for one wardrobe.
class OutfitsScreen extends ConsumerWidget {
  const OutfitsScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const createButtonKey = Key('outfits_create');
  static const emptyStateKey = Key('outfits_empty');
  static const retryButtonKey = Key('outfits_retry');
  static const recommendationsButtonKey = Key('outfits_recommendations');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitsControllerProvider(wardrobeId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfits'),
        actions: [
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
              for (final outfit in state.outfits)
                _OutfitTile(wardrobeId: wardrobeId, outfit: outfit),
            ],
          ],
        ),
      ),
    );
  }
}

class _OutfitTile extends StatelessWidget {
  const _OutfitTile({required this.wardrobeId, required this.outfit});

  final String wardrobeId;
  final Outfit outfit;

  @override
  Widget build(BuildContext context) {
    final slotCount = outfit.items.length;
    return Card(
      child: ListTile(
        key: Key('outfit_tile_${outfit.id}'),
        leading: const CircleAvatar(child: Icon(Icons.checkroom_outlined)),
        title: Text(outfit.name),
        subtitle: Text(slotCount == 1 ? '1 item' : '$slotCount items'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            context.push(AppRoutes.outfitDetail(wardrobeId, outfit.id)),
      ),
    );
  }
}
