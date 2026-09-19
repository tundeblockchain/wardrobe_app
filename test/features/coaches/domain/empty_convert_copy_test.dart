import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/coaches/domain/empty_convert_copy.dart';

void main() {
  test('home and wardrobe convert copy stay short', () {
    expect(EmptyConvertCopy.homeTitle, isNotEmpty);
    expect(EmptyConvertCopy.wardrobeTitle, isNotEmpty);
    expect(EmptyConvertCopy.homeTitle, isNot(EmptyConvertCopy.wardrobeTitle));
    expect(EmptyConvertCopy.homeBody.length, lessThan(180));
    expect(EmptyConvertCopy.wardrobeBody.length, lessThan(180));
    expect(EmptyConvertCopy.homeAction, 'Create wardrobe');
    expect(EmptyConvertCopy.wardrobePrimary, 'Add from gallery');
    expect(EmptyConvertCopy.wardrobeSecondary, 'Take a photo');
  });
}
