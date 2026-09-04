import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/image_picker_item_image_picker.dart';

void main() {
  test('prefers a real image mime type', () {
    expect(
      inferImageContentType(mimeType: 'image/png', fileName: 'x.jpg'),
      'image/png',
    );
    expect(inferImageContentType(mimeType: 'image/jpg'), 'image/jpeg');
  });

  test('falls back to file extension then jpeg', () {
    expect(inferImageContentType(fileName: 'shot.WEBP'), 'image/webp');
    expect(inferImageContentType(path: 'img.heic'), 'image/heic');
    expect(inferImageContentType(), 'image/jpeg');
  });
}
