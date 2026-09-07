import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Disk leftovers that must not survive sign-out.
///
/// This app does not currently write SharedPreferences or FlutterSecureStorage.
/// The hook still runs on every session reset so a future store cannot leak
/// the previous account. Firebase Auth persistence is cleared by Firebase
/// `signOut`, not here.
abstract class SessionLocalStore {
  Future<void> clear();
}

/// Default store: no SharedPreferences / secure-storage keys exist today.
class EmptySessionLocalStore implements SessionLocalStore {
  const EmptySessionLocalStore();

  @override
  Future<void> clear() async {}
}

/// In-memory prefs + secure map for tests (and any future local writes).
class InMemorySessionLocalStore implements SessionLocalStore {
  InMemorySessionLocalStore({
    Map<String, Object?>? preferences,
    Map<String, String>? secureStorage,
  }) : preferences = preferences ?? <String, Object?>{},
       secureStorage = secureStorage ?? <String, String>{};

  final Map<String, Object?> preferences;
  final Map<String, String> secureStorage;
  int clearCount = 0;

  @override
  Future<void> clear() async {
    clearCount++;
    preferences.clear();
    secureStorage.clear();
  }
}

/// Flutter [ImageCache] plus live image listeners (item / cover photos).
abstract class SessionImageCache {
  void clear();
}

class FlutterSessionImageCache implements SessionImageCache {
  const FlutterSessionImageCache();

  @override
  void clear() {
    final cache = imageCache;
    cache.clear();
    cache.clearLiveImages();
  }
}

class RecordingSessionImageCache implements SessionImageCache {
  int clearCount = 0;

  @override
  void clear() {
    clearCount++;
  }
}

final sessionLocalStoreProvider = Provider<SessionLocalStore>((ref) {
  return const EmptySessionLocalStore();
});

final sessionImageCacheProvider = Provider<SessionImageCache>((ref) {
  return const FlutterSessionImageCache();
});
