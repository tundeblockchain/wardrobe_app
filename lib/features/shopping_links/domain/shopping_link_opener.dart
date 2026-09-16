/// Opens a shopping URL outside the app.
abstract interface class ShoppingLinkOpener {
  Future<bool> open(Uri url);
}
