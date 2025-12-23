import 'package:flutter/material.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';
import 'package:focustrophy/features/timer/widgets/glowing_timer_ring.dart';
import 'package:focustrophy/shared/widgets/glass_card.dart';

class CircularTimer extends StatelessWidget {
  final TimerState state;

  const CircularTimer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor = state.selectedSubject != null
        ? Color(state.selectedSubject!.colorHex)
        : const Color(0xFF6366F1);

    return SizedBox(
      width: 320,
      height: 320,
      child: GlowingTimerRing(
        progress: state.progress,
        color: subjectColor,
        duration: state.displayTime,
        isPulsing: state.penaltyTime > Duration.zero,
        child: Center(
          child: GlassCard(
            borderRadius: 160,
            padding: const EdgeInsets.all(40),
            border: Border.all(
              color: subjectColor.withOpacity(0.2),
              width: 1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(state.displayTime),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 64,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getStatusText(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                  ),
                ),
                if (state.selectedSubject != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: subjectColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: subjectColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      state.selectedSubject!.name,
                      style: TextStyle(
                        fontSize: 14,
                        color: subjectColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getStatusText() {
    switch (state.status) {
      case TimerStatus.initial:
        return 'Ready to focus';
      case TimerStatus.running:
        if (state.isBreak) {
          return 'Break Time';
        } else {
          return 'Focus Mode';
        }
      case TimerStatus.paused:
        return 'Paused';
      case TimerStatus.breakTime:
        return 'Break Time';
      case TimerStatus.completed:
        return 'Session Complete!';
      case TimerStatus.cancelled:
        return 'Session Cancelled';
    }
  }
}