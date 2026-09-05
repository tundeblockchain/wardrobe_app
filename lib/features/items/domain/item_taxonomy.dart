import 'item.dart';

/// Controlled colour tokens from WARDROBE-20.
enum ItemColour {
  black('BLACK', 'Black'),
  white('WHITE', 'White'),
  grey('GREY', 'Grey'),
  red('RED', 'Red'),
  blue('BLUE', 'Blue'),
  green('GREEN', 'Green'),
  yellow('YELLOW', 'Yellow'),
  orange('ORANGE', 'Orange'),
  pink('PINK', 'Pink'),
  purple('PURPLE', 'Purple'),
  brown('BROWN', 'Brown'),
  beige('BEIGE', 'Beige'),
  navy('NAVY', 'Navy'),
  cream('CREAM', 'Cream'),
  gold('GOLD', 'Gold'),
  silver('SILVER', 'Silver'),
  burgundy('BURGUNDY', 'Burgundy'),
  khaki('KHAKI', 'Khaki'),
  teal('TEAL', 'Teal'),
  olive('OLIVE', 'Olive'),
  multicolour('MULTICOLOUR', 'Multicolour');

  const ItemColour(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static ItemColour? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.trim().toUpperCase();
    for (final colour in ItemColour.values) {
      if (colour.wireValue == normalized) {
        return colour;
      }
    }
    return null;
  }
}

/// Controlled subcategory tokens from WARDROBE-19.
enum ItemSubcategory {
  tshirt('TSHIRT', 'T-shirt'),
  shirt('SHIRT', 'Shirt'),
  blouse('BLOUSE', 'Blouse'),
  polo('POLO', 'Polo'),
  sweater('SWEATER', 'Sweater'),
  hoodie('HOODIE', 'Hoodie'),
  jeans('JEANS', 'Jeans'),
  trousers('TROUSERS', 'Trousers'),
  shorts('SHORTS', 'Shorts'),
  skirt('SKIRT', 'Skirt'),
  dress('DRESS', 'Dress'),
  jumpsuit('JUMPSUIT', 'Jumpsuit'),
  romper('ROMPER', 'Romper'),
  jacket('JACKET', 'Jacket'),
  coat('COAT', 'Coat'),
  blazer('BLAZER', 'Blazer'),
  sneakers('SNEAKERS', 'Sneakers'),
  boots('BOOTS', 'Boots'),
  heels('HEELS', 'Heels'),
  sandals('SANDALS', 'Sandals'),
  flats('FLATS', 'Flats'),
  hat('HAT', 'Hat'),
  belt('BELT', 'Belt'),
  scarf('SCARF', 'Scarf'),
  jewelry('JEWELRY', 'Jewelry'),
  sunglasses('SUNGLASSES', 'Sunglasses'),
  watch('WATCH', 'Watch'),
  handbag('HANDBAG', 'Handbag'),
  backpack('BACKPACK', 'Backpack'),
  tote('TOTE', 'Tote'),
  clutch('CLUTCH', 'Clutch'),
  crossbody('CROSSBODY', 'Crossbody');

  const ItemSubcategory(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static ItemSubcategory? tryParse(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final normalized = value.trim().toUpperCase();
    for (final subcategory in ItemSubcategory.values) {
      if (subcategory.wireValue == normalized) {
        return subcategory;
      }
    }
    return null;
  }

  static List<ItemSubcategory> forCategory(ItemCategory category) {
    return List<ItemSubcategory>.unmodifiable(
      _subcategoriesByCategory[category] ?? const [],
    );
  }
}

const _subcategoriesByCategory = <ItemCategory, List<ItemSubcategory>>{
  ItemCategory.top: [
    ItemSubcategory.tshirt,
    ItemSubcategory.shirt,
    ItemSubcategory.blouse,
    ItemSubcategory.polo,
    ItemSubcategory.sweater,
    ItemSubcategory.hoodie,
  ],
  ItemCategory.bottom: [
    ItemSubcategory.jeans,
    ItemSubcategory.trousers,
    ItemSubcategory.shorts,
    ItemSubcategory.skirt,
  ],
  ItemCategory.dress: [
    ItemSubcategory.dress,
    ItemSubcategory.jumpsuit,
    ItemSubcategory.romper,
  ],
  ItemCategory.outerwear: [
    ItemSubcategory.jacket,
    ItemSubcategory.coat,
    ItemSubcategory.blazer,
  ],
  ItemCategory.shoes: [
    ItemSubcategory.sneakers,
    ItemSubcategory.boots,
    ItemSubcategory.heels,
    ItemSubcategory.sandals,
    ItemSubcategory.flats,
  ],
  ItemCategory.accessory: [
    ItemSubcategory.hat,
    ItemSubcategory.belt,
    ItemSubcategory.scarf,
    ItemSubcategory.jewelry,
    ItemSubcategory.sunglasses,
    ItemSubcategory.watch,
  ],
  ItemCategory.bag: [
    ItemSubcategory.handbag,
    ItemSubcategory.backpack,
    ItemSubcategory.tote,
    ItemSubcategory.clutch,
    ItemSubcategory.crossbody,
  ],
};
