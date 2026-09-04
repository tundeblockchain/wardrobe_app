import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/outfits_controller.dart';
import '../domain/outfit.dart';

/// Saved outfits for one wardrobe.
class OutfitsScreen extends ConsumerWidget {
  const OutfitsScreen({super.key, required this.wardrobeId});

  final String wardrobeId;

  static const createButtonKey = Key('outfits_create');
  static const emptyStateKey = Key('outfits_empty');
  static const retryButtonKey = Key('outfits_retry');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outfitsControllerProvider(wardrobeId));

    return Scaffold(
      appBar: AppBar(title: const Text('Outfits')),
      floatingActionButton: FloatingActionButton(
        key: createButtonKey,
        tooltip: 'Create outfit',
        onPressed: () => context.push(AppRoutes.createOutfit(wardrobeId)),
        child: const Icon(Icons.checkroom_outlined),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(outfitsControllerProvider(wardrobeId).notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            if (state.isLoading && state.outfits.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.outfits.isEmpty)
              _ErrorBody(
                message: state.errorMessage!,
                onRetry: () => ref
                    .read(outfitsControllerProvider(wardrobeId).notifier)
                    .refresh(),
              )
            else if (state.isEmpty)
              _EmptyBody(wardrobeId: wardrobeId)
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
              for (final outfit in state.outfits)
                _OutfitTile(wardrobeId: wardrobeId, outfit: outfit),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyBody extends StatelessWidget {
  const _EmptyBody({required this.wardrobeId});

  final String wardrobeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: OutfitsScreen.emptyStateKey,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            'No outfits yet',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Build a look from items in this wardrobe.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.push(AppRoutes.createOutfit(wardrobeId)),
            child: const Text('Create outfit'),
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
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton(
            key: OutfitsScreen.retryButtonKey,
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _OutfitTile extends StatelessWidget {
  const _OutfitTile({required this.wardrobeId, required this.outfit});

  final String wardrobeId;
  final Outfit outfit;

  @override
  Widget build(BuildContext context) {
    final slotCount = outfit.items.length;
    return Card(
      child: ListTile(
        key: Key('outfit_tile_${outfit.id}'),
        leading: const CircleAvatar(child: Icon(Icons.checkroom_outlined)),
        title: Text(outfit.name),
        subtitle: Text(slotCount == 1 ? '1 item' : '$slotCount items'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            context.push(AppRoutes.outfitDetail(wardrobeId, outfit.id)),
      ),
    );
  }
}
