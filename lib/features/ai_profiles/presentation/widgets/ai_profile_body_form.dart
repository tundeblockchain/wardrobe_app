import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/ai_profile_body_context.dart';
import '../../domain/ai_profile_body_validators.dart';

/// Burgundy/plum-themed optional body/context fields for a PERSONAL profile.
class AiProfileBodyForm extends StatefulWidget {
  const AiProfileBodyForm({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.enabled = true,
    this.canPersistRemotely = false,
  });

  final AiProfileBodyContext initial;
  final ValueChanged<AiProfileBodyContext> onSubmit;
  final bool enabled;

  /// False until Backend WARDROBE-80 exposes an update contract.
  final bool canPersistRemotely;

  static const heightFieldKey = Key('ai_profile_body_height');
  static const ageFieldKey = Key('ai_profile_body_age');
  static const bustFieldKey = Key('ai_profile_body_bust');
  static const hipsFieldKey = Key('ai_profile_body_hips');
  static const sizeFieldKey = Key('ai_profile_body_size');
  static const weightFieldKey = Key('ai_profile_body_weight');
  static const submitButtonKey = Key('ai_profile_body_submit');
  static const optionalBannerKey = Key('ai_profile_body_optional_banner');

  @override
  State<AiProfileBodyForm> createState() => AiProfileBodyFormState();
}

class AiProfileBodyFormState extends State<AiProfileBodyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _ageController;
  late final TextEditingController _bustController;
  late final TextEditingController _hipsController;
  late final TextEditingController _sizeController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
      text: _format(widget.initial.height),
    );
    _ageController = TextEditingController(text: _format(widget.initial.age));
    _bustController = TextEditingController(text: _format(widget.initial.bust));
    _hipsController = TextEditingController(text: _format(widget.initial.hips));
    _sizeController = TextEditingController(
      text: widget.initial.size?.trim() ?? '',
    );
    _weightController = TextEditingController(
      text: _format(widget.initial.weight),
    );
  }

  @override
  void dispose() {
    _heightController.dispose();
    _ageController.dispose();
    _bustController.dispose();
    _hipsController.dispose();
    _sizeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  bool submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }
    widget.onSubmit(
      AiProfileBodyValidators.parseForm(
        height: _heightController.text,
        age: _ageController.text,
        bust: _bustController.text,
        hips: _hipsController.text,
        size: _sizeController.text,
        weight: _weightController.text,
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = widget.enabled;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            key: AiProfileBodyForm.optionalBannerKey,
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optional body details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'These measurements give try-on more context. Leave any '
                    'field empty — empty values never block try-on.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  if (!widget.canPersistRemotely) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'The server cannot store these fields yet. Values stay '
                      'on this profile in the app until then.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            key: AiProfileBodyForm.heightFieldKey,
            controller: _heightController,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _decimalFormatters,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.height,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.ageFieldKey,
            controller: _ageController,
            enabled: enabled,
            keyboardType: TextInputType.number,
            inputFormatters: _intFormatters,
            decoration: const InputDecoration(
              labelText: 'Age',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.age,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.bustFieldKey,
            controller: _bustController,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _decimalFormatters,
            decoration: const InputDecoration(
              labelText: 'Bust (cm)',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.bust,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.hipsFieldKey,
            controller: _hipsController,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _decimalFormatters,
            decoration: const InputDecoration(
              labelText: 'Hips (cm)',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.hips,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.sizeFieldKey,
            controller: _sizeController,
            enabled: enabled,
            textCapitalization: TextCapitalization.characters,
            maxLength: AiProfileBodyValidators.maxSizeLength,
            decoration: const InputDecoration(
              labelText: 'Clothing size',
              hintText: 'e.g. M, 10, 42',
            ),
            validator: AiProfileBodyValidators.size,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.weightFieldKey,
            controller: _weightController,
            enabled: enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: _decimalFormatters,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.weight,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            key: AiProfileBodyForm.submitButtonKey,
            onPressed: enabled ? submit : null,
            child: const Text('Save body details'),
          ),
        ],
      ),
    );
  }

  static String _format(num? value) {
    if (value == null) {
      return '';
    }
    return formatBodyNumber(value);
  }
}

final _decimalFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
];

final _intFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.digitsOnly,
];
