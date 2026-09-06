import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../../auth/domain/auth_validators.dart';
import '../data/dio_support_repository.dart';
import '../data/package_info_device_context.dart';
import '../domain/device_context.dart';
import '../domain/support_form_kind.dart';
import '../domain/support_repository.dart';
import 'support_failure.dart';
import 'support_state.dart';

/// Submits contact / bug-report forms to Backend `/support/*` only.
class SupportController extends Notifier<SupportState> {
  SupportController(this.kind);

  final SupportFormKind kind;

  @override
  SupportState build() {
    Future<void>.microtask(_loadContext);
    return const SupportState();
  }

  SupportRepository get _repository => ref.read(supportRepositoryProvider);

  DeviceContext get _deviceContext => ref.read(deviceContextProvider);

  Future<void> _loadContext() async {
    try {
      final info = await _deviceContext.load();
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        replyTo: _replyToFromSession(),
        meta: info.toMeta(),
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(replyTo: _replyToFromSession());
    }
  }

  String? _replyToFromSession() {
    final email = ref.read(authControllerProvider).user?.email?.trim();
    if (email == null || !AuthValidators.emailRegExp.hasMatch(email)) {
      return null;
    }
    return email;
  }

  Future<bool> submit({required String subject, required String body}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final trimmedSubject = subject.trim();
      final trimmedBody = body.trim();
      switch (kind) {
        case SupportFormKind.contact:
          await _repository.sendContact(
            subject: trimmedSubject,
            body: trimmedBody,
            replyTo: state.replyTo,
            meta: state.meta,
          );
        case SupportFormKind.bug:
          await _repository.sendBug(
            subject: trimmedSubject,
            body: trimmedBody,
            replyTo: state.replyTo,
            meta: state.meta,
          );
      }
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (error) {
      if (!ref.mounted) {
        return false;
      }
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: messageForSupportFailure(error),
      );
      return false;
    }
  }
}

final supportControllerProvider =
    NotifierProvider.family<SupportController, SupportState, SupportFormKind>(
      SupportController.new,
    );
