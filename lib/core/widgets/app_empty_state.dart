import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Themed empty-list placeholder used across wardrobe, item, outfit, and
/// suggestion screens.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primaryContainer,
            ),
            child: Icon(icon, size: 36, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              key: actionKey,
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

/// Themed error / retry block that stays on-scheme.
class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.detail,
    this.retryKey,
  });

  final String message;
  final String? detail;
  final VoidCallback onRetry;
  final Key? retryKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.errorContainer,
            ),
            child: Icon(
              Icons.error_outline,
              size: 36,
              color: scheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: theme.textTheme.titleMedium?.copyWith(color: scheme.error),
            textAlign: TextAlign.center,
          ),
          if (detail != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              detail!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            key: retryKey,
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Compact spinner for [FilledButton] children (uses [ColorScheme.onPrimary]).
class AppButtonSpinner extends StatelessWidget {
  const AppButtonSpinner({super.key, this.color});

  /// Defaults to [ColorScheme.onPrimary] so the indicator stays visible on
  /// filled burgundy / plum buttons.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color ?? Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
