import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/enlarged_image_popup.dart';
import '../../../core/widgets/entity_delete.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../application/item_detail_controller.dart';
import '../application/item_detail_state.dart';
import '../application/item_local_preview_cache.dart';
import '../application/item_scope.dart';
import '../domain/item_detail_meta.dart';
import 'widgets/item_browse_image.dart';
import 'widgets/item_detail_meta_block.dart';

/// Clothing item detail with edit and delete.
class ItemDetailScreen extends ConsumerStatefulWidget {
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
  static const imageTapKey = Key('item_detail_image_tap');

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen>
    with RouteAware {
  RouteObserver<ModalRoute<void>>? _observer;

  ItemScope get _scope =>
      ItemScope(wardrobeId: widget.wardrobeId, itemId: widget.itemId);

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
    ref.read(itemDetailControllerProvider(_scope).notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemDetailControllerProvider(_scope));
    final item = state.item;
    final wardrobes = [
      for (final wardrobe in ref.watch(wardrobesControllerProvider).wardrobes)
        if (item != null && wardrobe.id == item.wardrobeId)
          ItemDetailMetaLink(id: wardrobe.id, label: wardrobe.name),
    ];
    final outfits = [
      for (final outfit
          in ref.watch(outfitsControllerProvider(widget.wardrobeId)).outfits)
        if (item != null && outfit.items.any((slot) => slot.itemId == item.id))
          ItemDetailMetaLink(id: outfit.id, label: outfit.name),
    ];

    ref.listen(itemDetailControllerProvider(_scope), (previous, next) {
      if (next.isDeleted && context.mounted) {
        context.go(AppRoutes.wardrobeDetail(widget.wardrobeId));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name ?? 'Item'),
        actions: [
          if (item != null) ...[
            IconButton(
              key: ItemDetailScreen.editButtonKey,
              tooltip: 'Edit',
              onPressed: state.isSaving
                  ? null
                  : () => context.push(
                      AppRoutes.editItem(widget.wardrobeId, widget.itemId),
                    ),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              key: ItemDetailScreen.deleteButtonKey,
              tooltip: 'Delete',
              onPressed: state.isSaving ? null : () => _confirmDelete(context),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(itemDetailControllerProvider(_scope).notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: AppSpacing.pageInsets,
            children: [_buildBody(context, state, wardrobes, outfits)],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ItemDetailState state,
    List<ItemDetailMetaLink> wardrobes,
    List<ItemDetailMetaLink> outfits,
  ) {
    if (state.isLoading && state.item == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state.item == null) {
      return AppErrorState(
        message: state.errorMessage ?? 'Item not found.',
        retryKey: ItemDetailScreen.retryButtonKey,
        onRetry: () =>
            ref.read(itemDetailControllerProvider(_scope).notifier).refresh(),
      );
    }

    final item = state.item!;
    final localPreview = ref.watch(itemLocalPreviewCacheProvider)[item.id];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            key: ItemDetailScreen.imageTapKey,
            onTap: () => EnlargedImagePopup.show(
              context,
              image: ItemBrowseImage(
                item: item,
                localPreviewBytes: localPreview,
                fit: BoxFit.contain,
              ),
            ),
            child: ClipRRect(
              borderRadius: AppRadii.card,
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: ItemBrowseImage(
                  item: item,
                  localPreviewBytes: localPreview,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ItemDetailMetaBlock(
          item: item,
          wardrobes: wardrobes,
          outfits: outfits,
          onWardrobeTap: (wardrobeId) =>
              context.push(AppRoutes.wardrobeDetail(wardrobeId)),
          onOutfitTap: (outfitId) =>
              context.push(AppRoutes.outfitDetail(widget.wardrobeId, outfitId)),
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

  Future<void> _confirmDelete(BuildContext context) {
    return EntityDelete.confirmAndRun(
      context,
      title: EntityDelete.itemTitle,
      message: EntityDelete.itemMessage,
      action: () =>
          ref.read(itemDetailControllerProvider(_scope).notifier).delete(),
      fallbackError: EntityDelete.itemError,
      errorMessage: () =>
          ref.read(itemDetailControllerProvider(_scope)).errorMessage,
    );
  }
}
