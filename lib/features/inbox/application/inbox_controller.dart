import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/lifecycle/app_lifecycle.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/session/session_gate.dart';
import '../../items/domain/item.dart';
import '../../outfits/domain/outfit_render.dart';
import '../data/dio_job_event_repository.dart';
import '../domain/inbox_contract.dart';
import '../domain/inbox_deep_link.dart';
import '../domain/job_event.dart';
import '../domain/job_event_repository.dart';
import 'inbox_poll.dart';
import 'inbox_state.dart';

/// Lists / acks job-done events and keeps local PENDING tray rows.
class InboxController extends Notifier<InboxState> {
  bool _polling = false;
  bool _inboxVisible = false;
  bool _refreshing = false;

  @override
  InboxState build() {
    if (!watchAllowsUserDataFetch(ref)) {
      return const InboxState();
    }
    ref.listen<int>(appLifecycleTickProvider, (previous, next) {
      if (previous != null && previous != next) {
        refresh();
      }
    });
    return const InboxState();
  }

  JobEventRepository get _repository => ref.read(jobEventRepositoryProvider);

  void setInboxVisible(bool visible) {
    _inboxVisible = visible;
    if (visible) {
      _ensurePolling();
    }
  }

  /// After Premium `POST` item, keep a local PENDING row until an event lands.
  void trackPendingItem(Item item) {
    if (!item.processingStatus.isInProgress) {
      return;
    }
    _upsertPending(
      JobEvent(
        eventId: 'local_item_${item.id}',
        jobType: JobEventType.processWardrobeItem,
        status: JobEventStatus.pending,
        wardrobeId: item.wardrobeId,
        itemId: item.id,
        createdAt: item.createdAt,
        isLocalPending: true,
      ),
    );
  }

  /// After `POST .../render`, keep a local PENDING row until an event lands.
  void trackPendingRender({
    required String wardrobeId,
    required String outfitId,
    required OutfitRender render,
  }) {
    if (!render.status.isInProgress) {
      return;
    }
    _upsertPending(
      JobEvent(
        eventId: 'local_render_${outfitId}_${render.aiProfileId}',
        jobType: JobEventType.renderOutfit,
        status: JobEventStatus.pending,
        wardrobeId: wardrobeId,
        outfitId: outfitId,
        aiProfileId: render.aiProfileId,
        createdAt: DateTime.now().toUtc(),
        isLocalPending: true,
      ),
    );
  }

  void applyPushData(Map<String, String> data) {
    final event = InboxDeepLink.fromPushData(data);
    if (event == null) {
      return;
    }
    mergeEvent(event);
  }

  void mergeEvent(JobEvent event) {
    final next = [
      event,
      for (final existing in state.events)
        if (existing.eventId != event.eventId) existing,
    ];
    final pending = [
      for (final row in state.pending)
        if (!row.matchesPendingCompletion(event)) row,
    ];
    state = state.copyWith(
      events: next,
      pending: pending,
      unreadCount: next.where((row) => row.isUnread).length,
      contractUnavailable: false,
      clearError: true,
    );
    if (pending.isNotEmpty) {
      _ensurePolling();
    }
  }

  Future<void> refresh() async {
    if (_refreshing) {
      return;
    }
    _refreshing = true;
    final showSpinner = state.events.isEmpty && state.pending.isEmpty;
    state = state.copyWith(
      isLoading: showSpinner,
      isRefreshing: !showSpinner,
      clearError: true,
    );
    try {
      final page = await _repository.listEvents(
        unreadOnly: InboxContract.defaultUnreadOnly,
        limit: InboxContract.defaultLimit,
      );
      if (!ref.mounted) {
        return;
      }
      final pending = [
        for (final row in state.pending)
          if (!page.events.any(row.matchesPendingCompletion)) row,
      ];
      state = state.copyWith(
        events: page.events,
        pending: pending,
        unreadCount: page.unreadCount,
        isLoading: false,
        isRefreshing: false,
        contractUnavailable: page.contractUnavailable,
      );
      if (pending.isNotEmpty || _inboxVisible) {
        _ensurePolling();
      }
    } on ApiException catch (error) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: error.message,
      );
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
    } finally {
      _refreshing = false;
    }
  }

  Future<void> open(JobEvent event) async {
    if (event.isLocalPending) {
      return;
    }
    await acknowledge(event.eventId);
  }

  Future<void> dismiss(JobEvent event) async {
    if (event.isLocalPending) {
      state = state.copyWith(
        pending: [
          for (final row in state.pending)
            if (row.eventId != event.eventId) row,
        ],
      );
      return;
    }
    await acknowledge(event.eventId);
  }

  Future<void> acknowledge(String eventId) async {
    if (eventId.startsWith('local_')) {
      return;
    }
    try {
      final acked = await _repository.acknowledge(eventId);
      if (!ref.mounted) {
        return;
      }
      _replaceEvent(acked);
    } on ApiException catch (error) {
      if (error.statusCode == 404 ||
          error.code == InboxContract.eventNotFound) {
        if (!ref.mounted) {
          return;
        }
        _dropEvent(eventId);
        return;
      }
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(errorMessage: error.message);
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = state.copyWith(
        errorMessage: 'Could not dismiss this update. Please try again.',
      );
    }
  }

  void _upsertPending(JobEvent event) {
    final pending = [
      event,
      for (final existing in state.pending)
        if (existing.eventId != event.eventId) existing,
    ];
    state = state.copyWith(pending: pending, clearError: true);
  }

  void _replaceEvent(JobEvent event) {
    final events = [
      for (final existing in state.events)
        if (existing.eventId == event.eventId) event else existing,
    ];
    if (!events.any((row) => row.eventId == event.eventId)) {
      events.insert(0, event);
    }
    state = state.copyWith(
      events: [
        for (final row in events)
          if (row.isUnread) row,
      ],
      unreadCount: [
        for (final row in events)
          if (row.isUnread) row,
      ].length,
      clearError: true,
    );
  }

  void _dropEvent(String eventId) {
    final events = [
      for (final row in state.events)
        if (row.eventId != eventId) row,
    ];
    state = state.copyWith(
      events: events,
      unreadCount: events.where((row) => row.isUnread).length,
      clearError: true,
    );
  }

  void _ensurePolling() {
    if (_polling) {
      return;
    }
    _polling = true;
    Future<void>(_pollLoop);
  }

  Future<void> _pollLoop() async {
    try {
      while (ref.mounted && (state.hasPending || _inboxVisible)) {
        final delay = ref.read(inboxDelayProvider);
        final config = ref.read(inboxPollConfigProvider);
        await delay(config.interval);
        if (!ref.mounted) {
          return;
        }
        await refresh();
      }
    } finally {
      _polling = false;
    }
  }
}

final inboxControllerProvider = NotifierProvider<InboxController, InboxState>(
  InboxController.new,
);
