import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/ai_profiles/application/selected_ai_profile.dart';

import '../../../helpers/fake_ai_profile_repository.dart';

void main() {
  test('select stores the profile id for WARDROBE-51', () {
    final container = ProviderContainer.test();
    addTearDown(container.dispose);

    expect(container.read(selectedAiProfileIdProvider), isNull);

    final alex = testGenericModel();
    container.read(selectedAiProfileProvider.notifier).select(alex);

    expect(container.read(selectedAiProfileProvider)?.label, 'Alex');
    expect(container.read(selectedAiProfileIdProvider), 'profile_generic_01');

    container.read(selectedAiProfileProvider.notifier).clear();
    expect(container.read(selectedAiProfileIdProvider), isNull);
  });
}
