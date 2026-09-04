import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/auth_controller.dart';
import '../domain/auth_validators.dart';
import 'widgets/auth_scaffold.dart';

/// Sends a Firebase password-reset email.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const emailFieldKey = Key('forgot_password_email');
  static const submitButtonKey = Key('forgot_password_submit');

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .sendPasswordResetEmail(email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Reset password',
      subtitle: 'We will email you a reset link.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: ForgotPasswordScreen.emailFieldKey,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: AuthValidators.email,
              enabled: !auth.isBusy,
              onFieldSubmitted: (_) => _submit(),
            ),
            if (auth.errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                auth.errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (auth.infoMessage != null) ...[
              const SizedBox(height: 16),
              Text(auth.infoMessage!),
            ],
            const SizedBox(height: 24),
            FilledButton(
              key: ForgotPasswordScreen.submitButtonKey,
              onPressed: auth.isBusy ? null : _submit,
              child: auth.isBusy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Send reset email'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: auth.isBusy ? null : () => context.go(AppRoutes.login),
              child: const Text('Back to sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
