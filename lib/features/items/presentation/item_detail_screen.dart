import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/item_detail_controller.dart';
import '../application/item_detail_state.dart';
import '../application/item_scope.dart';

/// Clothing item detail with edit and delete.
class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({
    super.key,
    required this.wardrobeId,
    required this.itemId,
  });

  final String wardrobeId;
  final String itemId;

  static const editButtonKey = Key('item_detail_edit');
  static const deleteButtonKey = Key('item_detail_delete');
  static const retryButtonKey = Key('item_detail_retry');

  ItemScope get _scope => ItemScope(wardrobeId: wardrobeId, itemId: itemId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(itemDetailControllerProvider(_scope));
    final item = state.item;

    ref.listen(itemDetailControllerProvider(_scope), (previous, next) {
      if (next.isDeleted && context.mounted) {
        context.go(AppRoutes.wardrobeDetail(wardrobeId));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name ?? 'Item'),
        actions: [
          if (item != null) ...[
            IconButton(
              key: editButtonKey,
              tooltip: 'Edit',
              onPressed: state.isSaving
                  ? null
                  : () => context.push(AppRoutes.editItem(wardrobeId, itemId)),
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
          padding: const EdgeInsets.all(24),
          child: _buildBody(context, ref, state),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ItemDetailState state,
  ) {
    if (state.isLoading && state.item == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.item == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'Item not found.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: retryButtonKey,
              onPressed: () => ref
                  .read(itemDetailControllerProvider(_scope).notifier)
                  .refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final item = state.item!;
    return ListView(
      children: [
        Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(item.category.label),
        if (item.subcategory != null && item.subcategory!.isNotEmpty)
          Text(item.subcategory!),
        if (item.brand != null && item.brand!.isNotEmpty) Text(item.brand!),
        if (item.colours.isNotEmpty) Text(item.colours.join(', ')),
        const SizedBox(height: 16),
        Text('Status: ${item.processingStatus.label}'),
        Text('Added ${_formatTimestamp(item.createdAt)}'),
        Text('Updated ${_formatTimestamp(item.updatedAt)}'),
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

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete item?'),
          content: const Text('This cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(itemDetailControllerProvider(_scope).notifier).delete();
  }
}

String _formatTimestamp(DateTime value) {
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$year-$month-$day $hour:$minute';
}
