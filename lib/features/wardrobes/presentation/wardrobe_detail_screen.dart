import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../items/application/items_controller.dart';
import '../../items/application/items_state.dart';
import '../../items/domain/item_list_filters.dart';
import '../../items/presentation/widgets/item_filter_bar.dart';
import '../../items/presentation/widgets/item_grid_card.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../outfits/application/outfits_state.dart';
import '../../outfits/domain/outfit.dart';
import '../application/wardrobe_detail_controller.dart';
import '../application/wardrobe_detail_state.dart';
import '../domain/wardrobe_validators.dart';

/// Wardrobe metadata plus nested clothing items and an outfits entry point.
class WardrobeDetailScreen extends ConsumerStatefulWidget {
  const WardrobeDetailScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const renameButtonKey = Key('wardrobe_detail_rename');
  static const deleteButtonKey = Key('wardrobe_detail_delete');
  static const retryButtonKey = Key('wardrobe_detail_retry');
  static const addItemButtonKey = Key('wardrobe_detail_add_item');
  static const itemsEmptyKey = Key('wardrobe_detail_items_empty');
  static const outfitsButtonKey = Key('wardrobe_detail_outfits');
  static const createOutfitButtonKey = Key('wardrobe_detail_create_outfit');

  @override
  ConsumerState<WardrobeDetailScreen> createState() =>
      _WardrobeDetailScreenState();
}

class _WardrobeDetailScreenState extends ConsumerState<WardrobeDetailScreen>
    with RouteAware {
  RouteObserver<ModalRoute<void>>? _observer;

  String get wardrobeId => widget.wardrobeId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final observer = ref.read(routeObserverProvider);
    final route = ModalRoute.of(context);
    if (!identical(_observer, observer)) {
      _observer?.unsubscribe(this);
      _observer = observer;
    }
    if (route != null) {
      observer.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    _observer?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(itemsControllerProvider(wardrobeId).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wardrobeDetailControllerProvider(wardrobeId));
    final itemsState = ref.watch(itemsControllerProvider(wardrobeId));
    final outfitsState = ref.watch(outfitsControllerProvider(wardrobeId));
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
              key: WardrobeDetailScreen.renameButtonKey,
              tooltip: 'Rename',
              onPressed: state.isSaving
                  ? null
                  : () => _rename(context, ref, wardrobe.name),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: WardrobeDetailScreen.deleteButtonKey,
              tooltip: 'Delete',
              onPressed: state.isSaving
                  ? null
                  : () => _confirmDelete(context, ref),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      floatingActionButton: wardrobe == null
          ? null
          : FloatingActionButton(
              key: WardrobeDetailScreen.addItemButtonKey,
              tooltip: 'Add item',
              onPressed: () => context.push(AppRoutes.createItem(wardrobeId)),
              child: const Icon(Icons.add_a_photo_outlined),
            ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              ref
                  .read(wardrobeDetailControllerProvider(wardrobeId).notifier)
                  .refresh(),
              ref.read(itemsControllerProvider(wardrobeId).notifier).refresh(),
              ref
                  .read(outfitsControllerProvider(wardrobeId).notifier)
                  .refresh(),
            ]);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24),
            children: [
              _buildBody(context, ref, state, itemsState, outfitsState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    WardrobeDetailState state,
    ItemsState itemsState,
    OutfitsState outfitsState,
  ) {
    if (state.isLoading && state.wardrobe == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
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
              key: WardrobeDetailScreen.retryButtonKey,
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
        const SizedBox(height: 32),
        Text('Outfits', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _OutfitsSection(wardrobeId: wardrobeId, state: outfitsState),
        const SizedBox(height: 32),
        Text('Items', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _ItemsSection(wardrobeId: wardrobeId, state: itemsState),
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

class _OutfitsSection extends ConsumerWidget {
  const _OutfitsSection({required this.wardrobeId, required this.state});

  final String wardrobeId;
  final OutfitsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          key: WardrobeDetailScreen.outfitsButtonKey,
          contentPadding: EdgeInsets.zero,
          leading: const CircleAvatar(child: Icon(Icons.checkroom_outlined)),
          title: const Text('Saved outfits'),
          subtitle: Text(
            state.isLoading && state.outfits.isEmpty
                ? 'Loading…'
                : state.isEmpty
                ? 'Build a look from items in this wardrobe'
                : state.outfits.length == 1
                ? '1 outfit'
                : '${state.outfits.length} outfits',
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push(AppRoutes.outfits(wardrobeId)),
        ),
        if (!state.isEmpty)
          for (final Outfit outfit in state.outfits.take(3))
            Card(
              child: ListTile(
                key: Key('wardrobe_outfit_tile_${outfit.id}'),
                title: Text(outfit.name),
                subtitle: Text(
                  outfit.items.length == 1
                      ? '1 item'
                      : '${outfit.items.length} items',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () =>
                    context.push(AppRoutes.outfitDetail(wardrobeId, outfit.id)),
              ),
            ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            key: WardrobeDetailScreen.createOutfitButtonKey,
            onPressed: () => context.push(AppRoutes.createOutfit(wardrobeId)),
            child: const Text('Create outfit'),
          ),
        ),
      ],
    );
  }
}

class _ItemsSection extends ConsumerWidget {
  const _ItemsSection({required this.wardrobeId, required this.state});

  final String wardrobeId;
  final ItemsState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.errorMessage != null && state.items.isEmpty) {
      return Column(
        children: [
          Text(
            state.errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => ref
                .read(itemsControllerProvider(wardrobeId).notifier)
                .refresh(),
            child: const Text('Retry items'),
          ),
        ],
      );
    }
    if (state.isEmpty && state.filters.isEmpty) {
      return Padding(
        key: WardrobeDetailScreen.itemsEmptyKey,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const Text('No items yet. Add a photo of a clothing item.'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.push(AppRoutes.createItem(wardrobeId)),
              child: const Text('Add item'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (state.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ItemFilterBar(
          filters: state.filters,
          onChanged: (ItemListFilters filters) {
            ref
                .read(itemsControllerProvider(wardrobeId).notifier)
                .setFilters(filters);
          },
        ),
        const SizedBox(height: 16),
        if (state.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No items match these filters.'),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.95,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ItemGridCard(
                key: Key('item_tile_${item.id}'),
                wardrobeId: wardrobeId,
                item: item,
              );
            },
          ),
      ],
    );
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
