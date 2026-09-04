import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/auth_controller.dart';
import '../domain/auth_validators.dart';
import 'widgets/auth_scaffold.dart';

/// Email/password sign-in.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const emailFieldKey = Key('login_email');
  static const passwordFieldKey = Key('login_password');
  static const submitButtonKey = Key('login_submit');

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Sign in',
      subtitle: 'Use your email and password.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: LoginScreen.emailFieldKey,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: AuthValidators.email,
              enabled: !auth.isBusy,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: LoginScreen.passwordFieldKey,
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: AuthValidators.password,
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
            const SizedBox(height: 24),
            FilledButton(
              key: LoginScreen.submitButtonKey,
              onPressed: auth.isBusy ? null : _submit,
              child: auth.isBusy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign in'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: auth.isBusy
                  ? null
                  : () => context.go(AppRoutes.signup),
              child: const Text('Create an account'),
            ),
            TextButton(
              onPressed: auth.isBusy
                  ? null
                  : () => context.go(AppRoutes.forgotPassword),
              child: const Text('Forgot password?'),
            ),
          ],
        ),
      ),
    );
  }
}
