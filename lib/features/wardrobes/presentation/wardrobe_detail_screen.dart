import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/wardrobe_detail_controller.dart';
import '../application/wardrobe_detail_state.dart';
import '../domain/wardrobe_validators.dart';

/// Wardrobe metadata screen. Items and outfits land in later tickets.
class WardrobeDetailScreen extends ConsumerWidget {
  const WardrobeDetailScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const renameButtonKey = Key('wardrobe_detail_rename');
  static const deleteButtonKey = Key('wardrobe_detail_delete');
  static const retryButtonKey = Key('wardrobe_detail_retry');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wardrobeDetailControllerProvider(wardrobeId));
    final wardrobe = state.wardrobe;

    ref.listen(wardrobeDetailControllerProvider(wardrobeId), (previous, next) {
      if (next.isDeleted && context.mounted) {
        context.go(AppRoutes.wardrobes);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(wardrobe?.name ?? 'Wardrobe'),
        actions: [
          if (wardrobe != null) ...[
            IconButton(
              key: renameButtonKey,
              tooltip: 'Rename',
              onPressed: state.isSaving
                  ? null
                  : () => _rename(context, ref, wardrobe.name),
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
    WardrobeDetailState state,
  ) {
    if (state.isLoading && state.wardrobe == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.wardrobe == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'Wardrobe not found.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: retryButtonKey,
              onPressed: () => ref
                  .read(wardrobeDetailControllerProvider(wardrobeId).notifier)
                  .refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final wardrobe = state.wardrobe!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(wardrobe.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text('Created ${_formatTimestamp(wardrobe.createdAt)}'),
        Text('Updated ${_formatTimestamp(wardrobe.updatedAt)}'),
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

  Future<void> _rename(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Rename wardrobe'),
          content: TextFormField(
            controller: controller,
            autofocus: true,
            maxLength: WardrobeValidators.maxNameLength,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final error = WardrobeValidators.name(controller.text);
                if (error != null) {
                  ScaffoldMessenger.of(dialogContext)
                      .showSnackBar(SnackBar(content: Text(error)));
                  return;
                }
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (name == null) {
      return;
    }
    await ref
        .read(wardrobeDetailControllerProvider(wardrobeId).notifier)
        .rename(name);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete wardrobe?'),
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
    await ref
        .read(wardrobeDetailControllerProvider(wardrobeId).notifier)
        .delete();
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
