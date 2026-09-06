import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../application/auth_controller.dart';
import '../domain/auth_validators.dart';
import '../../../core/widgets/app_empty_state.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/google_sign_in_button.dart';

/// Email/password registration with optional Google sign-in.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  static const emailFieldKey = Key('signup_email');
  static const passwordFieldKey = Key('signup_password');
  static const confirmPasswordFieldKey = Key('signup_confirm_password');
  static const submitButtonKey = Key('signup_submit');
  static const googleButtonKey = Key('signup_google');

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _googleBusy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(authControllerProvider.notifier)
        .signUp(
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
      title: 'Create account',
      subtitle: 'Use email and password, or continue with Google.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              key: SignupScreen.emailFieldKey,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              decoration: const InputDecoration(labelText: 'Email'),
              validator: AuthValidators.email,
              enabled: !auth.isBusy,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: SignupScreen.passwordFieldKey,
              controller: _passwordController,
              obscureText: true,
              autofillHints: const [AutofillHints.newPassword],
              decoration: const InputDecoration(labelText: 'Password'),
              validator: AuthValidators.password,
              enabled: !auth.isBusy,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: SignupScreen.confirmPasswordFieldKey,
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm password'),
              validator: (value) => AuthValidators.confirmPassword(
                value,
                _passwordController.text,
              ),
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
              key: SignupScreen.submitButtonKey,
              onPressed: auth.isBusy ? null : _submit,
              child: auth.isBusy && !_googleBusy
                  ? const AppButtonSpinner()
                  : const Text('Sign up'),
            ),
            const AuthOrDivider(),
            GoogleSignInButton(
              key: SignupScreen.googleButtonKey,
              onPressed: _signInWithGoogle,
              enabled: !auth.isBusy,
              busy: _googleBusy,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: auth.isBusy ? null : () => context.go(AppRoutes.login),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
