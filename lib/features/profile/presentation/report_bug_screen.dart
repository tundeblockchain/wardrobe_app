import 'package:flutter/material.dart';

import '../domain/support_form_kind.dart';
import 'widgets/support_form.dart';

/// In-app bug report. Posts to `POST /support/bug` with device/app context.
class ReportBugScreen extends StatelessWidget {
  const ReportBugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SupportForm(kind: SupportFormKind.bug);
  }
}
