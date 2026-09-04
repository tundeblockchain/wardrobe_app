/// Path constants for go_router.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const wardrobes = '/wardrobes';

  static const publicRoutes = <String>{login, signup, forgotPassword};
}
