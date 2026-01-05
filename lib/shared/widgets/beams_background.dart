import 'dart:math' as math;
import 'package:flutter/material.dart';

class BeamsBackground extends StatefulWidget {
  final Widget child;
  final int beamNumber;
  final double beamWidth;
  final double beamHeight;
  final Color lightColor;
  final double speed;
  final double noiseIntensity;
  final double scale;
  final double rotation;

  const BeamsBackground({
    super.key,
    required this.child,
    this.beamNumber = 12,
    this.beamWidth = 2,
    this.beamHeight = 15,
    this.lightColor = Colors.white,
    this.speed = 2,
    this.noiseIntensity = 1.75,
    this.scale = 0.2,
    this.rotation = 0,
  });

  @override
  State<BeamsBackground> createState() => _BeamsBackgroundState();
}

class _BeamsBackgroundState extends State<BeamsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<BeamModel> _beams = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _generateBeams();
  }

  void _generateBeams() {
    final random = math.Random();
    for (int i = 0; i < widget.beamNumber; i++) {
      _beams.add(BeamModel(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: (random.nextDouble() * 0.5 + 0.5) * widget.speed,
        opacity: random.nextDouble() * 0.5 + 0.2,
        length: (random.nextDouble() * 0.5 + 0.5) * widget.beamHeight * 50,
        width: (random.nextDouble() * 0.5 + 0.5) * widget.beamWidth,
      ));
    }
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
        Positioned.fill(
          child: Container(
            color: const Color(0xFF0F0F12),
          ),
        ),
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: BeamsPainter(
                  beams: _beams,
                  progress: _controller.value,
                  lightColor: widget.lightColor,
                  noiseIntensity: widget.noiseIntensity,
                  scale: widget.scale,
                  rotation: widget.rotation,
                ),
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class BeamModel {
  double x;
  double y;
  double speed;
  double opacity;
  double length;
  double width;

  BeamModel({
    required this.x,
    required this.y,
    required this.speed,
    required this.opacity,
    required this.length,
    required this.width,
  });
}

class BeamsPainter extends CustomPainter {
  final List<BeamModel> beams;
  final double progress;
  final Color lightColor;
  final double noiseIntensity;
  final double scale;
  final double rotation;

  BeamsPainter({
    required this.beams,
    required this.progress,
    required this.lightColor,
    required this.noiseIntensity,
    required this.scale,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation * math.pi / 180);
    // Use the scale provided by the user (0.2) but ensure it's visible
    canvas.scale(scale + 1.0); 
    canvas.translate(-size.width / 2, -size.height / 2);

    for (var beam in beams) {
      // Calculate movement based on progress and speed
      // We use a larger range to ensure beams enter and exit smoothly
      double currentY = (beam.y + (progress * beam.speed * 0.2)) % 1.5 - 0.25;
      double xPos = beam.x * size.width;
      double yPos = currentY * size.height;

      // Add some "noise" movement as requested
      double noiseX = math.sin(progress * 2 * math.pi + beam.x * 20) * noiseIntensity * 5;
      xPos += noiseX;

      final rect = Rect.fromLTWH(
        xPos - beam.width / 2,
        yPos,
        beam.width,
        beam.length,
      );

      paint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lightColor.withOpacity(0),
          lightColor.withOpacity(beam.opacity * 0.5), // Softer beams
          lightColor.withOpacity(0),
        ],
      ).createShader(rect);

      paint.strokeWidth = beam.width;
      // Draw the beam with a slight glow effect
      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + beam.length),
        paint,
      );
      
      // Optional: Add a very faint glow
      final glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = beam.width * 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      
      glowPaint.shader = paint.shader;
      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + beam.length),
        glowPaint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant BeamsPainter oldDelegate) => true;
}
