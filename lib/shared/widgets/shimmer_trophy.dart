import 'package:flutter/material.dart';

class ShimmerTrophy extends StatefulWidget {
  final IconData icon;
  final double size;
  
  const ShimmerTrophy({
    super.key,
    required this.icon,
    this.size = 120,
  });

  @override
  State<ShimmerTrophy> createState() => _ShimmerTrophyState();
}

class _ShimmerTrophyState extends State<ShimmerTrophy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFFFFD700), // Gold
                Color(0xFFFFEEAD), // Pale Highlight
                Color(0xFFFFD700), // Gold
              ],
              stops: [
                (_controller.value - 0.3).clamp(0.0, 1.0),
                _controller.value,
                (_controller.value + 0.3).clamp(0.0, 1.0),
              ],
              tileMode: TileMode.clamp,
            ).createShader(bounds);
          },
          child: Icon(
            widget.icon,
            size: widget.size,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
