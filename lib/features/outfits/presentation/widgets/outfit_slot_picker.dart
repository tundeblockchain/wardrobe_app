import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../items/application/items_controller.dart';
import '../../../items/domain/item.dart';
import '../../domain/outfit.dart';

/// Slot list that reuses the wardrobe items cache for picking.
class OutfitSlotPicker extends ConsumerWidget {
  const OutfitSlotPicker({
    super.key,
    required this.wardrobeId,
    required this.assignments,
    required this.onAssign,
    required this.onClear,
    this.enabled = true,
  });

  final String wardrobeId;
  final List<OutfitItem> assignments;
  final void Function(ItemCategory slot, String itemId) onAssign;
  final void Function(ItemCategory slot) onClear;
  final bool enabled;

  static const slotListKey = Key('outfit_slot_list');

  OutfitItem? _assignmentFor(ItemCategory slot) {
    for (final item in assignments) {
      if (item.slot == slot) {
        return item;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsState = ref.watch(itemsControllerProvider(wardrobeId));
    final itemsById = {for (final item in itemsState.items) item.id: item};

    return Column(
      key: slotListKey,
      children: [
        if (itemsState.isLoading && itemsState.items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (itemsState.errorMessage != null && itemsState.items.isEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              itemsState.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        for (final slot in ItemCategory.values)
          _SlotTile(
            slot: slot,
            assignment: _assignmentFor(slot),
            resolvedItem: () {
              final assignment = _assignmentFor(slot);
              if (assignment == null) {
                return null;
              }
              return itemsById[assignment.itemId];
            }(),
            enabled: enabled,
            onPick: () => _pickItem(context, slot, itemsState.items),
            onClear: () => onClear(slot),
          ),
      ],
    );
  }

  Future<void> _pickItem(
    BuildContext context,
    ItemCategory slot,
    List<Item> items,
  ) async {
    final candidates = [
      for (final item in items)
        if (item.category == slot) item,
    ];

    if (candidates.isEmpty) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No ${slot.label.toLowerCase()} items yet.')),
      );
      return;
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Text(
                  'Choose a ${slot.label.toLowerCase()}',
                  style: Theme.of(sheetContext).textTheme.titleMedium,
                ),
              ),
              for (final item in candidates)
                ListTile(
                  key: Key('outfit_pick_item_${item.id}'),
                  leading: CircleAvatar(child: Text(item.category.label[0])),
                  title: Text(item.name),
                  subtitle: Text(
                    [
                      item.category.label,
                      if (item.brand != null && item.brand!.isNotEmpty)
                        item.brand,
                    ].join(' · '),
                  ),
                  onTap: () => Navigator.of(sheetContext).pop(item.id),
                ),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      onAssign(slot, selected);
    }
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.slot,
    required this.assignment,
    required this.resolvedItem,
    required this.enabled,
    required this.onPick,
    required this.onClear,
  });

  final ItemCategory slot;
  final OutfitItem? assignment;
  final Item? resolvedItem;
  final bool enabled;
  final VoidCallback onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        resolvedItem?.name ??
        (assignment == null ? 'Tap to pick an item' : 'Item selected');
    return Card(
      child: ListTile(
        key: Key('outfit_slot_${slot.wireValue}'),
        leading: CircleAvatar(child: Text(slot.label[0])),
        title: Text(slot.label),
        subtitle: Text(subtitle),
        enabled: enabled,
        onTap: enabled ? onPick : null,
        trailing: assignment == null
            ? const Icon(Icons.add)
            : IconButton(
                key: Key('outfit_slot_clear_${slot.wireValue}'),
                tooltip: 'Clear ${slot.label}',
                onPressed: enabled ? onClear : null,
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }
}
