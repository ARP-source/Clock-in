import 'dart:math' as math;
import 'package:flutter/material.dart';

class GlowingTimerRing extends StatefulWidget {
  final double progress;
  final Color color;
  final Duration duration;
  final Widget child;
  final bool isPulsing;

  const GlowingTimerRing({
    super.key,
    required this.progress,
    required this.color,
    required this.duration,
    required this.child,
    this.isPulsing = false,
  });

  @override
  State<GlowingTimerRing> createState() => _GlowingTimerRingState();
}

class _GlowingTimerRingState extends State<GlowingTimerRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GlowingTimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !oldWidget.isPulsing) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPulsing && oldWidget.isPulsing) {
      _pulseController.stop();
      _pulseController.value = 0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlowingRingPainter(
            progress: widget.progress,
            color: widget.color,
            pulseScale: widget.isPulsing ? _pulseAnimation.value : 1.0,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _GlowingRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double pulseScale;

  _GlowingRingPainter({
    required this.progress,
    required this.color,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 40;
    final strokeWidth = 12.0;

    // Background ring (subtle)
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Outer glow layers (multiple layers for depth)
    for (int i = 3; i >= 1; i--) {
      final glowPaint = Paint()
        ..color = color.withOpacity(0.1 * i * pulseScale)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + (i * 8)
        ..strokeCap = StrokeCap.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10.0 * i);

      final sweepAngle = 2 * math.pi * progress;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        sweepAngle,
        false,
        glowPaint,
      );
    }

    // Main progress ring
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = 2 * math.pi * progress;
    
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        sweepAngle,
        false,
        progressPaint,
      );
    }

    // End cap highlight (glowing dot at the end)
    if (progress > 0) {
      final endAngle = -math.pi / 2 + sweepAngle;
      final endPoint = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      // Outer glow for end cap
      final endCapGlowPaint = Paint()
        ..color = color.withOpacity(0.4 * pulseScale)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawCircle(endPoint, 8, endCapGlowPaint);

      // End cap
      final endCapPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(endPoint, 4, endCapPaint);
    }
  }

  @override
  bool shouldRepaint(_GlowingRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.pulseScale != pulseScale;
  }
}
