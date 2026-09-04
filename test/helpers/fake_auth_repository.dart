import 'dart:async';

import 'package:wardrobe_app/features/auth/domain/app_user.dart';
import 'package:wardrobe_app/features/auth/domain/auth_failure.dart';
import 'package:wardrobe_app/features/auth/domain/auth_repository.dart';

/// In-memory [AuthRepository] for unit and widget tests.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AppUser? initialUser}) : _current = initialUser;

  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _current;
  AuthFailure? nextFailure;
  Duration delay = Duration.zero;

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signIn({required String email, required String password}) {
    return _authenticate(email);
  }

  @override
  Future<AppUser> signUp({required String email, required String password}) {
    return _authenticate(email);
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _maybeFail();
  }

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(delay);
    _emit(null);
  }

  Future<AppUser> _authenticate(String email) async {
    await _maybeFail();
    final user = AppUser(uid: 'uid-${email.hashCode}', email: email.trim());
    _emit(user);
    return user;
  }

  Future<void> _maybeFail() async {
    await Future<void>.delayed(delay);
    final failure = nextFailure;
    if (failure != null) {
      nextFailure = null;
      throw failure;
    }
  }

  void _emit(AppUser? user) {
    _current = user;
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }
}
