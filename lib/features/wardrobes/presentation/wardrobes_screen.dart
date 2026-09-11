import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/wardrobe_cover_provider.dart';
import '../application/wardrobe_items_provider.dart';
import '../application/wardrobes_controller.dart';
import 'widgets/home_clothing_carousel.dart';
import 'widgets/wardrobe_list_card.dart';

/// Authenticated wardrobe card list with empty state and create navigation.
class WardrobesScreen extends ConsumerStatefulWidget {
  const WardrobesScreen({super.key});

  static const profileButtonKey = Key('wardrobes_profile');
  static const createButtonKey = Key('wardrobes_create');
  static const emptyStateKey = Key('wardrobes_empty');
  static const retryButtonKey = Key('wardrobes_retry');
  static const titleKey = Key('wardrobes_title');
  static const listHeadingKey = Key('wardrobes_list_heading');

  @override
  ConsumerState<WardrobesScreen> createState() => _WardrobesScreenState();
}

class _WardrobesScreenState extends ConsumerState<WardrobesScreen>
    with RouteAware {
  RouteObserver<ModalRoute<void>>? _observer;

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
    _refreshCovers();
  }

  Future<void> _refreshList() async {
    await ref.read(wardrobesControllerProvider.notifier).refresh();
    _refreshCovers();
  }

  void _refreshCovers() {
    for (final wardrobe in ref.read(wardrobesControllerProvider).wardrobes) {
      ref.invalidate(wardrobeItemsProvider(wardrobe.id));
      ref.invalidate(wardrobeCoverProvider(wardrobe.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(wardrobesControllerProvider);
    final clothingItems = ref.watch(homeClothingItemsProvider);
    final autoScroll = ref.watch(homeClothingCarouselAutoScrollProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobes', key: WardrobesScreen.titleKey),
        actions: [
          IconButton(
            key: WardrobesScreen.profileButtonKey,
            tooltip: 'Account',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: WardrobesScreen.createButtonKey,
        onPressed: () => context.push(AppRoutes.createWardrobe),
        tooltip: 'Create wardrobe',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshList,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSpacing.pageInsets,
          children: [
            if (state.isLoading && state.wardrobes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.wardrobes.isEmpty)
              AppErrorState(
                message: state.errorMessage!,
                retryKey: WardrobesScreen.retryButtonKey,
                onRetry: _refreshList,
              )
            else if (state.isEmpty)
              AppEmptyState(
                key: WardrobesScreen.emptyStateKey,
                icon: Icons.checkroom_outlined,
                title: 'No wardrobes yet',
                message: 'Create a wardrobe to get started.',
                actionLabel: 'Create wardrobe',
                onAction: () => context.push(AppRoutes.createWardrobe),
              )
            else ...[
              if (clothingItems.isNotEmpty) ...[
                HomeClothingCarousel(
                  items: clothingItems,
                  autoScroll: autoScroll,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              Text(
                'Wardrobes',
                key: WardrobesScreen.listHeadingKey,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
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
              for (final wardrobe in state.wardrobes)
                WardrobeListCard(wardrobe: wardrobe),
            ],
          ],
        ),
      ),
    );
  }
}
