import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/enlarged_image_popup.dart';
import '../../../core/widgets/entity_delete.dart';
import '../../coaches/domain/coach_screen.dart';
import '../../coaches/presentation/screen_coach_host.dart';
import '../../outfits/application/outfits_controller.dart';
import '../../search/presentation/app_search_gloss_bar.dart';
import '../../shopping_links/application/item_shopping_links_controller.dart';
import '../../shopping_links/presentation/widgets/related_shopping_links_section.dart';
import '../../wardrobes/application/wardrobes_controller.dart';
import '../../wardrobes/domain/wardrobe.dart';
import '../application/item_detail_controller.dart';
import '../application/item_detail_state.dart';
import '../application/item_local_preview_cache.dart';
import '../application/item_scope.dart';
import '../domain/item.dart';
import '../domain/item_detail_meta.dart';
import '../domain/item_transfer.dart';
import 'widgets/item_browse_image.dart';
import 'widgets/item_detail_meta_block.dart';
import 'widgets/item_transfer_sheet.dart';

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
  static const overflowMenuKey = Key('item_detail_overflow');
  static const moveMenuKey = Key('item_detail_move');
  static const copyMenuKey = Key('item_detail_copy');

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
    ref.read(itemShoppingLinksControllerProvider(_scope).notifier).refresh();
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

    return ScreenCoachHost(
      screen: CoachScreen.item,
      child: Scaffold(
        appBar: AppSearchGlossBar(
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
                onPressed: state.isSaving
                    ? null
                    : () => _confirmDelete(context),
                icon: const Icon(Icons.delete_outline),
              ),
              PopupMenuButton<ItemTransferKind>(
                key: ItemDetailScreen.overflowMenuKey,
                tooltip: 'More',
                enabled: !state.isSaving,
                onSelected: (kind) => _startTransfer(context, item, kind),
                itemBuilder: (menuContext) {
                  final enabled = canTransferItem(item);
                  return [
                    PopupMenuItem(
                      key: ItemDetailScreen.moveMenuKey,
                      value: ItemTransferKind.move,
                      enabled: enabled,
                      child: const Text('Move'),
                    ),
                    PopupMenuItem(
                      key: ItemDetailScreen.copyMenuKey,
                      value: ItemTransferKind.copy,
                      enabled: enabled,
                      child: const Text('Copy'),
                    ),
                  ];
                },
              ),
            ],
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                ref
                    .read(itemDetailControllerProvider(_scope).notifier)
                    .refresh(),
                ref
                    .read(itemShoppingLinksControllerProvider(_scope).notifier)
                    .refresh(),
              ]);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.pageInsets,
              children: [_buildBody(context, state, wardrobes, outfits)],
            ),
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
        const SizedBox(height: 16),
        RelatedShoppingLinksSection(
          state: ref.watch(itemShoppingLinksControllerProvider(_scope)),
          onRetry: () => ref
              .read(itemShoppingLinksControllerProvider(_scope).notifier)
              .refresh(),
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

  Future<void> _startTransfer(
    BuildContext context,
    Item item,
    ItemTransferKind kind,
  ) async {
    if (!canTransferItem(item)) {
      _showMessage(context, ItemTransferMessages.processing);
      return;
    }
    if (kind == ItemTransferKind.move) {
      final outfits = [
        for (final outfit
            in ref.read(outfitsControllerProvider(widget.wardrobeId)).outfits)
          if (outfit.items.any((slot) => slot.itemId == item.id)) outfit.name,
      ];
      if (outfits.isNotEmpty) {
        _showMessage(context, ItemTransferMessages.outfitBlock);
        return;
      }
    }

    final wardrobesState = ref.read(wardrobesControllerProvider);
    var destinations = destinationsExcluding<Wardrobe>(
      wardrobesState.wardrobes,
      (wardrobe) => wardrobe.id == item.wardrobeId,
    );
    if (destinations.isEmpty && !wardrobesState.isLoading) {
      await ref.read(wardrobesControllerProvider.notifier).refresh();
      if (!context.mounted) {
        return;
      }
      destinations = destinationsExcluding<Wardrobe>(
        ref.read(wardrobesControllerProvider).wardrobes,
        (wardrobe) => wardrobe.id == item.wardrobeId,
      );
    }

    final pick = await ItemTransferSheet.show(
      context,
      kind: kind,
      destinations: destinations,
      isLoading: ref.read(wardrobesControllerProvider).isLoading,
      errorMessage: ref.read(wardrobesControllerProvider).errorMessage,
    );
    if (pick == null || !context.mounted) {
      return;
    }

    final transferred = kind == ItemTransferKind.move
        ? await ref
              .read(itemDetailControllerProvider(_scope).notifier)
              .moveTo(pick.wardrobe.id)
        : await ref
              .read(itemDetailControllerProvider(_scope).notifier)
              .copyTo(pick.wardrobe.id);
    if (!context.mounted) {
      return;
    }
    if (transferred == null) {
      final error = ref.read(itemDetailControllerProvider(_scope)).errorMessage;
      _showMessage(context, error ?? ItemTransferMessages.failed(kind));
      return;
    }

    _showMessage(
      context,
      ItemTransferMessages.success(kind, pick.wardrobe.name),
      actionLabel: kind == ItemTransferKind.copy ? 'View' : null,
      onAction: kind == ItemTransferKind.copy
          ? () {
              if (context.mounted) {
                context.push(
                  AppRoutes.itemDetail(transferred.wardrobeId, transferred.id),
                );
              }
            }
          : null,
    );
    if (kind == ItemTransferKind.move) {
      context.go(AppRoutes.itemDetail(transferred.wardrobeId, transferred.id));
    }
  }

  void _showMessage(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
      ),
    );
  }
}
