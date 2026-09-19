/// SQS / inbox `jobType` values emitted by Backend WARDROBE-114.
enum JobEventType {
  processWardrobeItem('PROCESS_WARDROBE_ITEM', 'Item'),
  renderOutfit('RENDER_OUTFIT', 'Try-on'),
  unknown('UNKNOWN', 'Update');

  const JobEventType(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static JobEventType parse(String? value) {
    if (value == null || value.isEmpty) {
      return JobEventType.unknown;
    }
    for (final type in JobEventType.values) {
      if (type.wireValue == value) {
        return type;
      }
    }
    return JobEventType.unknown;
  }

  bool get isItem => this == JobEventType.processWardrobeItem;

  bool get isTryOn => this == JobEventType.renderOutfit;
}

/// Terminal inbox `status` plus a local-only PENDING tray row.
enum JobEventStatus {
  ready('READY', 'Ready'),
  failed('FAILED', 'Failed'),
  pending('PENDING', 'Pending'),
  unknown('UNKNOWN', 'Unknown');

  const JobEventStatus(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static JobEventStatus parse(String? value) {
    if (value == null || value.isEmpty) {
      return JobEventStatus.unknown;
    }
    for (final status in JobEventStatus.values) {
      if (status.wireValue == value) {
        return status;
      }
    }
    return JobEventStatus.unknown;
  }

  bool get isReady => this == JobEventStatus.ready;

  bool get isFailed => this == JobEventStatus.failed;

  bool get isPending => this == JobEventStatus.pending;

  bool get isTerminal => isReady || isFailed;
}

/// One AI job-done row from `GET /me/events` or a local PENDING tray entry.
class JobEvent {
  const JobEvent({
    required this.eventId,
    required this.jobType,
    required this.status,
    required this.wardrobeId,
    this.itemId,
    this.outfitId,
    this.renderId,
    this.aiProfileId,
    this.error,
    required this.createdAt,
    this.acknowledgedAt,
    this.isLocalPending = false,
  });

  final String eventId;
  final JobEventType jobType;
  final JobEventStatus status;
  final String wardrobeId;
  final String? itemId;
  final String? outfitId;
  final String? renderId;
  final String? aiProfileId;
  final String? error;
  final DateTime createdAt;
  final DateTime? acknowledgedAt;
  final bool isLocalPending;

  bool get isUnread => acknowledgedAt == null;

  bool get isItemJob =>
      jobType.isItem || (itemId != null && itemId!.trim().isNotEmpty);

  bool get isTryOnJob =>
      jobType.isTryOn || (outfitId != null && outfitId!.trim().isNotEmpty);

  JobEvent copyWith({
    String? eventId,
    JobEventType? jobType,
    JobEventStatus? jobStatus,
    String? wardrobeId,
    String? itemId,
    bool clearItemId = false,
    String? outfitId,
    bool clearOutfitId = false,
    String? renderId,
    bool clearRenderId = false,
    String? aiProfileId,
    bool clearAiProfileId = false,
    String? error,
    bool clearError = false,
    DateTime? createdAt,
    DateTime? acknowledgedAt,
    bool clearAcknowledgedAt = false,
    bool? isLocalPending,
  }) {
    return JobEvent(
      eventId: eventId ?? this.eventId,
      jobType: jobType ?? this.jobType,
      status: jobStatus ?? status,
      wardrobeId: wardrobeId ?? this.wardrobeId,
      itemId: clearItemId ? null : (itemId ?? this.itemId),
      outfitId: clearOutfitId ? null : (outfitId ?? this.outfitId),
      renderId: clearRenderId ? null : (renderId ?? this.renderId),
      aiProfileId: clearAiProfileId ? null : (aiProfileId ?? this.aiProfileId),
      error: clearError ? null : (error ?? this.error),
      createdAt: createdAt ?? this.createdAt,
      acknowledgedAt: clearAcknowledgedAt
          ? null
          : (acknowledgedAt ?? this.acknowledgedAt),
      isLocalPending: isLocalPending ?? this.isLocalPending,
    );
  }

  /// True when [other] is the server event that completes this local PENDING.
  bool matchesPendingCompletion(JobEvent other) {
    if (!isLocalPending || other.isLocalPending) {
      return false;
    }
    if (wardrobeId != other.wardrobeId) {
      return false;
    }
    if (itemId != null && itemId!.isNotEmpty) {
      return other.itemId == itemId;
    }
    if (outfitId != null && outfitId!.isNotEmpty) {
      if (other.outfitId != outfitId) {
        return false;
      }
      if (renderId != null &&
          renderId!.isNotEmpty &&
          other.renderId != null &&
          other.renderId!.isNotEmpty) {
        return other.renderId == renderId;
      }
      if (aiProfileId != null &&
          aiProfileId!.isNotEmpty &&
          other.aiProfileId != null &&
          other.aiProfileId!.isNotEmpty) {
        return other.aiProfileId == aiProfileId;
      }
      return true;
    }
    return false;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is JobEvent &&
            eventId == other.eventId &&
            jobType == other.jobType &&
            status == other.status &&
            wardrobeId == other.wardrobeId &&
            itemId == other.itemId &&
            outfitId == other.outfitId &&
            renderId == other.renderId &&
            aiProfileId == other.aiProfileId &&
            error == other.error &&
            createdAt == other.createdAt &&
            acknowledgedAt == other.acknowledgedAt &&
            isLocalPending == other.isLocalPending;
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    jobType,
    status,
    wardrobeId,
    itemId,
    outfitId,
    renderId,
    aiProfileId,
    error,
    createdAt,
    acknowledgedAt,
    isLocalPending,
  );
}

/// `GET /me/events` envelope.
class JobEventPage {
  const JobEventPage({
    this.events = const [],
    this.unreadCount = 0,
    this.contractUnavailable = false,
  });

  static const empty = JobEventPage();

  static const unavailable = JobEventPage(contractUnavailable: true);

  final List<JobEvent> events;
  final int unreadCount;
  final bool contractUnavailable;
}
