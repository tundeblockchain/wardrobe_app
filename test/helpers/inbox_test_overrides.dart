import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:wardrobe_app/features/inbox/application/device_registration_controller.dart';
import 'package:wardrobe_app/features/inbox/application/inbox_poll.dart';
import 'package:wardrobe_app/features/inbox/data/dio_device_repository.dart';
import 'package:wardrobe_app/features/inbox/data/dio_job_event_repository.dart';

import 'fake_device_repository.dart';
import 'fake_job_event_repository.dart';

/// Empty inbox + no-op FCM so widget tests never hit live Dio or Messaging.
List<Override> inboxTestOverrides({
  FakeJobEventRepository? events,
  FakeDeviceRepository? devices,
  FakePushTokenSource? push,
}) {
  return [
    jobEventRepositoryProvider.overrideWithValue(
      events ?? FakeJobEventRepository(),
    ),
    deviceRepositoryProvider.overrideWithValue(
      devices ?? FakeDeviceRepository(),
    ),
    pushTokenSourceProvider.overrideWithValue(push ?? FakePushTokenSource()),
    inboxPollConfigProvider.overrideWithValue(
      const InboxPollConfig(interval: Duration(days: 1)),
    ),
    inboxDelayProvider.overrideWithValue((_) {
      return Completer<void>().future;
    }),
  ];
}
