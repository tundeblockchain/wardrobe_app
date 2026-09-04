import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';

/// Authenticated home placeholder. Wardrobe CRUD lands in later tickets.
class WardrobesStubScreen extends ConsumerWidget {
  const WardrobesStubScreen({super.key});

  static const signOutButtonKey = Key('wardrobes_sign_out');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).user;
    final email = user?.email ?? 'signed in';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobes'),
        actions: [
          TextButton(
            key: signOutButtonKey,
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Signed in as $email'),
              const SizedBox(height: 16),
              Text(
                'Wardrobes coming soon',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
