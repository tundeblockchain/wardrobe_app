import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/support_controller.dart';
import '../../domain/support_form_kind.dart';
import '../../domain/support_validators.dart';
import '../../../../core/widgets/app_gloss.dart';

/// Shared subject + message form for Contact us and Report a bug.
///
/// Submits via Dio to Backend `/support/*`. Never uses mailto or Resend.
class SupportForm extends ConsumerStatefulWidget {
  const SupportForm({super.key, required this.kind});

  final SupportFormKind kind;

  static const subjectFieldKey = Key('support_subject');
  static const messageFieldKey = Key('support_message');
  static const submitButtonKey = Key('support_submit');
  static const contextChipKey = Key('support_device_context');

  @override
  ConsumerState<SupportForm> createState() => _SupportFormState();
}

class _SupportFormState extends ConsumerState<SupportForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    final sent = await ref
        .read(supportControllerProvider(widget.kind).notifier)
        .submit(
          subject: _subjectController.text,
          body: _messageController.text,
        );
    if (sent && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(widget.kind.successMessage)));
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supportControllerProvider(widget.kind));

    return Scaffold(
      appBar: AppGlossBar(title: Text(widget.kind.title)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.kind.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: SupportForm.subjectFieldKey,
                      controller: _subjectController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: SupportValidators.maxSubjectLength,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      validator: SupportValidators.subject,
                      enabled: !state.isSubmitting,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      key: SupportForm.messageFieldKey,
                      controller: _messageController,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 5,
                      maxLines: 10,
                      maxLength: SupportValidators.maxMessageLength,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: SupportValidators.message,
                      enabled: !state.isSubmitting,
                    ),
                    if (state.deviceAppSummary.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        key: SupportForm.contextChipKey,
                        'Included with this report: ${state.deviceAppSummary}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: SupportForm.submitButtonKey,
                      onPressed: state.isSubmitting ? null : _submit,
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(widget.kind.submitLabel),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
