import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../../ai_profiles/domain/ai_profile.dart';
import '../../../ai_profiles/presentation/widgets/ai_profile_picker_image.dart';

/// Large try-on / Test Outfit picker card so the user can see the persona.
/// Photo slot size is unchanged from WARDROBE-74; the image now cover-crops.
class TryOnPersonaCard extends StatelessWidget {
  const TryOnPersonaCard({
    super.key,
    required this.profile,
    required this.selected,
    required this.onSelect,
  });

  final AiProfile profile;
  final bool selected;
  final VoidCallback onSelect;

  static const double cardWidth = 148;
  static const double photoHeight = 196;

  static Key cardKey(String id) => Key('try_on_persona_card_$id');

  /// Legacy chip key kept so existing finders still resolve after the
  /// FilterChip → card swap (WARDROBE-74).
  static Key chipKey(String id) => Key('try_on_profile_chip_$id');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: cardWidth,
      child: Card(
        key: cardKey(profile.id),
        color: selected ? scheme.primaryContainer : null,
        clipBehavior: Clip.antiAlias,
        child: AppGloss(
          child: InkWell(
            key: chipKey(profile.id),
            onTap: onSelect,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: photoHeight,
                  width: double.infinity,
                  child: AiProfilePickerImage(profile: profile),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.displayName,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (selected)
                        Icon(
                          Icons.check_circle,
                          color: scheme.primary,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
