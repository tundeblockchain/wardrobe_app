import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/item.dart';
import '../../domain/item_swipe.dart';
import 'item_swipe_card.dart';

/// Tinder-style stack of wardrobe items. Swipe right (or Next) for the next item.
class ItemSwipeDeck extends StatefulWidget {
  const ItemSwipeDeck({
    super.key,
    required this.items,
    required this.onOpenItem,
    this.onDeleteItem,
  });

  final List<Item> items;
  final ValueChanged<Item> onOpenItem;
  final ValueChanged<Item>? onDeleteItem;

  static const deckKey = Key('item_swipe_deck');
  static const endKey = Key('item_swipe_end');
  static const resetButtonKey = Key('item_swipe_reset');
  static const nextButtonKey = Key('item_swipe_next');
  static const openButtonKey = Key('item_swipe_open');
  static const removeButtonKey = Key('item_swipe_remove');
  static const counterKey = Key('item_swipe_counter');
  static const swipeHintKey = Key('item_swipe_hint');
  static const swipeLayerKey = Key('item_swipe_layer');
  static const swipeHintText = 'Swipe right for the next item';

  @override
  State<ItemSwipeDeck> createState() => _ItemSwipeDeckState();
}

class _ItemSwipeDeckState extends State<ItemSwipeDeck>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 220);

  int _index = 0;
  Offset _drag = Offset.zero;
  late final AnimationController _controller;
  Animation<Offset>? _dragAnimation;
  bool _advancing = false;

  List<Item> get _items => widget.items;

  bool get _atEnd => _items.isEmpty || _index >= _items.length;

  bool get _swipeEnabled => itemBrowseSwipeEnabled(_items.length);

  Item? get _current => _atEnd ? null : _items[_index];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller.addListener(_onAnimationTick);
    _controller.addStatusListener(_onAnimationStatus);
  }

  @override
  void didUpdateWidget(ItemSwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previousIds = [for (final item in oldWidget.items) item.id];
    final nextIds = [for (final item in widget.items) item.id];
    if (!_listEquals(previousIds, nextIds)) {
      final currentId = _index < oldWidget.items.length
          ? oldWidget.items[_index].id
          : null;
      final nextIndex = currentId == null ? 0 : nextIds.indexOf(currentId);
      _controller.stop();
      _dragAnimation = null;
      _advancing = false;
      _drag = Offset.zero;
      if (nextIds.isEmpty) {
        _index = 0;
      } else if (nextIndex >= 0) {
        _index = nextIndex;
      } else {
        _index = _index.clamp(0, nextIds.length - 1);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onAnimationTick);
    _controller.removeStatusListener(_onAnimationStatus);
    _controller.dispose();
    super.dispose();
  }

  void _onAnimationTick() {
    final animation = _dragAnimation;
    if (animation == null) {
      return;
    }
    setState(() => _drag = animation.value);
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    final shouldAdvance = _advancing;
    _dragAnimation = null;
    _advancing = false;
    _controller.reset();
    if (!mounted) {
      return;
    }
    setState(() {
      _drag = Offset.zero;
      if (shouldAdvance && _index < _items.length) {
        _index += 1;
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_swipeEnabled || _atEnd || _controller.isAnimating) {
      return;
    }
    final nextDx = (_drag.dx + details.delta.dx).clamp(0.0, double.infinity);
    setState(() => _drag = Offset(nextDx, 0));
  }

  void _onPanEnd(DragEndDetails details, Size size) {
    if (!_swipeEnabled || _atEnd || _controller.isAnimating) {
      return;
    }
    final direction = resolveItemSwipe(
      dx: _drag.dx,
      dy: _drag.dy,
      vx: details.velocity.pixelsPerSecond.dx,
      vy: details.velocity.pixelsPerSecond.dy,
      width: size.width,
      height: size.height,
    );
    if (direction == null) {
      _animateTo(Offset.zero, advance: false);
      return;
    }
    final exit = itemSwipeExitOffset(
      direction: direction,
      width: size.width,
      height: size.height,
      currentDx: _drag.dx,
      currentDy: _drag.dy,
    );
    _animateTo(Offset(exit.dx, exit.dy), advance: true);
  }

  void _animateTo(Offset target, {required bool advance}) {
    _advancing = advance;
    _dragAnimation = Tween<Offset>(
      begin: _drag,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward(from: 0);
  }

  void _advance() {
    if (!_swipeEnabled || _atEnd || _controller.isAnimating) {
      return;
    }
    final size = context.size ?? const Size(320, 420);
    final exit = itemSwipeExitOffset(
      direction: ItemSwipeDirection.right,
      width: size.width,
      height: size.height,
      currentDx: 0,
      currentDy: 0,
    );
    _animateTo(Offset(exit.dx, exit.dy), advance: true);
  }

  void _reset() {
    _controller.stop();
    _dragAnimation = null;
    _advancing = false;
    setState(() {
      _index = 0;
      _drag = Offset.zero;
    });
  }

  void _openCurrent() {
    final item = _current;
    if (item == null) {
      return;
    }
    widget.onOpenItem(item);
  }

  void _deleteCurrent() {
    final item = _current;
    final onDelete = widget.onDeleteItem;
    if (item == null || onDelete == null) {
      return;
    }
    onDelete(item);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ItemSwipeDeck.deckKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: _atEnd ? _EndOfStack(onReset: _reset) : _buildStack(context),
        ),
        const SizedBox(height: AppSpacing.md),
        if (!_atEnd) ...[
          Text(
            key: ItemSwipeDeck.counterKey,
            '${_index + 1} of ${_items.length}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (_swipeEnabled) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              key: ItemSwipeDeck.swipeHintKey,
              ItemSwipeDeck.swipeHintText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          if (_swipeEnabled)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: ItemSwipeDeck.nextButtonKey,
                    onPressed: _advance,
                    child: const Text('Next item'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    key: ItemSwipeDeck.openButtonKey,
                    onPressed: _openCurrent,
                    child: const Text('View details'),
                  ),
                ),
              ],
            )
          else
            FilledButton(
              key: ItemSwipeDeck.openButtonKey,
              onPressed: _openCurrent,
              child: const Text('View details'),
            ),
          if (widget.onDeleteItem != null) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              key: ItemSwipeDeck.removeButtonKey,
              onPressed: _deleteCurrent,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Remove item'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildStack(BuildContext context) {
    if (!_swipeEnabled) {
      return ItemSwipeCard(
        item: _items[_index],
        onTap: _openCurrent,
        onDelete: widget.onDeleteItem == null ? null : _deleteCurrent,
      );
    }

    final remaining = _items.length - _index;
    final backCount = remaining > 3 ? 2 : remaining - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return RawGestureDetector(
          key: ItemSwipeDeck.swipeLayerKey,
          gestures: {
            _RightSwipeGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  _RightSwipeGestureRecognizer
                >(_RightSwipeGestureRecognizer.new, (instance) {
                  instance
                    ..onUpdate = _onPanUpdate
                    ..onEnd = (details) => _onPanEnd(details, size);
                }),
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              for (var depth = backCount; depth >= 1; depth--)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Transform.translate(
                      offset: Offset(0, depth * 10.0),
                      child: Transform.scale(
                        scale: 1 - (depth * 0.04),
                        alignment: Alignment.bottomCenter,
                        child: ItemSwipeCard(
                          item: _items[_index + depth],
                          enabled: false,
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned.fill(
                child: Transform.translate(
                  offset: _drag,
                  child: Transform.rotate(
                    angle: (_drag.dx / 420).clamp(-0.28, 0.28),
                    child: ItemSwipeCard(
                      item: _items[_index],
                      onTap: _openCurrent,
                      onDelete: widget.onDeleteItem == null
                          ? null
                          : _deleteCurrent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EndOfStack extends StatelessWidget {
  const _EndOfStack({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ItemSwipeDeck.endKey,
      margin: EdgeInsets.zero,
      child: AppEmptyState(
        icon: Icons.style_outlined,
        title: 'No more items',
        message: 'You have seen every item in this list.',
        actionLabel: 'Browse again',
        actionKey: ItemSwipeDeck.resetButtonKey,
        onAction: onReset,
      ),
    );
  }
}

/// Horizontal recognizer that yields vertical movement to a parent [ListView].
///
/// Unlike a pan that eagerly accepts every pointer, this only claims a
/// primarily-horizontal drag so a scroll cannot flip or advance the card.
class _RightSwipeGestureRecognizer extends HorizontalDragGestureRecognizer {}

bool _listEquals(List<String> a, List<String> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
