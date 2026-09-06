/// Immutable support-form state owned by [SupportController].
class SupportState {
  const SupportState({
    this.isSubmitting = false,
    this.errorMessage,
    this.replyTo,
    this.meta,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final String? replyTo;
  final Map<String, String>? meta;

  String get deviceAppSummary {
    final values = meta?.values.where((value) => value.trim().isNotEmpty);
    return values == null ? '' : values.join(' · ');
  }

  SupportState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    String? replyTo,
    Map<String, String>? meta,
  }) {
    return SupportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      replyTo: replyTo ?? this.replyTo,
      meta: meta ?? this.meta,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SupportState &&
            isSubmitting == other.isSubmitting &&
            errorMessage == other.errorMessage &&
            replyTo == other.replyTo &&
            _mapEquals(meta, other.meta);
  }

  @override
  int get hashCode => Object.hash(
    isSubmitting,
    errorMessage,
    replyTo,
    meta == null ? null : Object.hashAll(meta!.entries),
  );
}

bool _mapEquals(Map<String, String>? a, Map<String, String>? b) {
  if (identical(a, b)) {
    return true;
  }
  if (a == null || b == null || a.length != b.length) {
    return a == b;
  }
  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}
