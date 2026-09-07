import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether user-scoped controllers may hit the API.
///
/// Starts [SessionGatePhase.unknown] so unit tests that never sign in still
/// load lists. Sign-out sets [SessionGatePhase.signedOut] so keep-alive
/// screens (Profile pushed over Wardrobes) cannot refetch the prior account.
enum SessionGatePhase { unknown, signedOut, signedIn }

/// Signed-in uid plus phase used to drop leftover Riverpod caches.
class SessionGate {
  const SessionGate({this.phase = SessionGatePhase.unknown, this.uid});

  final SessionGatePhase phase;
  final String? uid;

  /// `false` only after an explicit sign-out / session drop.
  bool get allowUserDataFetch => phase != SessionGatePhase.signedOut;

  /// Identity token for controllers that must rebuild per account.
  Object get cacheKey => uid ?? phase;
}

class SessionGateController extends Notifier<SessionGate> {
  @override
  SessionGate build() => const SessionGate();

  void markSignedIn(String uid) {
    state = SessionGate(phase: SessionGatePhase.signedIn, uid: uid);
  }

  void markSignedOut() {
    state = const SessionGate(phase: SessionGatePhase.signedOut);
  }
}

final sessionGateProvider =
    NotifierProvider<SessionGateController, SessionGate>(
      SessionGateController.new,
    );

/// `false` after sign-out so keep-alive list controllers do not refetch.
bool watchAllowsUserDataFetch(Ref ref) {
  return ref.watch(sessionGateProvider.select((s) => s.allowUserDataFetch));
}
