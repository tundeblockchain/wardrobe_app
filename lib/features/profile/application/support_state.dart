/// Immutable support-form state owned by [SupportController].
class SupportState {
  const SupportState({
    this.isSubmitting = false,
    this.errorMessage,
    this.device,
    this.appVersion,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final String? device;
  final String? appVersion;

  String get deviceAppSummary {
    final parts = <String>[
      if (device != null && device!.isNotEmpty) device!,
      if (appVersion != null && appVersion!.isNotEmpty) appVersion!,
    ];
    return parts.join(' · ');
  }

  SupportState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    String? device,
    String? appVersion,
  }) {
    return SupportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      device: device ?? this.device,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SupportState &&
            isSubmitting == other.isSubmitting &&
            errorMessage == other.errorMessage &&
            device == other.device &&
            appVersion == other.appVersion;
  }

  @override
  int get hashCode =>
      Object.hash(isSubmitting, errorMessage, device, appVersion);
}
