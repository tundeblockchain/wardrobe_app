import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/router/app_routes.dart';
import '../../items/application/items_controller.dart';
import '../../items/domain/item.dart';
import '../../outfits/domain/outfit.dart';
import '../application/recommendation_detail_controller.dart';
import '../application/recommendation_detail_state.dart';
import '../application/recommendation_scope.dart';
import '../application/recommendations_controller.dart';

/// Preview of one suggestion. Save uses existing outfit create and is opt-in.
class RecommendationDetailScreen extends ConsumerWidget {
  const RecommendationDetailScreen({
    super.key,
    required this.wardrobeId,
    required this.index,
  });

  final String wardrobeId;
  final int index;

  static const saveButtonKey = Key('recommendation_detail_save');
  static const retryButtonKey = Key('recommendation_detail_retry');

  RecommendationScope get _scope =>
      RecommendationScope(wardrobeId: wardrobeId, index: index);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationDetailControllerProvider(_scope));
    final itemsState = ref.watch(itemsControllerProvider(wardrobeId));
    final recommendation = state.recommendation;

    ref.listen(recommendationDetailControllerProvider(_scope), (
      previous,
      next,
    ) {
      final saved = next.savedOutfit;
      if (saved != null && previous?.savedOutfit?.id != saved.id) {
        if (context.mounted) {
          context.go(AppRoutes.outfitDetail(wardrobeId, saved.id));
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(recommendation?.name ?? 'Suggested look')),
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
    RecommendationDetailState state,
    List<Item> wardrobeItems,
  ) {
    if (state.isLoading && state.recommendation == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.recommendation == null) {
      return AppErrorState(
        message: state.errorMessage ?? 'Suggestion not found.',
        retryKey: retryButtonKey,
        onRetry: () async {
          await ref
              .read(recommendationsControllerProvider(wardrobeId).notifier)
              .refresh();
          if (!context.mounted) {
            return;
          }
          await ref
              .read(recommendationDetailControllerProvider(_scope).notifier)
              .refresh();
        },
      );
    }

    final recommendation = state.recommendation!;
    final itemsById = {for (final item in wardrobeItems) item.id: item};
    return ListView(
      children: [
        Text(
          recommendation.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text('Suggested look — not saved until you choose Save.'),
        const SizedBox(height: 24),
        Text('Slots', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final OutfitItem assignment in recommendation.items)
          Card(
            child: ListTile(
              key: Key(
                'recommendation_detail_slot_${assignment.slot.wireValue}',
              ),
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
        const SizedBox(height: 24),
        FilledButton(
          key: saveButtonKey,
          onPressed: state.isSaving
              ? null
              : () => ref
                    .read(
                      recommendationDetailControllerProvider(_scope).notifier,
                    )
                    .save(),
          child: state.isSaving
              ? const AppButtonSpinner()
              : const Text('Save outfit'),
        ),
      ],
    );
  }
}
