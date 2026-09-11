import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../../../core/widgets/entity_delete.dart';
import '../../../items/presentation/widgets/item_browse_image.dart';
import '../../application/wardrobe_cover_provider.dart';
import '../../application/wardrobes_controller.dart';
import '../../domain/wardrobe.dart';
import '../../domain/wardrobe_cover.dart';

/// Home-list card: first item photo as cover, or a themed empty placeholder.
class WardrobeListCard extends ConsumerWidget {
  const WardrobeListCard({super.key, required this.wardrobe});

  final Wardrobe wardrobe;

  static Key cardKey(String wardrobeId) => Key('wardrobe_tile_$wardrobeId');

  static Key coverKey(String wardrobeId) => Key('wardrobe_cover_$wardrobeId');

  static Key placeholderKey(String wardrobeId) =>
      Key('wardrobe_cover_placeholder_$wardrobeId');

  static Key deleteKey(String wardrobeId) =>
      Key('wardrobe_card_delete_$wardrobeId');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cover = ref.watch(wardrobeCoverProvider(wardrobe.id));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: AppGloss(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              key: cardKey(wardrobe.id),
              onTap: () => context.push(AppRoutes.wardrobeDetail(wardrobe.id)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: cover.when(
                  data: (WardrobeCover value) =>
                      _CoverBody(wardrobeId: wardrobe.id, cover: value),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => _EmptyWardrobeCover(wardrobeId: wardrobe.id),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.lg,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          context.push(AppRoutes.wardrobeDetail(wardrobe.id)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wardrobe.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            cover.when(
                              data: (value) => value.itemCountLabel,
                              loading: () => 'Loading…',
                              error: (_, _) => 'No items yet',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  EntityDeleteIconButton(
                    key: deleteKey(wardrobe.id),
                    tooltip: 'Delete wardrobe',
                    onPressed: () => _delete(context, ref),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    await EntityDelete.confirmAndRun(
      context,
      title: EntityDelete.wardrobeTitle,
      message: EntityDelete.wardrobeMessage,
      action: () => ref
          .read(wardrobesControllerProvider.notifier)
          .deleteWardrobe(wardrobe.id),
      fallbackError: EntityDelete.wardrobeError,
      errorMessage: () => ref.read(wardrobesControllerProvider).errorMessage,
    );
  }
}

class _CoverBody extends StatelessWidget {
  const _CoverBody({required this.wardrobeId, required this.cover});

  final String wardrobeId;
  final WardrobeCover cover;

  @override
  Widget build(BuildContext context) {
    final item = cover.firstItem;
    if (item == null) {
      return _EmptyWardrobeCover(wardrobeId: wardrobeId);
    }
    return KeyedSubtree(
      key: WardrobeListCard.coverKey(wardrobeId),
      child: ItemBrowseImage(item: item),
    );
  }
}

class _EmptyWardrobeCover extends StatelessWidget {
  const _EmptyWardrobeCover({required this.wardrobeId});

  final String wardrobeId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      key: WardrobeListCard.placeholderKey(wardrobeId),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primaryContainer, scheme.secondaryContainer],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.checkroom_outlined,
          size: 56,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
