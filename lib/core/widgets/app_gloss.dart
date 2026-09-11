import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import 'app_sheen.dart';

/// Gloss intensity for burgundy / plum surfaces.
enum AppGlossTone { surface, header, button }

/// Non-interactive diagonal shine. Safe to stack on cards, buttons, headers.
class AppGlossOverlay extends StatelessWidget {
  const AppGlossOverlay({super.key, this.tone = AppGlossTone.surface});

  static const overlayKey = Key('app_gloss_overlay');

  final AppGlossTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final highlight = switch (tone) {
      AppGlossTone.surface =>
        isDark ? AppMotion.glossHighlightDark : AppMotion.glossHighlightLight,
      AppGlossTone.header =>
        isDark
            ? AppMotion.headerGlossHighlightDark
            : AppMotion.headerGlossHighlightLight,
      AppGlossTone.button =>
        isDark
            ? AppMotion.buttonGlossHighlightDark
            : AppMotion.buttonGlossHighlightLight,
    };
    final tail = isDark ? AppMotion.glossTailDark : AppMotion.glossTailLight;
    return IgnorePointer(
      child: DecoratedBox(
        key: overlayKey,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: highlight),
              Colors.white.withValues(alpha: isDark ? 0.03 : 0.0),
              scheme.secondary.withValues(alpha: tail),
            ],
            stops: const [0.0, 0.46, 1.0],
          ),
        ),
      ),
    );
  }
}

/// Stacks [child] under a clipped gloss overlay (and optional one-shot sheen).
class AppGloss extends StatelessWidget {
  const AppGloss({
    super.key,
    required this.child,
    this.tone = AppGlossTone.surface,
    this.sheen = false,
    this.borderRadius,
  });

  final Widget child;
  final AppGlossTone tone;
  final bool sheen;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final content = Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(child: AppGlossOverlay(tone: tone)),
        if (sheen) const Positioned.fill(child: AppSheenSweep()),
      ],
    );
    final radius = borderRadius;
    if (radius == null) {
      return content;
    }
    return ClipRRect(borderRadius: radius, child: content);
  }

  /// Theme hook for [FilledButton] backgrounds.
  static Widget buttonBackground(
    BuildContext context,
    Set<WidgetState> states,
    Widget? child,
  ) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        ?child,
        const Positioned.fill(
          child: AppGlossOverlay(tone: AppGlossTone.button),
        ),
      ],
    );
  }
}

/// AppBar with the shared header gloss behind toolbar content.
class AppGlossBar extends StatelessWidget implements PreferredSizeWidget {
  AppGlossBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.bottom,
    this.toolbarHeight,
  }) : preferredSize = Size.fromHeight(
         (toolbarHeight ?? kToolbarHeight) +
             (bottom?.preferredSize.height ?? 0),
       );

  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      bottom: bottom,
      toolbarHeight: toolbarHeight,
      flexibleSpace: const _AppBarGloss(),
    );
  }
}

class _AppBarGloss extends StatelessWidget {
  const _AppBarGloss();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        AppGlossOverlay(tone: AppGlossTone.header),
        AppSheenSweep(),
      ],
    );
  }
}
