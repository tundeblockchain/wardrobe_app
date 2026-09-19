import '../../items/domain/item.dart';
import '../../items/domain/item_image_source.dart';
import '../../outfits/domain/outfit.dart';
import '../../outfits/domain/try_on_history.dart';

/// http(s) photo to attach to the native share sheet, if any.
abstract final class ShareImage {
  /// Processed item URL when present, otherwise the original upload URL.
  static String? itemUrl(Item item) {
    return ItemImageSource.fromItem(item).networkUrl;
  }

  /// Selected hero, else the first try-on display URL. Never invents a URL.
  static String? outfitUrl(Outfit outfit, {String? selectedHeroUrl}) {
    final selected = presignedTryOnUrl(selectedHeroUrl);
    if (selected != null) {
      return selected;
    }
    final urls = tryOnDisplayUrls(
      latestRender: outfit.render,
      renderImageUrls: outfit.renderImageUrls,
      history: outfit.renderHistory,
    );
    return urls.isEmpty ? null : urls.first;
  }
}
