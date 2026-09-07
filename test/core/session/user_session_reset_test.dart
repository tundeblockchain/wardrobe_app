import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/session/session_gate.dart';
import 'package:wardrobe_app/core/session/session_local_store.dart';
import 'package:wardrobe_app/core/session/user_session_reset.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/items/application/item_local_preview_cache.dart';
import 'package:wardrobe_app/features/wardrobes/application/wardrobes_controller.dart';
import 'package:wardrobe_app/features/wardrobes/data/dio_wardrobe_repository.dart';

import '../../helpers/fake_ai_profile_repository.dart';
import '../../helpers/fake_wardrobe_repository.dart';

void main() {
  late FakeWardrobeRepository wardrobes;
  late InMemorySessionLocalStore store;
  late RecordingSessionImageCache images;
  late ProviderContainer container;

  setUp(() {
    wardrobes = FakeWardrobeRepository(seed: [testWardrobe()]);
    store = InMemorySessionLocalStore(
      preferences: {'lastWardrobe': 'wd_abc123'},
      secureStorage: {'sessionHint': 'secret'},
    );
    images = RecordingSessionImageCache();
    container = ProviderContainer.test(
      overrides: [
        wardrobeRepositoryProvider.overrideWithValue(wardrobes),
        sessionLocalStoreProvider.overrideWithValue(store),
        sessionImageCacheProvider.overrideWithValue(images),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test(
    'clear wipes lists, preview bytes, prefs, secure map, and images',
    () async {
      container.read(wardrobesControllerProvider);
      await settle();
      expect(
        container.read(wardrobesControllerProvider).wardrobes,
        hasLength(1),
      );

      container
          .read(itemLocalPreviewCacheProvider.notifier)
          .store('item_1', Uint8List.fromList(const [1, 2, 3]));
      container
          .read(selectedAiProfileProvider.notifier)
          .select(testPersonalProfile());

      await container.read(userSessionResetProvider).clear();

      expect(store.clearCount, 1);
      expect(store.preferences, isEmpty);
      expect(store.secureStorage, isEmpty);
      expect(images.clearCount, 1);
      expect(container.read(itemLocalPreviewCacheProvider), isEmpty);
      expect(container.read(selectedAiProfileProvider), isNull);
      expect(container.read(sessionGateProvider).allowUserDataFetch, isTrue);

      container.read(sessionGateProvider.notifier).markSignedOut();
      expect(container.read(wardrobesControllerProvider).wardrobes, isEmpty);
      expect(container.read(wardrobesControllerProvider).isLoading, isFalse);
    },
  );
}
