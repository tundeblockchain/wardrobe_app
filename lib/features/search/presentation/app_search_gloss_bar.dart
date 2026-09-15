import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_gloss.dart';
import '../application/app_search_providers.dart';
import '../domain/app_search.dart';
import 'app_search_results.dart';

/// [AppGlossBar] plus header search (WARDROBE-89).
///
/// Gloss / sheen stay on [AppGlossBar]. The results panel is omitted while
/// the query is empty or whitespace.
class AppSearchGlossBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  AppSearchGlossBar({
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

  static const searchButtonKey = Key('app_search_open');
  static const closeButtonKey = Key('app_search_close');
  static const fieldKey = Key('app_search_field');
  static const clearFieldKey = Key('app_search_clear');

  @override
  final Size preferredSize;

  @override
  ConsumerState<AppSearchGlossBar> createState() => _AppSearchGlossBarState();
}

class _AppSearchGlossBarState extends ConsumerState<AppSearchGlossBar> {
  final _overlay = OverlayPortalController();
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _open = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openSearch() {
    setState(() => _open = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNode.requestFocus();
      }
    });
  }

  void _closeSearch() {
    _controller.clear();
    ref.read(appSearchQueryProvider.notifier).clear();
    if (_overlay.isShowing) {
      _overlay.hide();
    }
    if (_open) {
      setState(() => _open = false);
    }
  }

  void _onQueryChanged(String value) {
    ref.read(appSearchQueryProvider.notifier).setQuery(value);
    final showPanel = !isAppSearchQueryEmpty(value);
    if (showPanel && !_overlay.isShowing) {
      _overlay.show();
    } else if (!showPanel && _overlay.isShowing) {
      _overlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlay,
      overlayChildBuilder: _buildOverlay,
      child: AppGlossBar(
        leading: widget.leading,
        automaticallyImplyLeading: widget.automaticallyImplyLeading,
        title: _open
            ? _SearchField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onQueryChanged,
                onClear: () => _onQueryChanged(''),
              )
            : widget.title,
        actions: [
          if (_open)
            IconButton(
              key: AppSearchGlossBar.closeButtonKey,
              tooltip: 'Close search',
              onPressed: _closeSearch,
              icon: const Icon(Icons.close),
            )
          else
            IconButton(
              key: AppSearchGlossBar.searchButtonKey,
              tooltip: 'Search',
              onPressed: _openSearch,
              icon: const Icon(Icons.search),
            ),
          if (!_open) ...?widget.actions,
        ],
        bottom: widget.bottom,
        toolbarHeight: widget.toolbarHeight,
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + widget.preferredSize.height;
    return Stack(
      children: [
        Positioned(
          top: top,
          left: 0,
          right: 0,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _closeSearch,
            child: const SizedBox.expand(),
          ),
        ),
        Positioned(
          top: top + AppSpacing.xs,
          left: AppSpacing.sm,
          right: AppSpacing.sm,
          child: AppSearchResultsPanel(onClose: _closeSearch),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final onHeader = AppTheme.headerForeground(Theme.of(context).colorScheme);
    final hint = onHeader.withValues(alpha: 0.72);
    return TextField(
      key: AppSearchGlossBar.fieldKey,
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: onHeader),
      cursorColor: onHeader,
      textInputAction: TextInputAction.search,
      autocorrect: false,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search items, outfits, wardrobes',
        hintStyle: Theme.of(context).textTheme.titleMedium
            ?.copyWith(color: hint),
        filled: true,
        fillColor: onHeader.withValues(alpha: 0.14),
        prefixIcon: Icon(Icons.search, color: onHeader, size: 22),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 36,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              key: AppSearchGlossBar.clearFieldKey,
              tooltip: 'Clear',
              onPressed: () {
                controller.clear();
                onClear();
              },
              icon: Icon(Icons.cancel, color: onHeader, size: 20),
            );
          },
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 8,
        ),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.input,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.input,
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.input,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
