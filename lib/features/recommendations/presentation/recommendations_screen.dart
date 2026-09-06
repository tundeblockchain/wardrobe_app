import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/recommendations_controller.dart';
import '../domain/recommendation.dart';

/// Suggested outfits for one wardrobe. Additive — failures stay on this screen.
class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const emptyStateKey = Key('recommendations_empty');
  static const retryButtonKey = Key('recommendations_retry');
  static const unavailableKey = Key('recommendations_unavailable');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationsControllerProvider(wardrobeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Suggested outfits')),
      body: RefreshIndicator(
        onRefresh: () => ref
            .read(recommendationsControllerProvider(wardrobeId).notifier)
            .refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            if (state.isLoading && state.recommendations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.isUnavailable)
              AppErrorState(
                key: RecommendationsScreen.unavailableKey,
                message: state.errorMessage!,
                detail: 'Your wardrobe and saved outfits still work without suggestions.',
                retryKey: RecommendationsScreen.retryButtonKey,
                onRetry: () => ref
                    .read(
                      recommendationsControllerProvider(wardrobeId).notifier,
                    )
                    .refresh(),
              )
            else if (state.isEmpty)
              const AppEmptyState(
                key: RecommendationsScreen.emptyStateKey,
                icon: Icons.auto_awesome_outlined,
                title: 'No suggestions yet',
                message:
                    'Add more items to this wardrobe, then pull to refresh.',
              )
            else ...[
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              for (var i = 0; i < state.recommendations.length; i++)
                _RecommendationTile(
                  wardrobeId: wardrobeId,
                  index: i,
                  recommendation: state.recommendations[i],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  const _RecommendationTile({
    required this.wardrobeId,
    required this.index,
    required this.recommendation,
  });

  final String wardrobeId;
  final int index;
  final Recommendation recommendation;

  @override
  Widget build(BuildContext context) {
    final slotCount = recommendation.items.length;
    return Card(
      child: ListTile(
        key: Key('recommendation_tile_$index'),
        leading: const CircleAvatar(child: Icon(Icons.auto_awesome_outlined)),
        title: Text(recommendation.name),
        subtitle: Text(slotCount == 1 ? '1 item' : '$slotCount items'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            context.push(AppRoutes.recommendationDetail(wardrobeId, index)),
      ),
    );
  }
}
