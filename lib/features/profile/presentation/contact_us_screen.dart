import 'package:flutter/material.dart';

import '../domain/support_form_kind.dart';
import 'widgets/support_form.dart';

/// In-app contact form. Posts to `POST /support/contact` only.
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportForm(kind: SupportFormKind.contact);
  }
}
