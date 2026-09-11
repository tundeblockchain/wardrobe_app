import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../items/domain/item.dart';
import '../../../items/presentation/widgets/item_browse_image.dart';

/// Horizontal auto-scrolling strip of clothing from every wardrobe.
///
/// Scrolls continuously until the user drags; dragging pauses, and motion
/// resumes shortly after the pointer is released.
class HomeClothingCarousel extends StatefulWidget {
  const HomeClothingCarousel({
    super.key,
    required this.items,
    this.autoScroll = true,
    this.pixelsPerSecond = 40,
  });

  final List<Item> items;
  final bool autoScroll;
  final double pixelsPerSecond;

  static const carouselKey = Key('home_clothing_carousel');

  static Key cardKey(String itemId) =>
      Key('home_clothing_carousel_card_$itemId');

  static const double cardWidth = 132;
  static const double photoHeight = 176;
  static const Duration resumeDelay = Duration(milliseconds: 800);

  @override
  State<HomeClothingCarousel> createState() => _HomeClothingCarouselState();
}

class _HomeClothingCarouselState extends State<HomeClothingCarousel>
    with SingleTickerProviderStateMixin {
  static const _loopCount = 64;

  late final ScrollController _controller;
  Ticker? _ticker;
  Duration _lastElapsed = Duration.zero;
  var _paused = false;
  var _didJumpToLoop = false;
  Timer? _resumeTimer;

  int get _uniqueCount => widget.items.length;

  double get _stride => HomeClothingCarousel.cardWidth + AppSpacing.sm;

  double get _loopWidth => _uniqueCount * _stride;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _syncTicker();
  }

  @override
  void didUpdateWidget(HomeClothingCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoScroll != widget.autoScroll ||
        oldWidget.items.length != widget.items.length) {
      _didJumpToLoop = false;
      _syncTicker();
    }
  }

  void _syncTicker() {
    final shouldRun = widget.autoScroll && _uniqueCount > 0;
    if (shouldRun) {
      _ticker ??= createTicker(_onTick);
      if (!(_ticker?.isActive ?? false)) {
        _lastElapsed = Duration.zero;
        _ticker!.start();
      }
    } else {
      _ticker?.stop();
    }
  }

  void _onTick(Duration elapsed) {
    if (_paused || !_controller.hasClients || _uniqueCount == 0) {
      _lastElapsed = elapsed;
      return;
    }
    final dt = elapsed - _lastElapsed;
    _lastElapsed = elapsed;
    final delta = widget.pixelsPerSecond * dt.inMicroseconds / 1e6;
    if (delta <= 0) {
      return;
    }
    final max = _controller.position.maxScrollExtent;
    var next = _controller.offset + delta;
    final loopWidth = _loopWidth;
    if (loopWidth > 0 && next > max - loopWidth) {
      next = loopWidth + (next - (max - loopWidth));
      if (next > max) {
        next = loopWidth;
      }
    }
    _controller.jumpTo(next.clamp(0, max));
  }

  void _pause() {
    _resumeTimer?.cancel();
    _paused = true;
  }

  void _scheduleResume() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(HomeClothingCarousel.resumeDelay, () {
      if (mounted) {
        _paused = false;
      }
    });
  }

  void _jumpToLoopStartIfNeeded() {
    if (_didJumpToLoop ||
        !widget.autoScroll ||
        !_controller.hasClients ||
        _uniqueCount == 0) {
      return;
    }
    final loopWidth = _loopWidth;
    if (loopWidth <= 0) {
      return;
    }
    _didJumpToLoop = true;
    _controller.jumpTo(loopWidth);
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _ticker?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_uniqueCount == 0) {
      return const SizedBox.shrink();
    }
    final itemCount = widget.autoScroll
        ? _uniqueCount * _loopCount
        : _uniqueCount;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToLoopStartIfNeeded();
    });

    return SizedBox(
      key: HomeClothingCarousel.carouselKey,
      height: HomeClothingCarousel.photoHeight + 56,
      child: Listener(
        onPointerDown: (_) => _pause(),
        onPointerUp: (_) => _scheduleResume(),
        onPointerCancel: (_) => _scheduleResume(),
        child: ListView.builder(
          controller: _controller,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final item = widget.items[index % _uniqueCount];
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: _HomeClothingSlide(item: item),
            );
          },
        ),
      ),
    );
  }
}

class _HomeClothingSlide extends StatelessWidget {
  const _HomeClothingSlide({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: HomeClothingCarousel.cardWidth,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: HomeClothingCarousel.cardKey(item.id),
          onTap: () =>
              context.push(AppRoutes.itemDetail(item.wardrobeId, item.id)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: HomeClothingCarousel.photoHeight,
                width: double.infinity,
                child: ItemBrowseImage(item: item),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                child: Text(
                  item.name,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
