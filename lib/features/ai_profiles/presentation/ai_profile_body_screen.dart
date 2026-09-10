import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../application/personal_ai_profiles_controller.dart';
import '../domain/ai_profile.dart';
import '../domain/ai_profile_body_context.dart';
import 'widgets/ai_profile_body_form.dart';

/// View and edit optional PERSONAL body/context fields (WARDROBE-81/83).
///
/// GENERIC_MODEL catalog rows are not editable in-app.
class AiProfileBodyScreen extends ConsumerWidget {
  const AiProfileBodyScreen({super.key, required this.aiProfileId});

  final String aiProfileId;

  static const screenKey = Key('ai_profile_body_screen');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personal = ref.watch(personalAiProfilesControllerProvider);
    AiProfile? profile;
    for (final item in personal.profiles) {
      if (item.id == aiProfileId) {
        profile = item;
        break;
      }
    }

    return Scaffold(
      key: screenKey,
      appBar: AppBar(title: const Text('Body details')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: profile == null
                ? const AppEmptyState(
                    icon: Icons.face_retouching_natural_outlined,
                    title: 'Profile not found',
                    message:
                        'This personal profile is no longer available. '
                        'Go back and pick one from AI try-on.',
                  )
                : SingleChildScrollView(
                    padding: AppSpacing.pageInsets,
                    child: AiProfileBodyForm(
                      initial: profile.bodyContext,
                      enabled: !personal.isBusy,
                      onSubmit: (bodyContext) =>
                          _save(context, ref, bodyContext),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    AiProfileBodyContext bodyContext,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final saved = await ref
        .read(personalAiProfilesControllerProvider.notifier)
        .updateBodyContext(aiProfileId, bodyContext);
    if (!context.mounted) {
      return;
    }
    if (!saved) {
      final message =
          ref.read(personalAiProfilesControllerProvider).errorMessage ??
          'Could not save body details.';
      messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          bodyContext.isEmpty
              ? 'Body details cleared. Try-on still works without them.'
              : 'Body details saved on this profile.',
        ),
      ),
    );
    if (context.canPop()) {
      context.pop();
    }
  }
}
