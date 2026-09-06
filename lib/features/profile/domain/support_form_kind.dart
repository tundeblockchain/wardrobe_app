/// Which support form the user is filling in.
enum SupportFormKind {
  contact,
  bug;

  String get title => switch (this) {
    SupportFormKind.contact => 'Contact us',
    SupportFormKind.bug => 'Report a bug',
  };

  String get subtitle => switch (this) {
    SupportFormKind.contact =>
      'Send a message to the Wardrobe team. We read every note.',
    SupportFormKind.bug =>
      'Tell us what went wrong. Include enough detail to reproduce it.',
  };

  String get submitLabel => switch (this) {
    SupportFormKind.contact => 'Send message',
    SupportFormKind.bug => 'Submit report',
  };

  String get successMessage => switch (this) {
    SupportFormKind.contact => 'Message sent. Thanks for getting in touch.',
    SupportFormKind.bug => 'Bug report sent. Thanks for the details.',
  };
}
