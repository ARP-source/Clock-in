import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class TransitionFlash extends StatefulWidget {
  final Color flashColor;
  final VoidCallback onComplete;
  final Widget child;

  const TransitionFlash({
    super.key,
    required this.flashColor,
    required this.onComplete,
    required this.child,
  });

  @override
  State<TransitionFlash> createState() => _TransitionFlashState();
}

class _TransitionFlashState extends State<TransitionFlash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _flashCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _flashCount++;
        if (_flashCount < 3) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _controller.forward();
              _playBeepAndVibrate();
            }
          });
        } else {
          widget.onComplete();
        }
      }
    });

    // Start the first flash
    _controller.forward();
    _playBeepAndVibrate();
  }

  Future<void> _playBeepAndVibrate() async {
    // Play beep sound (using system sound for now)
    try {
      await SystemSound.play(SystemSoundType.click);
    } catch (e) {
      // Ignore if sound fails
    }

    // Vibrate
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: 200);
      } else {
        // Fallback to haptic feedback
        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      // Fallback to haptic feedback if vibration fails
      HapticFeedback.heavyImpact();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              color: widget.flashColor.withOpacity(_animation.value),
            );
          },
        ),
      ],
    );
  }
}
