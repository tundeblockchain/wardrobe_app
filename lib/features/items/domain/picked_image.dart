import 'dart:typed_data';

/// Local photo chosen from camera or gallery. Not a backend DTO.
class PickedImage {
  const PickedImage({
    required this.bytes,
    required this.contentType,
    this.fileName,
  });

  final Uint8List bytes;
  final String contentType;
  final String? fileName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PickedImage &&
            contentType == other.contentType &&
            fileName == other.fileName &&
            _bytesEqual(bytes, other.bytes);
  }

  @override
  int get hashCode => Object.hash(contentType, fileName, Object.hashAll(bytes));
}

bool _bytesEqual(Uint8List a, Uint8List b) {
  if (identical(a, b)) {
    return true;
  }
  if (a.length != b.length) {
    return false;
  }
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }
  return true;
}
