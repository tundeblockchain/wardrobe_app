import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/auth_controller.dart';
import '../domain/auth_validators.dart';
import '../../../core/widgets/app_empty_state.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/google_sign_in_button.dart';

/// Email/password and Google sign-in.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const emailFieldKey = Key('login_email');
  static const passwordFieldKey = Key('login_password');
  static const submitButtonKey = Key('login_submit');
  static const googleButtonKey = Key('login_google');

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _googleBusy = false;

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

  Future<void> _signInWithGoogle() async {
    setState(() => _googleBusy = true);
    try {
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
    } finally {
      if (mounted) {
        setState(() => _googleBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return AuthScaffold(
      title: 'Sign in',
      subtitle: 'Use your email and password, or continue with Google.',
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
              decoration: const InputDecoration(labelText: 'Email'),
              validator: AuthValidators.email,
              enabled: !auth.isBusy,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: LoginScreen.passwordFieldKey,
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              decoration: const InputDecoration(labelText: 'Password'),
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
              child: auth.isBusy && !_googleBusy
                  ? const AppButtonSpinner()
                  : const Text('Sign in'),
            ),
            const AuthOrDivider(),
            GoogleSignInButton(
              key: LoginScreen.googleButtonKey,
              onPressed: _signInWithGoogle,
              enabled: !auth.isBusy,
              busy: _googleBusy,
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
