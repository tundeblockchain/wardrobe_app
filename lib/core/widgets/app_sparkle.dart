import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_motion.dart';

/// Light four-point sparkles. One-shot, then a faint rest opacity.
class AppSparkleAccent extends StatefulWidget {
  const AppSparkleAccent({super.key, this.count = 5});

  static const sparkleKey = Key('app_sparkle_accent');

  final int count;

  @override
  State<AppSparkleAccent> createState() => _AppSparkleAccentState();
}

class _AppSparkleAccentState extends State<AppSparkleAccent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.sparkleDuration,
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
    final scheme = Theme.of(context).colorScheme;
    final color = Color.lerp(
      Colors.white,
      scheme.primaryContainer,
      scheme.brightness == Brightness.dark ? 0.25 : 0.12,
    )!;
    if (AppMotion.reduce(context)) {
      return IgnorePointer(
        child: CustomPaint(
          key: AppSparkleAccent.sparkleKey,
          painter: _SparklePainter(
            progress: 1,
            color: color,
            count: widget.count,
            animated: false,
          ),
          child: const SizedBox.expand(),
        ),
      );
    }
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            key: AppSparkleAccent.sparkleKey,
            painter: _SparklePainter(
              progress: _controller.value,
              color: color,
              count: widget.count,
              animated: true,
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({
    required this.progress,
    required this.color,
    required this.count,
    required this.animated,
  });

  final double progress;
  final Color color;
  final int count;
  final bool animated;

  static const _anchors = [
    Offset(0.16, 0.20),
    Offset(0.84, 0.16),
    Offset(0.90, 0.58),
    Offset(0.12, 0.74),
    Offset(0.52, 0.10),
    Offset(0.72, 0.82),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) {
      return;
    }
    final paint = Paint()..style = PaintingStyle.fill;
    final n = math.min(count, _anchors.length);
    for (var i = 0; i < n; i++) {
      final phase = (i * 0.13) % 1;
      final peak = animated
          ? math.sin((progress + phase) * math.pi).clamp(0.0, 1.0)
          : 0.0;
      final opacity =
          AppMotion.sparkleRestOpacity +
          (AppMotion.sparklePeakOpacity - AppMotion.sparkleRestOpacity) * peak;
      paint.color = color.withValues(alpha: opacity);
      final origin = Offset(
        _anchors[i].dx * size.width,
        _anchors[i].dy * size.height,
      );
      final radius = 3.2 + (i.isEven ? 1.1 : 0.0);
      _drawStar(canvas, origin, radius, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx + radius * 0.22, center.dy - radius * 0.22)
      ..lineTo(center.dx + radius, center.dy)
      ..lineTo(center.dx + radius * 0.22, center.dy + radius * 0.22)
      ..lineTo(center.dx, center.dy + radius)
      ..lineTo(center.dx - radius * 0.22, center.dy + radius * 0.22)
      ..lineTo(center.dx - radius, center.dy)
      ..lineTo(center.dx - radius * 0.22, center.dy - radius * 0.22)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.count != count ||
        oldDelegate.animated != animated;
  }
}
