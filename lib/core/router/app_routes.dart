/// Path constants for go_router.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const wardrobes = '/wardrobes';
  static const createWardrobe = '/wardrobes/create';

  static String wardrobeDetail(String wardrobeId) => '/wardrobes/$wardrobeId';

  static const publicRoutes = <String>{login, signup, forgotPassword};
}
