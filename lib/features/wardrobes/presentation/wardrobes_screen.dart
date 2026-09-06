import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/application/auth_controller.dart';
import '../application/wardrobes_controller.dart';
import '../domain/wardrobe.dart';

/// Authenticated wardrobe list with empty state and create navigation.
class WardrobesScreen extends ConsumerWidget {
  const WardrobesScreen({super.key});

  static const signOutButtonKey = Key('wardrobes_sign_out');
  static const profileButtonKey = Key('wardrobes_profile');
  static const createButtonKey = Key('wardrobes_create');
  static const emptyStateKey = Key('wardrobes_empty');
  static const retryButtonKey = Key('wardrobes_retry');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final state = ref.watch(wardrobesControllerProvider);
    final email = auth.user?.email ?? 'signed in';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobes'),
        actions: [
          IconButton(
            key: profileButtonKey,
            tooltip: 'Account',
            onPressed: () => context.push(AppRoutes.profile),
            icon: const Icon(Icons.account_circle_outlined),
          ),
          TextButton(
            key: signOutButtonKey,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: createButtonKey,
        onPressed: () => context.push(AppRoutes.createWardrobe),
        tooltip: 'Create wardrobe',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(wardrobesControllerProvider.notifier).refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            Text('Signed in as $email'),
            const SizedBox(height: 16),
            if (state.isLoading && state.wardrobes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.errorMessage != null && state.wardrobes.isEmpty)
              _ErrorBody(
                message: state.errorMessage!,
                onRetry: () =>
                    ref.read(wardrobesControllerProvider.notifier).refresh(),
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
              for (final wardrobe in state.wardrobes)
                _WardrobeTile(wardrobe: wardrobe),
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
      key: WardrobesScreen.emptyStateKey,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Text(
            'No wardrobes yet',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a wardrobe to get started.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.push(AppRoutes.createWardrobe),
            child: const Text('Create wardrobe'),
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
            key: WardrobesScreen.retryButtonKey,
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _WardrobeTile extends StatelessWidget {
  const _WardrobeTile({required this.wardrobe});

  final Wardrobe wardrobe;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        key: Key('wardrobe_tile_${wardrobe.id}'),
        title: Text(wardrobe.name),
        subtitle: Text('Created ${_formatDate(wardrobe.createdAt)}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.wardrobeDetail(wardrobe.id)),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final year = local.year.toString().padLeft(4, '0');
  final month = local.month.toString().padLeft(2, '0');
  final day = local.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
