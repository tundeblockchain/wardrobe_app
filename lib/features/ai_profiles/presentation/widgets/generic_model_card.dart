import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../domain/ai_profile.dart';
import 'ai_profile_picker_image.dart';
import 'ai_profile_status_chip.dart';

/// GENERIC_MODEL catalog card. Tap selects it for WARDROBE-51 try-on prep.
///
/// Large cover-cropped frontal photo so the user can see which model they pick.
class GenericModelCard extends StatelessWidget {
  const GenericModelCard({
    super.key,
    required this.profile,
    required this.selected,
    required this.onSelect,
  });

  final AiProfile profile;
  final bool selected;
  final VoidCallback onSelect;

  static Key cardKey(String id) => Key('generic_model_$id');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      key: cardKey(profile.id),
      color: selected ? scheme.primaryContainer : null,
      clipBehavior: Clip.antiAlias,
      child: AppGloss(
        child: InkWell(
          onTap: onSelect,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AiProfilePickerImage(profile: profile),
                    if (selected)
                      Positioned(
                        top: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: Icon(
                          Icons.check_circle,
                          color: scheme.primary,
                          size: 22,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                child: Column(
                  children: [
                    Text(
                      profile.displayName,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    AiProfileStatusChip(status: profile.status),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
