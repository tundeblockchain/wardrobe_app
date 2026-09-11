import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/entity_delete.dart';
import '../../items/application/items_controller.dart';
import '../../items/domain/item.dart';
import '../application/outfit_detail_controller.dart';
import '../application/outfit_detail_state.dart';
import '../application/outfit_hero_selection.dart';
import '../application/outfit_scope.dart';
import '../application/try_on_history_controller.dart';
import '../domain/try_on_history.dart';
import 'widgets/outfit_hero_card.dart';
import 'widgets/outfit_item_slider.dart';

/// Outfit detail with edit and delete.
class OutfitDetailScreen extends ConsumerWidget {
  const OutfitDetailScreen({
    super.key,
    required this.wardrobeId,
    required this.outfitId,
  });

  final String wardrobeId;
  final String outfitId;

  static const editButtonKey = Key('outfit_detail_edit');
  static const deleteButtonKey = Key('outfit_detail_delete');
  static const tryOnButtonKey = Key('outfit_detail_try_on');
  static const tryOnAppBarKey = Key('outfit_detail_try_on_app_bar');
  static const retryButtonKey = Key('outfit_detail_retry');

  OutfitScope get _scope =>
      OutfitScope(wardrobeId: wardrobeId, outfitId: outfitId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitDetailControllerProvider(_scope));
    final itemsState = ref.watch(itemsControllerProvider(wardrobeId));
    final history = ref.watch(tryOnHistoryControllerProvider(_scope));
    final selectedHeroUrl = ref.watch(outfitHeroSelectionProvider(_scope));
    final outfit = state.outfit;

    ref.listen(outfitDetailControllerProvider(_scope), (previous, next) {
      if (next.isDeleted && context.mounted) {
        context.go(AppRoutes.outfits(wardrobeId));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(outfit?.name ?? 'Outfit'),
        actions: [
          if (outfit != null) ...[
            IconButton(
              key: tryOnAppBarKey,
              tooltip: 'Try on',
              onPressed: () =>
                  context.push(AppRoutes.tryOn(wardrobeId, outfitId)),
              icon: const Icon(Icons.checkroom_outlined),
            ),
            IconButton(
              key: editButtonKey,
              tooltip: 'Edit',
              onPressed: state.isSaving
                  ? null
                  : () => context.push(
                      AppRoutes.editOutfit(wardrobeId, outfitId),
                    ),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: deleteButtonKey,
              tooltip: 'Delete',
              onPressed: state.isSaving
                  ? null
                  : () => _confirmDelete(context, ref),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.pageInsets,
          child: _buildBody(
            context,
            ref,
            state,
            itemsState.items,
            history.entries,
            selectedHeroUrl,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    OutfitDetailState state,
    List<Item> wardrobeItems,
    List<TryOnHistoryEntry> history,
    String? selectedHeroUrl,
  ) {
    if (state.isLoading && state.outfit == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.outfit == null) {
      return AppErrorState(
        message: state.errorMessage ?? 'Outfit not found.',
        retryKey: retryButtonKey,
        onRetry: () =>
            ref.read(outfitDetailControllerProvider(_scope).notifier).refresh(),
      );
    }

    final outfit = state.outfit!;
    return ListView(
      children: [
        Text(outfit.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        OutfitHeroCard(
          outfit: outfit,
          history: history,
          selectedHeroUrl: selectedHeroUrl,
          onSelectHero: (url) => ref
              .read(outfitHeroSelectionProvider(_scope).notifier)
              .select(url),
          onTryOn: () => context.push(AppRoutes.tryOn(wardrobeId, outfitId)),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          key: tryOnButtonKey,
          onPressed: () => context.push(AppRoutes.tryOn(wardrobeId, outfitId)),
          icon: const Icon(Icons.checkroom_outlined),
          label: const Text('Try on'),
        ),
        const SizedBox(height: 24),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        OutfitItemSlider(
          assignments: outfit.items,
          wardrobeItems: wardrobeItems,
          onItemTap: (itemId) =>
              context.push(AppRoutes.itemDetail(wardrobeId, itemId)),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            state.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
        if (state.isSaving) ...[
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) {
    return EntityDelete.confirmAndRun(
      context,
      title: EntityDelete.outfitTitle,
      message: EntityDelete.outfitMessage,
      action: () =>
          ref.read(outfitDetailControllerProvider(_scope).notifier).delete(),
      fallbackError: EntityDelete.outfitError,
      errorMessage: () =>
          ref.read(outfitDetailControllerProvider(_scope)).errorMessage,
    );
  }
}
