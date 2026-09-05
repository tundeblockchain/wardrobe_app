import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Increments when the app returns to [AppLifecycleState.resumed].
class AppLifecycleTick extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final appLifecycleTickProvider = NotifierProvider<AppLifecycleTick, int>(
  AppLifecycleTick.new,
);

/// Forwards app-resume events into [appLifecycleTickProvider].
class LifecycleRefreshBinder extends ConsumerStatefulWidget {
  const LifecycleRefreshBinder({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LifecycleRefreshBinder> createState() =>
      _LifecycleRefreshBinderState();
}

class _LifecycleRefreshBinderState extends ConsumerState<LifecycleRefreshBinder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appLifecycleTickProvider.notifier).bump();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
