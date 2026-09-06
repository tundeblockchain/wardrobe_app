import 'package:flutter/material.dart';

import '../../../../core/widgets/app_empty_state.dart';

/// Shared Sign in with Apple control for login and signup (iOS only).
class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({
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
          : const Text('Continue with Apple'),
    );
  }
}
