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
  });

  final AiProfileBodyContext initial;
  final ValueChanged<AiProfileBodyContext> onSubmit;
  final bool enabled;

  static const heightFieldKey = Key('ai_profile_body_height');
  static const weightFieldKey = Key('ai_profile_body_weight');
  static const bustFieldKey = Key('ai_profile_body_bust');
  static const hipsFieldKey = Key('ai_profile_body_hips');
  static const sizeFieldKey = Key('ai_profile_body_size');
  static const braSizeFieldKey = Key('ai_profile_body_bra_size');
  static const ageFieldKey = Key('ai_profile_body_age');
  static const bodyTypeFieldKey = Key('ai_profile_body_body_type');
  static const genderFieldKey = Key('ai_profile_body_gender');
  static const submitButtonKey = Key('ai_profile_body_submit');
  static const optionalBannerKey = Key('ai_profile_body_optional_banner');
  static const helperCopy =
      'These measurements provide more context to generate a more accurate preview';

  @override
  State<AiProfileBodyForm> createState() => AiProfileBodyFormState();
}

class AiProfileBodyFormState extends State<AiProfileBodyForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _bustController;
  late final TextEditingController _hipsController;
  late final TextEditingController _sizeController;
  late final TextEditingController _braSizeController;
  late final TextEditingController _ageController;
  late String _bodyType;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
      text: _format(widget.initial.heightCm),
    );
    _weightController = TextEditingController(
      text: _format(widget.initial.weightKg),
    );
    _bustController = TextEditingController(
      text: _format(widget.initial.bustCm),
    );
    _hipsController = TextEditingController(
      text: _format(widget.initial.hipsCm),
    );
    _sizeController = TextEditingController(
      text: widget.initial.clothingSize?.trim() ?? '',
    );
    _braSizeController = TextEditingController(
      text: widget.initial.braSize?.trim() ?? '',
    );
    _ageController = TextEditingController(
      text: widget.initial.ageYears == null ? '' : '${widget.initial.ageYears}',
    );
    _bodyType = widget.initial.bodyType?.trim() ?? '';
    _gender = widget.initial.gender?.trim() ?? '';
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _bustController.dispose();
    _hipsController.dispose();
    _sizeController.dispose();
    _braSizeController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  bool submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return false;
    }
    widget.onSubmit(
      AiProfileBodyValidators.parseForm(
        heightCm: _heightController.text,
        weightKg: _weightController.text,
        bustCm: _bustController.text,
        hipsCm: _hipsController.text,
        clothingSize: _sizeController.text,
        braSize: _braSizeController.text,
        ageYears: _ageController.text,
        bodyType: _bodyType,
        gender: _gender,
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
                    AiProfileBodyForm.helperCopy,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
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
            validator: AiProfileBodyValidators.heightCm,
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
            validator: AiProfileBodyValidators.weightKg,
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
            validator: AiProfileBodyValidators.bustCm,
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
            validator: AiProfileBodyValidators.hipsCm,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.sizeFieldKey,
            controller: _sizeController,
            enabled: enabled,
            textCapitalization: TextCapitalization.characters,
            maxLength: AiProfileBodyValidators.maxClothingSizeLength,
            decoration: const InputDecoration(
              labelText: 'Clothing size',
              hintText: 'e.g. M, 10, 42',
            ),
            validator: AiProfileBodyValidators.clothingSize,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.braSizeFieldKey,
            controller: _braSizeController,
            enabled: enabled,
            textCapitalization: TextCapitalization.characters,
            maxLength: AiProfileBodyValidators.maxBraSizeLength,
            decoration: const InputDecoration(
              labelText: 'Bra size',
              hintText: 'e.g. 34B',
            ),
            validator: AiProfileBodyValidators.braSize,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            key: AiProfileBodyForm.ageFieldKey,
            controller: _ageController,
            enabled: enabled,
            keyboardType: TextInputType.number,
            inputFormatters: _intFormatters,
            decoration: const InputDecoration(
              labelText: 'Age (years)',
              hintText: 'Optional',
            ),
            validator: AiProfileBodyValidators.ageYears,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            key: AiProfileBodyForm.bodyTypeFieldKey,
            initialValue: _bodyType,
            decoration: const InputDecoration(
              labelText: 'Body type',
              hintText: 'Optional',
            ),
            items: _tokenItems(aiProfileBodyTypes, _bodyType),
            onChanged: enabled
                ? (value) => setState(() => _bodyType = value ?? '')
                : null,
            validator: AiProfileBodyValidators.bodyType,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            key: AiProfileBodyForm.genderFieldKey,
            initialValue: _gender,
            decoration: const InputDecoration(
              labelText: 'Gender',
              hintText: 'Optional',
            ),
            items: _tokenItems(aiProfileGenders, _gender),
            onChanged: enabled
                ? (value) => setState(() => _gender = value ?? '')
                : null,
            validator: AiProfileBodyValidators.gender,
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

List<DropdownMenuItem<String>> _tokenItems(
  List<String> recommended,
  String current,
) {
  return [
    const DropdownMenuItem(value: '', child: Text('Not set')),
    for (final token in recommended)
      DropdownMenuItem(value: token, child: Text(aiProfileTokenLabel(token))),
    if (current.isNotEmpty && !recommended.contains(current))
      DropdownMenuItem(
        value: current,
        child: Text(aiProfileTokenLabel(current)),
      ),
  ];
}

final _decimalFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
];

final _intFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.digitsOnly,
];
