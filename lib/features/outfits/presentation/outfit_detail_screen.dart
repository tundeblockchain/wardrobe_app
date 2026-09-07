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
import '../application/outfit_scope.dart';
import '../domain/outfit.dart';

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
          child: _buildBody(context, ref, state, itemsState.items),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    OutfitDetailState state,
    List<Item> wardrobeItems,
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
    final itemsById = {for (final item in wardrobeItems) item.id: item};
    return ListView(
      children: [
        Text(outfit.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 24),
        FilledButton.icon(
          key: tryOnButtonKey,
          onPressed: () => context.push(AppRoutes.tryOn(wardrobeId, outfitId)),
          icon: const Icon(Icons.checkroom_outlined),
          label: const Text('Try on'),
        ),
        const SizedBox(height: 24),
        Text('Slots', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final OutfitItem assignment in outfit.items)
          Card(
            child: ListTile(
              key: Key('outfit_detail_slot_${assignment.slot.wireValue}'),
              leading: CircleAvatar(child: Text(assignment.slot.label[0])),
              title: Text(assignment.slot.label),
              subtitle: Text(
                itemsById[assignment.itemId]?.name ?? 'Item in this wardrobe',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(
                AppRoutes.itemDetail(wardrobeId, assignment.itemId),
              ),
            ),
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
