import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/destructive_confirm_dialog.dart';
import '../application/item_detail_controller.dart';
import '../application/item_detail_state.dart';
import '../application/item_scope.dart';
import 'widgets/processing_status_chip.dart';

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
            children: [_buildBody(context, state)],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ItemDetailState state) {
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
    final ai = item.ai;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(item.category.label),
        if (item.subcategory != null && item.subcategory!.isNotEmpty)
          Text(item.subcategory!),
        if (item.brand != null && item.brand!.isNotEmpty) Text(item.brand!),
        if (item.colours.isNotEmpty) Text(item.colours.join(', ')),
        const SizedBox(height: 16),
        ProcessingStatusBanner(
          status: item.processingStatus,
          processingError: item.processingError,
        ),
        if (ai != null) ...[
          const SizedBox(height: 16),
          Text('Detected', style: Theme.of(context).textTheme.titleSmall),
          if (ai.detectedCategory != null) Text(ai.detectedCategory!.label),
          if (ai.detectedSubcategory != null &&
              ai.detectedSubcategory!.isNotEmpty)
            Text(ai.detectedSubcategory!),
          if (ai.detectedColours.isNotEmpty)
            Text(ai.detectedColours.join(', ')),
        ],
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

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await DestructiveConfirmDialog.show(
      context,
      title: 'Delete item?',
      message:
          'This permanently deletes this clothing item and its photos. '
          'This cannot be undone.',
    );
    if (!confirmed) {
      return;
    }
    final ok = await ref
        .read(itemDetailControllerProvider(_scope).notifier)
        .delete();
    if (ok || !context.mounted) {
      return;
    }
    final message =
        ref.read(itemDetailControllerProvider(_scope)).errorMessage ??
        'Could not delete this item.';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
