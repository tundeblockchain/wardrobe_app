/// Path constants for go_router.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const wardrobes = '/wardrobes';
  static const createWardrobe = '/wardrobes/create';

  static String wardrobeDetail(String wardrobeId) => '/wardrobes/$wardrobeId';

  static String createItem(String wardrobeId) =>
      '/wardrobes/$wardrobeId/items/create';

  static String itemDetail(String wardrobeId, String itemId) =>
      '/wardrobes/$wardrobeId/items/$itemId';

  static String editItem(String wardrobeId, String itemId) =>
      '/wardrobes/$wardrobeId/items/$itemId/edit';

  static String outfits(String wardrobeId) => '/wardrobes/$wardrobeId/outfits';

  static String createOutfit(String wardrobeId) =>
      '/wardrobes/$wardrobeId/outfits/create';

  static String outfitDetail(String wardrobeId, String outfitId) =>
      '/wardrobes/$wardrobeId/outfits/$outfitId';

  static String editOutfit(String wardrobeId, String outfitId) =>
      '/wardrobes/$wardrobeId/outfits/$outfitId/edit';

  static String recommendations(String wardrobeId) =>
      '/wardrobes/$wardrobeId/recommendations';

  static String recommendationDetail(String wardrobeId, int index) =>
      '/wardrobes/$wardrobeId/recommendations/$index';

  static const publicRoutes = <String>{login, signup, forgotPassword};
}
