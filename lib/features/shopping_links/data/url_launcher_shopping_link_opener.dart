import 'package:url_launcher/url_launcher.dart';

import '../domain/shopping_link.dart';
import '../domain/shopping_link_opener.dart';

/// Opens product pages in an external browser. No API keys.
class UrlLauncherShoppingLinkOpener implements ShoppingLinkOpener {
  const UrlLauncherShoppingLinkOpener();

  @override
  Future<bool> open(Uri url) {
    final parsed = tryParseShoppingUrl(url.toString());
    if (parsed == null) {
      return Future.value(false);
    }
    return launchUrl(parsed, mode: LaunchMode.externalApplication);
  }
}
