import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/share_sheet.dart';

/// Native share sheet via `share_plus`. Title + URL; image when a file exists.
class SharePlusSheet implements NativeShareSheet {
  const SharePlusSheet();

  @override
  Future<void> share(SharePayload payload) {
    final imagePath = payload.imagePath?.trim();
    final files = imagePath == null || imagePath.isEmpty
        ? null
        : [XFile(imagePath)];
    return SharePlus.instance.share(
      ShareParams(
        text: payload.url,
        title: payload.title,
        subject: payload.title,
        files: files,
        sharePositionOrigin: payload.origin,
      ),
    );
  }
}

final nativeShareSheetProvider = Provider<NativeShareSheet>((ref) {
  return const SharePlusSheet();
});
