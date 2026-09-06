import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/app_user.dart';
import '../application/rate_app_controller.dart';

/// Account info plus Rate / Contact us / Report a bug.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const screenKey = Key('profile_screen');
  static const rateTileKey = Key('profile_rate_app');
  static const contactTileKey = Key('profile_contact_us');
  static const reportBugTileKey = Key('profile_report_bug');
  static const signOutButtonKey = Key('profile_sign_out');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final rate = ref.watch(rateAppControllerProvider);
    final user = auth.user;

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _AccountCard(user: user),
          const SizedBox(height: 24),
          ListTile(
            key: rateTileKey,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.star_outline),
            title: const Text('Rate the app'),
            subtitle: const Text('Leave a review on the store'),
            trailing: rate.isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.chevron_right),
            onTap: rate.isBusy
                ? null
                : () => ref.read(rateAppControllerProvider.notifier).rate(),
          ),
          ListTile(
            key: contactTileKey,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.mail_outline),
            title: const Text('Contact us'),
            subtitle: const Text('Send a message to the team'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.contactUs),
          ),
          ListTile(
            key: reportBugTileKey,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.bug_report_outlined),
            title: const Text('Report a bug'),
            subtitle: const Text('Tell us what went wrong'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.reportBug),
          ),
          if (rate.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              rate.errorMessage!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 32),
          OutlinedButton(
            key: signOutButtonKey,
            onPressed: auth.isBusy
                ? null
                : () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.user});

  final AppUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = user?.displayName?.trim();
    final email = user?.email?.trim();
    final provider = user?.providerLabel;
    final initialSource = (name != null && name.isNotEmpty)
        ? name
        : (email != null && email.isNotEmpty ? email : '?');
    final initial = initialSource[0].toUpperCase();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(child: Text(initial)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (name != null && name.isNotEmpty) ? name : 'Your account',
                    style: theme.textTheme.titleMedium,
                  ),
                  if (email != null && email.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(email, style: theme.textTheme.bodyMedium),
                  ],
                  if (provider != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Signed in with $provider',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
