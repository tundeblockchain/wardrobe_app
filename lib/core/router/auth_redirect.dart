import 'app_routes.dart';

/// Session used by the router redirect. Independent of Riverpod/Firebase.
enum AuthStatus { unknown, authenticated, unauthenticated }

/// Pure redirect rules for the auth shell.
///
/// - [AuthStatus.unknown]: stay on splash while restoring the session.
/// - [AuthStatus.unauthenticated]: send protected routes to `/login`.
/// - [AuthStatus.authenticated]: send public/splash routes to `/wardrobes`.
///
/// Returns `null` when the current location is already correct.
String? resolveAuthRedirect({
  required AuthStatus status,
  required String location,
}) {
  final normalized = _normalize(location);

  switch (status) {
    case AuthStatus.unknown:
      return normalized == AppRoutes.splash ? null : AppRoutes.splash;
    case AuthStatus.unauthenticated:
      if (AppRoutes.publicRoutes.contains(normalized)) {
        return null;
      }
      return AppRoutes.login;
    case AuthStatus.authenticated:
      if (normalized == AppRoutes.splash ||
          AppRoutes.publicRoutes.contains(normalized)) {
        return AppRoutes.wardrobes;
      }
      return null;
  }
}

String _normalize(String location) {
  if (location.isEmpty) {
    return AppRoutes.splash;
  }
  if (location.length > 1 && location.endsWith('/')) {
    return location.substring(0, location.length - 1);
  }
  return location;
}
