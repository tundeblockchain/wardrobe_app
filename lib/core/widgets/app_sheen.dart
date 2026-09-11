import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// One-shot diagonal sheen. Completes so [WidgetTester.pumpAndSettle] is safe.
class AppSheenSweep extends StatefulWidget {
  const AppSheenSweep({super.key});

  static const sheenKey = Key('app_sheen_sweep');

  @override
  State<AppSheenSweep> createState() => _AppSheenSweepState();
}

class _AppSheenSweepState extends State<AppSheenSweep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.sheenDuration,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) {
      return;
    }
    _started = true;
    if (AppMotion.reduce(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (AppMotion.reduce(context)) {
      return const SizedBox.shrink(key: AppSheenSweep.sheenKey);
    }
    final scheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = AppMotion.sheenCurve.transform(_controller.value);
          return OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: Align(
              alignment: Alignment(-1.35 + (2.7 * t), -1.15 + (2.3 * t)),
              child: Transform.rotate(
                angle: 0.5,
                child: SizedBox(
                  key: AppSheenSweep.sheenKey,
                  width: 56,
                  height: 220,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withValues(alpha: 0),
                          Colors.white.withValues(
                            alpha: AppMotion.sheenPeakOpacity,
                          ),
                          scheme.primary.withValues(alpha: 0.04),
                          Colors.white.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
