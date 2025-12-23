import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final int particleCount;
  final List<Color> particleColors;
  final double speed;
  final double particleSize;
  final Widget child;

  const ParticleBackground({
    super.key,
    this.particleCount = 100,
    this.particleColors = const [Colors.white],
    this.speed = 0.5,
    this.particleSize = 2.0,
    required this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _initParticles();
  }

  void _initParticles() {
    final random = math.Random();
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        vx: (random.nextDouble() - 0.5) * widget.speed * 0.01,
        vy: (random.nextDouble() - 0.5) * widget.speed * 0.01,
        size: widget.particleSize + random.nextDouble() * widget.particleSize,
        color: widget.particleColors[random.nextInt(widget.particleColors.length)],
        opacity: 0.3 + random.nextDouble() * 0.4,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Update particle positions
            for (var particle in _particles) {
              particle.x += particle.vx;
              particle.y += particle.vy;

              // Wrap around edges
              if (particle.x < 0) particle.x = 1;
              if (particle.x > 1) particle.x = 0;
              if (particle.y < 0) particle.y = 1;
              if (particle.y > 1) particle.y = 0;
            }

            return CustomPaint(
              painter: ParticlePainter(particles: _particles),
              child: Container(),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  Color color;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );

      // Draw particle with glow effect
      final glowPaint = Paint()
        ..color = particle.color.withOpacity(particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(position, particle.size * 2, glowPaint);
      canvas.drawCircle(position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
