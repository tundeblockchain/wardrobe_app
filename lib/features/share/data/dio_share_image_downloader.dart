import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/share_sheet.dart';

/// Downloads a presigned photo to a temp file. Soft-fails (returns null).
class DioShareImageDownloader implements ShareImageDownloader {
  DioShareImageDownloader([Dio? dio]) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<String?> downloadToTempFile(String url) async {
    if (kIsWeb) {
      return null;
    }
    final trimmed = url.trim();
    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        !uri.hasAuthority) {
      return null;
    }
    try {
      final response = await _dio.get<List<int>>(
        trimmed,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      final ext = _extensionFor(uri, response.headers.value('content-type'));
      final file = File(
        '${Directory.systemTemp.path}/wardrobe_share_${DateTime.now().millisecondsSinceEpoch}$ext',
      );
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }
}

String _extensionFor(Uri uri, String? contentType) {
  final fromPath = uri.path.toLowerCase();
  if (fromPath.endsWith('.png')) {
    return '.png';
  }
  if (fromPath.endsWith('.webp')) {
    return '.webp';
  }
  if (fromPath.endsWith('.gif')) {
    return '.gif';
  }
  if (contentType != null && contentType.contains('png')) {
    return '.png';
  }
  if (contentType != null && contentType.contains('webp')) {
    return '.webp';
  }
  return '.jpg';
}

final shareImageDownloaderProvider = Provider<ShareImageDownloader>((ref) {
  return DioShareImageDownloader();
});
