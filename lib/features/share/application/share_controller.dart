import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/network/api_exception.dart';
import '../data/dio_share_image_downloader.dart';
import '../data/dio_share_repository.dart';
import '../data/share_plus_sheet.dart';
import '../domain/share.dart';
import '../domain/share_errors.dart';
import '../domain/share_repository.dart';
import '../domain/share_sheet.dart';
import '../domain/share_url.dart';
import 'share_state.dart';

/// Creates a share token, then opens the native share sheet.
///
/// Presentation → Controller → Repository → Dio.
class ShareController extends Notifier<ShareState> {
  @override
  ShareState build() => const ShareState();

  ShareRepository get _repository => ref.read(shareRepositoryProvider);

  void clearSnackMessage() {
    if (state.snackMessage != null) {
      state = state.copyWith(clearSnack: true);
    }
  }

  Future<bool> shareItem({
    required String wardrobeId,
    required String itemId,
    required String title,
    String? imageUrl,
    Rect? origin,
  }) {
    return _share(
      title: title,
      imageUrl: imageUrl,
      origin: origin,
      create: () =>
          _repository.createItemShare(wardrobeId: wardrobeId, itemId: itemId),
    );
  }

  Future<bool> shareOutfit({
    required String wardrobeId,
    required String outfitId,
    required String title,
    String? imageUrl,
    Rect? origin,
  }) {
    return _share(
      title: title,
      imageUrl: imageUrl,
      origin: origin,
      create: () => _repository.createOutfitShare(
        wardrobeId: wardrobeId,
        outfitId: outfitId,
      ),
    );
  }

  Future<bool> _share({
    required String title,
    String? imageUrl,
    Rect? origin,
    required Future<Share> Function() create,
  }) async {
    if (state.isSharing) {
      return false;
    }

    final landingBase = ref.read(appConfigProvider).shareLandingBaseUrl;
    if (ShareLandingUrl.normalizeBase(landingBase) == null) {
      state = state.copyWith(snackMessage: ShareErrors.missingLandingBase);
      return false;
    }

    state = state.copyWith(isSharing: true, clearSnack: true);
    try {
      final share = await create();
      if (!ref.mounted) {
        return false;
      }
      final url = ShareLandingUrl.resolve(
        landingBaseUrl: landingBase,
        sharePath: share.sharePath,
      );
      if (url == null) {
        state = state.copyWith(
          isSharing: false,
          snackMessage: ShareErrors.invalidUrl,
        );
        return false;
      }

      final imagePath = await _maybeDownloadImage(imageUrl);
      if (!ref.mounted) {
        return false;
      }
      await ref
          .read(nativeShareSheetProvider)
          .share(
            SharePayload(
              title: title.trim().isEmpty ? 'Share' : title.trim(),
              url: url,
              imagePath: imagePath,
              origin: origin,
            ),
          );
      if (!ref.mounted) {
        return true;
      }
      state = state.copyWith(isSharing: false, clearSnack: true);
      return true;
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSharing: false,
        snackMessage: ShareErrors.messageFor(error),
      );
      return false;
    } catch (_) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSharing: false,
        snackMessage: ShareErrors.sheetFailed,
      );
      return false;
    }
  }

  Future<String?> _maybeDownloadImage(String? imageUrl) async {
    final trimmed = imageUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    try {
      return await ref
          .read(shareImageDownloaderProvider)
          .downloadToTempFile(trimmed);
    } catch (_) {
      return null;
    }
  }
}

final shareControllerProvider = NotifierProvider<ShareController, ShareState>(
  ShareController.new,
);
