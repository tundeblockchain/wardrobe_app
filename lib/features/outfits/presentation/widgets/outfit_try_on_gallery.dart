import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/enlarged_image_popup.dart';

/// Swipeable generated try-ons. Latest is first; the current page is the hero.
class OutfitTryOnGallery extends StatefulWidget {
  const OutfitTryOnGallery({
    super.key,
    required this.imageUrls,
    this.selectedUrl,
    this.onSelect,
  });

  final List<String> imageUrls;
  final String? selectedUrl;
  final ValueChanged<String>? onSelect;

  static const galleryKey = Key('outfit_try_on_gallery');
  static const pageViewKey = Key('outfit_try_on_gallery_pages');

  static Key urlKey(String url) => Key('outfit_try_on_gallery_url_$url');

  static Key pageKey(int index) => Key('outfit_try_on_gallery_page_$index');

  @override
  State<OutfitTryOnGallery> createState() => _OutfitTryOnGalleryState();
}

class _OutfitTryOnGalleryState extends State<OutfitTryOnGallery> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = _indexOf(widget.selectedUrl);
    _controller = PageController(initialPage: _index);
  }

  @override
  void didUpdateWidget(covariant OutfitTryOnGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedUrl != oldWidget.selectedUrl ||
        widget.imageUrls != oldWidget.imageUrls) {
      final next = _indexOf(widget.selectedUrl);
      if (next != _index && _controller.hasClients) {
        _controller.jumpToPage(next);
      }
      _index = next;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _indexOf(String? url) {
    final selected = url?.trim();
    if (selected == null || selected.isEmpty) {
      return 0;
    }
    final index = widget.imageUrls.indexOf(selected);
    return index < 0 ? 0 : index;
  }

  void _onPageChanged(int index) {
    setState(() => _index = index);
    widget.onSelect?.call(widget.imageUrls[index]);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final urls = widget.imageUrls;
    return Column(
      key: OutfitTryOnGallery.galleryKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: PageView.builder(
            key: OutfitTryOnGallery.pageViewKey,
            controller: _controller,
            itemCount: urls.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final url = urls[index];
              return ColoredBox(
                key: OutfitTryOnGallery.pageKey(index),
                color: scheme.primaryContainer,
                child: InkWell(
                  onTap: () =>
                      EnlargedImagePopup.showNetwork(context, url: url),
                  child: Image.network(
                    url,
                    key: OutfitTryOnGallery.urlKey(url),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: scheme.primaryContainer,
                        child: Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(color: scheme.primary),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
        if (urls.length > 1) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < urls.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _index
                          ? scheme.primary
                          : scheme.outlineVariant,
                    ),
                    child: const SizedBox(width: 8, height: 8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _index == 0 ? 'Latest look' : 'Use as main look',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ],
    );
  }
}
