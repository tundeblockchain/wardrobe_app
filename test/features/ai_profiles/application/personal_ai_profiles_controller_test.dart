import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/core/network/api_exception.dart';
import 'package:wardrobe_app/features/ai_profiles/application/personal_ai_profiles_controller.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/data/dio_ai_profile_repository.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile.dart';
import 'package:wardrobe_app/features/ai_profiles/domain/ai_profile_body_context.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';

import '../../../helpers/fake_ai_profile_repository.dart';
import '../../../helpers/fake_item_image_picker.dart';

void main() {
  late FakeAiProfileRepository repository;
  late FakeItemImagePicker picker;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAiProfileRepository();
    picker = FakeItemImagePicker(image: FakeItemImagePicker.sample());
    container = ProviderContainer.test(
      overrides: [
        aiProfileRepositoryProvider.overrideWithValue(repository),
        itemImagePickerProvider.overrideWithValue(picker),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('refresh loads PERSONAL profiles from the repository', () async {
    repository.personal.add(testPersonalProfile());

    final first = container.read(personalAiProfilesControllerProvider);
    expect(first.isLoading, isTrue);

    await settle();

    final state = container.read(personalAiProfilesControllerProvider);
    expect(state.isLoading, isFalse);
    expect(state.profiles, hasLength(1));
    expect(state.profiles.single.id, 'profile_personal_1');
    expect(repository.listPersonalCalls, 1);
  });

  test('refresh records ApiException message', () async {
    repository.nextFailure = const ApiException(
      message: 'Unable to reach the server. Check your connection.',
      code: 'NETWORK_ERROR',
    );

    container.read(personalAiProfilesControllerProvider);
    await settle();

    final state = container.read(personalAiProfilesControllerProvider);
    expect(state.errorMessage, contains('connection'));
    expect(state.profiles, isEmpty);
  });

  test('createPersonal upserts into the list', () async {
    container.read(personalAiProfilesControllerProvider);
    await settle();

    final created = await container
        .read(personalAiProfilesControllerProvider.notifier)
        .createPersonal();

    expect(created?.id, 'profile_1');
    expect(
      container.read(personalAiProfilesControllerProvider).profiles.single.id,
      'profile_1',
    );
    expect(repository.createCalls, 1);
  });

  test('gallery upload uses Photo Picker then attach', () async {
    repository.personal.add(testPersonalProfile());
    container.read(personalAiProfilesControllerProvider);
    await settle();

    await container
        .read(personalAiProfilesControllerProvider.notifier)
        .pickFromGallery('profile_personal_1');

    expect(picker.galleryCalls, 1);
    expect(picker.cameraCalls, 0);
    expect(repository.createUploadCalls, 1);
    expect(repository.uploadCalls, 1);
    expect(repository.attachCalls, 1);
    expect(repository.lastContentType, 'image/jpeg');
    expect(
      repository.lastObjectKey,
      'users/uid/ai-profiles/profile_personal_1/ref.jpg',
    );
    expect(
      container
          .read(personalAiProfilesControllerProvider)
          .profiles
          .single
          .referenceImages,
      ['users/uid/ai-profiles/profile_personal_1/ref.jpg'],
    );
  });

  test('refuses more than 10 reference photos', () async {
    repository.personal.add(
      testPersonalProfile(
        referenceImages: List.generate(10, (index) => 'key_$index'),
      ),
    );
    container.read(personalAiProfilesControllerProvider);
    await settle();

    await container
        .read(personalAiProfilesControllerProvider.notifier)
        .pickFromCamera('profile_personal_1');

    expect(picker.cameraCalls, 0);
    expect(repository.createUploadCalls, 0);
    expect(
      container.read(personalAiProfilesControllerProvider).errorMessage,
      contains('$maxAiProfileReferenceImages'),
    );
  });

  test('deletePersonal removes the profile and clears selection', () async {
    final profile = testPersonalProfile();
    repository.personal.add(profile);
    container.read(personalAiProfilesControllerProvider);
    await settle();
    container.read(selectedAiProfileProvider.notifier).select(profile);

    final deleted = await container
        .read(personalAiProfilesControllerProvider.notifier)
        .deletePersonal(profile.id);

    expect(deleted, isTrue);
    expect(
      container.read(personalAiProfilesControllerProvider).profiles,
      isEmpty,
    );
    expect(container.read(selectedAiProfileProvider), isNull);
    expect(container.read(selectedAiProfileIdProvider), isNull);
  });

  test('clearLocal empties the in-memory list', () async {
    repository.personal.add(testPersonalProfile());
    container.read(personalAiProfilesControllerProvider);
    await settle();

    container.read(personalAiProfilesControllerProvider.notifier).clearLocal();

    expect(
      container.read(personalAiProfilesControllerProvider).profiles,
      isEmpty,
    );
  });

  test('applyBodyContext stores WARDROBE-80 fields in memory only', () async {
    final profile = testPersonalProfile();
    repository.personal.add(profile);
    container.read(personalAiProfilesControllerProvider);
    await settle();
    container.read(selectedAiProfileProvider.notifier).select(profile);

    const body = AiProfileBodyContext(height: 170, size: 'M');
    container
        .read(personalAiProfilesControllerProvider.notifier)
        .applyBodyContext(profile.id, body);

    expect(
      container
          .read(personalAiProfilesControllerProvider)
          .profiles
          .single
          .bodyContext,
      body,
    );
    expect(container.read(selectedAiProfileProvider)?.bodyContext, body);
    expect(repository.createCalls, 0);
    expect(repository.listPersonalCalls, 1);
  });

  test('refresh keeps session body details when get/list omit them', () async {
    repository.personal.add(testPersonalProfile());
    container.read(personalAiProfilesControllerProvider);
    await settle();

    container
        .read(personalAiProfilesControllerProvider.notifier)
        .applyBodyContext(
          'profile_personal_1',
          const AiProfileBodyContext(height: 168, weight: 60),
        );

    await container
        .read(personalAiProfilesControllerProvider.notifier)
        .refresh();

    expect(
      container
          .read(personalAiProfilesControllerProvider)
          .profiles
          .single
          .bodyContext
          .height,
      168,
    );
    expect(repository.listPersonalCalls, 2);
  });

  test('gallery upload preserves session body details', () async {
    repository.personal.add(
      testPersonalProfile(referenceImages: const ['users/uid/existing.jpg']),
    );
    container.read(personalAiProfilesControllerProvider);
    await settle();
    container
        .read(personalAiProfilesControllerProvider.notifier)
        .applyBodyContext(
          'profile_personal_1',
          const AiProfileBodyContext(age: 30),
        );

    await container
        .read(personalAiProfilesControllerProvider.notifier)
        .pickFromGallery('profile_personal_1');

    final updated = container
        .read(personalAiProfilesControllerProvider)
        .profiles
        .single;
    expect(updated.bodyContext.age, 30);
    expect(updated.referenceImages, hasLength(2));
  });
}
