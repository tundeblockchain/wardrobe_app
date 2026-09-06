/// Presentation-level validators for contact / bug-report forms.
abstract final class SupportValidators {
  static const maxSubjectLength = 120;
  static const minMessageLength = 10;
  static const maxMessageLength = 4000;

  static String? subject(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter a subject.';
    }
    if (trimmed.length > maxSubjectLength) {
      return 'Subject must be $maxSubjectLength characters or fewer.';
    }
    return null;
  }

  static String? message(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Enter a message.';
    }
    if (trimmed.length < minMessageLength) {
      return 'Message must be at least $minMessageLength characters.';
    }
    if (trimmed.length > maxMessageLength) {
      return 'Message must be $maxMessageLength characters or fewer.';
    }
    return null;
  }
}
