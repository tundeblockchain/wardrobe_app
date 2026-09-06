import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/widgets/type_to_confirm_dialog.dart';
import '../../auth/application/auth_controller.dart';
import '../application/account_controller.dart';

/// Account danger-zone: clear all content and delete the Firebase account.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  static const clearContentButtonKey = Key('account_clear_content');
  static const deleteAccountButtonKey = Key('account_delete_account');
  static const errorTextKey = Key('account_error');
  static const infoTextKey = Key('account_info');

  static const clearPhrase = 'CLEAR';
  static const deletePhrase = 'DELETE';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final state = ref.watch(accountControllerProvider);
    final email = auth.user?.email ?? 'signed in';

    ref.listen(accountControllerProvider, (previous, next) {
      if (next.isAccountDeleted && context.mounted) {
        context.go(AppRoutes.login);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Signed in as $email'),
            const SizedBox(height: 8),
            Text(
              'These actions cannot be undone.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (state.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                state.errorMessage!,
                key: errorTextKey,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (state.infoMessage != null) ...[
              const SizedBox(height: 16),
              Text(state.infoMessage!, key: infoTextKey),
            ],
            if (state.isBusy) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
            const SizedBox(height: 32),
            Text('Danger zone', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ListTile(
              key: clearContentButtonKey,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_sweep_outlined),
              title: const Text('Clear all content'),
              subtitle: const Text(
                'Delete every wardrobe, item, and outfit. Stay signed in.',
              ),
              enabled: !state.isBusy,
              onTap: () => _clearContent(context, ref),
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
              enabled: !state.isBusy,
              onTap: () => _deleteAccount(context, ref),
            ),
          ],
        ),
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
