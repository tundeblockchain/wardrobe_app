import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_gloss.dart';
import '../../domain/ai_profile.dart';
import 'ai_profile_picker_image.dart';
import 'ai_profile_status_chip.dart';

/// PERSONAL profile card: large cover-cropped photo, status, upload, select, delete.
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
    required this.onEditBody,
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
  final VoidCallback onEditBody;

  static Key cardKey(String id) => Key('personal_ai_profile_$id');
  static Key cameraKey(String id) => Key('personal_ai_profile_camera_$id');
  static Key galleryKey(String id) => Key('personal_ai_profile_gallery_$id');
  static Key deleteKey(String id) => Key('personal_ai_profile_delete_$id');
  static Key selectKey(String id) => Key('personal_ai_profile_select_$id');
  static Key bodyKey(String id) => Key('personal_ai_profile_body_$id');

  static const double photoHeight = 220;

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
      clipBehavior: Clip.antiAlias,
      child: AppGloss(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: photoHeight,
              width: double.infinity,
              child: AiProfilePickerImage(profile: profile),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
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
                            if (profile.bodyContext.summary != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                profile.bodyContext.summary!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
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
                  OutlinedButton.icon(
                    key: bodyKey(profile.id),
                    onPressed: busy ? null : onEditBody,
                    icon: const Icon(Icons.straighten_outlined),
                    label: const Text('Body details'),
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(Icons.delete_outline, color: scheme.error),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
