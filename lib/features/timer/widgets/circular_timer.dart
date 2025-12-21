import 'package:flutter/material.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';

class CircularTimer extends StatelessWidget {
  final TimerState state;

  const CircularTimer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle (inner circle)
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getInnerCircleColor(),
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 2,
              ),
            ),
          ),
          
          // Progress ring
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: state.progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(context),
              ),
            ),
          ),
          
          // Timer content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(state.displayTime),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -1,
                  color: Color(0xFF27213C),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _getStatusText(),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (state.selectedSubject != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(state.selectedSubject!.colorHex).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(state.selectedSubject!.colorHex),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    state.selectedSubject!.name,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(state.selectedSubject!.colorHex),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getProgressColor(BuildContext context) {
    if (state.isWorkSession) {
      return const Color(0xFFB4D9E2); // Light blue-teal for work sessions
    } else if (state.isBreakSession) {
      return Colors.green;
    } else if (state.status == TimerStatus.completed) {
      return Colors.amber;
    }
    return Colors.grey;
  }

  Color _getInnerCircleColor() {
    if (state.isWorkSession) {
      return const Color(0xFFFFB3B0); // Lighter pastel red
    } else if (state.isBreakSession) {
      return const Color(0xFFB8E6B8); // Lighter pastel green
    }
    return const Color(0xFFF5F5F5); // Light grey for initial/other states
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