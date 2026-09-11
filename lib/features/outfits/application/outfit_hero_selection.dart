import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'outfit_scope.dart';

/// Session-only hero pick for one outfit. Latest is the default when null.
class OutfitHeroSelection extends Notifier<String?> {
  OutfitHeroSelection(this.scope);

  final OutfitScope scope;

  @override
  String? build() => null;

  void select(String url) {
    final trimmed = url.trim();
    state = trimmed.isEmpty ? null : trimmed;
  }

  void clear() => state = null;
}

final outfitHeroSelectionProvider =
    NotifierProvider.family<OutfitHeroSelection, String?, OutfitScope>(
      OutfitHeroSelection.new,
    );
