import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/ai_profile.dart';
import 'ai_profile_status_chip.dart';

/// PERSONAL profile card: status, reference count, upload, select, delete.
class PersonalAiProfileCard extends StatelessWidget {
  const PersonalAiProfileCard({
    super.key,
    required this.profile,
    required this.selected,
    required this.busy,
    required this.uploading,
    required this.deleting,
    required this.onSelect,
    required this.onCamera,
    required this.onGallery,
    required this.onDelete,
  });

  final AiProfile profile;
  final bool selected;
  final bool busy;
  final bool uploading;
  final bool deleting;
  final VoidCallback onSelect;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onDelete;

  static Key cardKey(String id) => Key('personal_ai_profile_$id');
  static Key cameraKey(String id) => Key('personal_ai_profile_camera_$id');
  static Key galleryKey(String id) => Key('personal_ai_profile_gallery_$id');
  static Key deleteKey(String id) => Key('personal_ai_profile_delete_$id');
  static Key selectKey(String id) => Key('personal_ai_profile_select_$id');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final count = profile.referenceImages.length;
    final photoLabel = count == 1
        ? '1 reference photo'
        : '$count reference photos';

    return Card(
      key: cardKey(profile.id),
      color: selected ? scheme.primaryContainer : null,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.secondaryContainer,
                  foregroundColor: scheme.onSecondaryContainer,
                  child: const Icon(Icons.person_outline),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.displayName,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(photoLabel, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                AiProfileStatusChip(
                  key: AiProfileStatusChip.chipKey(profile.id),
                  status: profile.status,
                ),
              ],
            ),
            if (uploading) ...[
              const SizedBox(height: AppSpacing.md),
              const LinearProgressIndicator(),
              const SizedBox(height: AppSpacing.sm),
              Text('Uploading photo…', style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: cameraKey(profile.id),
                    onPressed: busy || !profile.canAddReferenceImage
                        ? null
                        : onCamera,
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    key: galleryKey(profile.id),
                    onPressed: busy || !profile.canAddReferenceImage
                        ? null
                        : onGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    key: selectKey(profile.id),
                    onPressed: busy ? null : onSelect,
                    child: Text(
                      selected ? 'Selected for try-on' : 'Use for try-on',
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  key: deleteKey(profile.id),
                  tooltip: 'Delete profile',
                  onPressed: busy ? null : onDelete,
                  icon: deleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.delete_outline, color: scheme.error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
