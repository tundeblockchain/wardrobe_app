import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/widgets/type_to_confirm_dialog.dart';
import '../../account/application/account_controller.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/app_user.dart';
import '../application/rate_app_controller.dart';

/// Account info plus Rate / Contact us / Report a bug / destructive wipes.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const screenKey = Key('profile_screen');
  static const themeToggleKey = Key('profile_theme_toggle');
  static const rateTileKey = Key('profile_rate_app');
  static const aiTryOnTileKey = Key('profile_ai_try_on');
  static const contactTileKey = Key('profile_contact_us');
  static const reportBugTileKey = Key('profile_report_bug');
  static const signOutButtonKey = Key('profile_sign_out');
  static const clearContentButtonKey = Key('account_clear_content');
  static const deleteAccountButtonKey = Key('account_delete_account');
  static const errorTextKey = Key('account_error');
  static const infoTextKey = Key('account_info');

  static const clearPhrase = 'CLEAR';
  static const deletePhrase = 'DELETE';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final rate = ref.watch(rateAppControllerProvider);
    final account = ref.watch(accountControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final user = auth.user;
    final busy = auth.isBusy || account.isBusy || rate.isBusy;
    final isDark = themeModeIsDark(
      themeMode,
      MediaQuery.platformBrightnessOf(context),
    );

    ref.listen(accountControllerProvider, (previous, next) {
      if (next.isAccountDeleted && context.mounted) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _AccountCard(user: user),
          const SizedBox(height: 24),
          SwitchListTile(
            key: themeToggleKey,
            contentPadding: EdgeInsets.zero,
            secondary: Icon(
              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            ),
            title: const Text('Dark theme'),
            subtitle: const Text('Burgundy and plum in light and dark'),
            value: isDark,
            onChanged: (dark) {
              ref.read(themeControllerProvider.notifier).setDark(dark);
            },
          ),
          ListTile(
            key: aiTryOnTileKey,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.checkroom_outlined),
            title: const Text('AI try-on'),
            subtitle: const Text('Your photos and model looks'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.aiTryOn),
          ),
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
          Text('Danger zone', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'These actions cannot be undone.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (account.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              account.errorMessage!,
              key: errorTextKey,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          if (account.infoMessage != null) ...[
            const SizedBox(height: 12),
            Text(account.infoMessage!, key: infoTextKey),
          ],
          if (account.isBusy) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          ListTile(
            key: clearContentButtonKey,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Clear all content'),
            subtitle: const Text(
              'Delete every wardrobe, item, and outfit. Stay signed in.',
            ),
            enabled: !busy,
            onTap: busy ? null : () => _clearContent(context, ref),
          ),
          ListTile(
            key: deleteAccountButtonKey,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.person_off_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Delete account',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: const Text(
              'Permanently delete your data and sign-in. You will need to '
              'create a new account to use Wardrobe again.',
            ),
            enabled: !busy,
            onTap: busy ? null : () => _deleteAccount(context, ref),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            key: signOutButtonKey,
            onPressed: busy
                ? null
                : () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearContent(BuildContext context, WidgetRef ref) async {
    final confirmed = await TypeToConfirmDialog.show(
      context,
      title: 'Clear all content?',
      message:
          'This permanently deletes every wardrobe, clothing item, outfit, '
          'and photo. Your sign-in stays active so you can start over.',
      phrase: clearPhrase,
      confirmLabel: 'Clear all',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(accountControllerProvider.notifier).clearContent();
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final confirmed = await TypeToConfirmDialog.show(
      context,
      title: 'Delete your account?',
      message:
          'This permanently deletes every wardrobe, item, outfit, and photo, '
          'then removes your sign-in. This cannot be undone.',
      phrase: deletePhrase,
      confirmLabel: 'Delete account',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(accountControllerProvider.notifier).deleteAccount();
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
