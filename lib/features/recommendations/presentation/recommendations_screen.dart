import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
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
          padding: const EdgeInsets.all(24),
          children: [
            if (state.isLoading && state.recommendations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.isUnavailable)
              _ErrorBody(
                message: state.errorMessage!,
                onRetry: () => ref
                    .read(
                      recommendationsControllerProvider(wardrobeId).notifier,
                    )
                    .refresh(),
              )
            else if (state.isEmpty)
              const _EmptyBody()
            else ...[
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
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

class _EmptyBody extends StatelessWidget {
  const _EmptyBody();

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: RecommendationsScreen.emptyStateKey,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            'No suggestions yet',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Add more items to this wardrobe, then pull to refresh.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: RecommendationsScreen.unavailableKey,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your wardrobe and saved outfits still work without suggestions.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: RecommendationsScreen.retryButtonKey,
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
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
