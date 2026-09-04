import 'package:flutter_test/flutter_test.dart';
import 'package:wardrobe_app/features/items/data/upload_dtos.dart';

void main() {
  test('CreateUploadRequest defaults purpose to WARDROBE_ITEM', () {
    expect(const CreateUploadRequest(contentType: 'image/jpeg').toJson(), {
      'contentType': 'image/jpeg',
      'purpose': 'WARDROBE_ITEM',
    });
  });

  test('UploadTicketResponse maps onto the domain ticket', () {
    final ticket = UploadTicketResponse.fromJson({
      'uploadUrl': 'https://s3.example.com/put',
      'objectKey': 'users/uid/uploads/uuid.jpg',
      'expiresIn': 900,
    }).toDomain();

    expect(ticket.uploadUrl, 'https://s3.example.com/put');
    expect(ticket.objectKey, 'users/uid/uploads/uuid.jpg');
    expect(ticket.expiresIn, 900);
  });
}
