import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Shared Google / Gmail sign-in control for login and signup.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.enabled = true,
    this.busy = false,
  });

  final VoidCallback? onPressed;
  final bool enabled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled && !busy ? onPressed : null,
      child: busy
          ? AppButtonSpinner(color: Theme.of(context).colorScheme.primary)
          : const Text('Continue with Google'),
    );
  }
}

/// Horizontal rule with an "or" label between email/password and Google.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).dividerColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: color)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('or', style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Divider(color: color)),
        ],
      ),
    );
  }
}
