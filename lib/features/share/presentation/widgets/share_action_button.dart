import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_motion.dart';
import '../../application/share_controller.dart';

/// App-bar share CTA. Burgundy/plum via [ColorScheme]; motion via [AppMotion].
class ShareActionButton extends ConsumerWidget {
  const ShareActionButton({
    super.key,
    required this.onShare,
    this.enabled = true,
    this.tooltip = 'Share',
  });

  final Future<void> Function(Rect? origin) onShare;
  final bool enabled;
  final String tooltip;

  static const progressKey = Key('share_action_progress');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharing = ref.watch(shareControllerProvider).isSharing;
    final scheme = Theme.of(context).colorScheme;

    ref.listen(shareControllerProvider, (previous, next) {
      final snack = next.snackMessage;
      if (snack != null && snack != previous?.snackMessage && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(snack)));
        ref.read(shareControllerProvider.notifier).clearSnackMessage();
      }
    });

    final reduced = AppMotion.reduce(context);
    return IconButton(
      tooltip: tooltip,
      onPressed: !enabled || sharing ? null : () => onShare(_origin(context)),
      icon: AnimatedSwitcher(
        duration: reduced ? Duration.zero : AppMotion.fadeDuration,
        switchInCurve: AppMotion.fadeCurve,
        switchOutCurve: AppMotion.fadeCurve,
        child: sharing
            ? SizedBox(
                key: progressKey,
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: scheme.onPrimary,
                ),
              )
            : const Icon(Icons.ios_share_outlined),
      ),
    );
  }

  Rect? _origin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.isEmpty) {
      return const Rect.fromLTWH(0, 0, 1, 1);
    }
    return box.localToGlobal(Offset.zero) & box.size;
  }
}
