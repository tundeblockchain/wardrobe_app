import 'package:flutter/material.dart';

/// Payload for the native share sheet (title + URL + optional local image).
class SharePayload {
  const SharePayload({
    required this.title,
    required this.url,
    this.imagePath,
    this.origin,
  });

  final String title;
  final String url;
  final String? imagePath;
  final Rect? origin;
}

/// Opens the platform share sheet. Tests override the provider.
abstract interface class NativeShareSheet {
  Future<void> share(SharePayload payload);
}

/// Downloads a remote photo to a temp file for [NativeShareSheet]. Soft-fails.
abstract interface class ShareImageDownloader {
  Future<String?> downloadToTempFile(String url);
}
