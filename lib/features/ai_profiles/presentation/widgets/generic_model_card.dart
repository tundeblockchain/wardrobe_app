import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/ai_profile.dart';
import 'ai_profile_picker_image.dart';
import 'ai_profile_status_chip.dart';

/// GENERIC_MODEL catalog tile. Tap selects it for WARDROBE-51 try-on prep.
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
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  AiProfilePickerImage(profile: profile),
                  if (selected)
                    Icon(Icons.check_circle, color: scheme.primary, size: 20),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                profile.displayName,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              AiProfileStatusChip(status: profile.status),
            ],
          ),
        ),
      ),
    );
  }
}
