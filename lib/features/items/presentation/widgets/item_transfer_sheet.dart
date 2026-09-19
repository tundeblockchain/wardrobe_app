import 'package:flutter/material.dart';

import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../wardrobes/domain/wardrobe.dart';
import '../../domain/item_transfer.dart';

/// Result of the move/copy picker + confirm flow.
class ItemTransferPick {
  const ItemTransferPick({required this.wardrobe});

  final Wardrobe wardrobe;
}

/// Burgundy/plum destination picker. Skips fade when [AppMotion.reduce].
class ItemTransferSheet extends StatelessWidget {
  const ItemTransferSheet({
    super.key,
    required this.kind,
    required this.destinations,
    this.isLoading = false,
    this.errorMessage,
  });

  static const sheetKey = Key('item_transfer_sheet');
  static const emptyKey = Key('item_transfer_empty');
  static const loadingKey = Key('item_transfer_loading');
  static const confirmKey = Key('item_transfer_confirm');
  static const cancelKey = Key('item_transfer_cancel');

  static Key destinationKey(String wardrobeId) =>
      Key('item_transfer_destination_$wardrobeId');

  final ItemTransferKind kind;
  final List<Wardrobe> destinations;
  final bool isLoading;
  final String? errorMessage;

  /// Lists other owned wardrobes, then confirms the chosen destination.
  static Future<ItemTransferPick?> show(
    BuildContext context, {
    required ItemTransferKind kind,
    required List<Wardrobe> destinations,
    bool isLoading = false,
    String? errorMessage,
  }) async {
    final selected = await showModalBottomSheet<Wardrobe>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return ItemTransferSheet(
          kind: kind,
          destinations: destinations,
          isLoading: isLoading,
          errorMessage: errorMessage,
        );
      },
    );
    if (selected == null || !context.mounted) {
      return null;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(ItemTransferMessages.confirmTitle(kind)),
          content: Text(
            ItemTransferMessages.confirmMessage(kind, selected.name),
          ),
          actions: [
            TextButton(
              key: cancelKey,
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              key: confirmKey,
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(kind.verb),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return null;
    }
    return ItemTransferPick(wardrobe: selected);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reduced = AppMotion.reduce(context);
    final body = ListView(
      shrinkWrap: true,
      padding: AppSpacing.pageInsets,
      children: [
        Text(
          ItemTransferMessages.pickerTitle(kind),
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isLoading && destinations.isEmpty)
          const Padding(
            key: loadingKey,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (destinations.isEmpty)
          Padding(
            key: emptyKey,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              errorMessage ?? ItemTransferMessages.noDestinations,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          )
        else
          for (final wardrobe in destinations)
            ListTile(
              key: destinationKey(wardrobe.id),
              leading: CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                foregroundColor: scheme.onPrimaryContainer,
                child: const Icon(Icons.checkroom_outlined),
              ),
              title: Text(wardrobe.name),
              trailing: Icon(
                Icons.chevron_right,
                color: scheme.onSurfaceVariant,
              ),
              onTap: () => Navigator.of(context).pop(wardrobe),
            ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );

    return KeyedSubtree(
      key: sheetKey,
      child: SafeArea(child: reduced ? body : AppFadeIn(child: body)),
    );
  }
}
