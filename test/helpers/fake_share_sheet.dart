import 'package:wardrobe_app/features/share/domain/share_sheet.dart';

/// Records native share-sheet calls for tests.
class FakeShareSheet implements NativeShareSheet {
  final List<SharePayload> payloads = [];
  Object? nextFailure;

  @override
  Future<void> share(SharePayload payload) async {
    payloads.add(payload);
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }
}

/// Returns a canned temp path (or null) instead of hitting the network.
class FakeShareImageDownloader implements ShareImageDownloader {
  FakeShareImageDownloader({this.path});

  String? path;
  final List<String> calls = [];

  @override
  Future<String?> downloadToTempFile(String url) async {
    calls.add(url);
    return path;
  }
}
