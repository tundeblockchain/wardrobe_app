import '../domain/job_event.dart';

/// Inbox / processing-tray state owned by [InboxController].
class InboxState {
  const InboxState({
    this.events = const [],
    this.pending = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.contractUnavailable = false,
    this.errorMessage,
  });

  final List<JobEvent> events;
  final List<JobEvent> pending;
  final int unreadCount;
  final bool isLoading;
  final bool isRefreshing;
  final bool contractUnavailable;
  final String? errorMessage;

  bool get isBusy => isLoading || isRefreshing;

  bool get hasPending => pending.isNotEmpty;

  /// Server events (newest first) plus unmatched local PENDING rows.
  List<JobEvent> get visibleEvents {
    final completed = events;
    final leftover = [
      for (final row in pending)
        if (!completed.any(row.matchesPendingCompletion)) row,
    ];
    leftover.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [...leftover, ...completed];
  }

  bool get isEmpty => visibleEvents.isEmpty;

  InboxState copyWith({
    List<JobEvent>? events,
    List<JobEvent>? pending,
    int? unreadCount,
    bool? isLoading,
    bool? isRefreshing,
    bool? contractUnavailable,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InboxState(
      events: events ?? this.events,
      pending: pending ?? this.pending,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      contractUnavailable: contractUnavailable ?? this.contractUnavailable,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is InboxState &&
            _listEquals(events, other.events) &&
            _listEquals(pending, other.pending) &&
            unreadCount == other.unreadCount &&
            isLoading == other.isLoading &&
            isRefreshing == other.isRefreshing &&
            contractUnavailable == other.contractUnavailable &&
            errorMessage == other.errorMessage;
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(events),
    Object.hashAll(pending),
    unreadCount,
    isLoading,
    isRefreshing,
    contractUnavailable,
    errorMessage,
  );
}

bool _listEquals(List<JobEvent> a, List<JobEvent> b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
