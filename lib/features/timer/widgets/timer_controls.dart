import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_event.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';

class TimerControls extends StatelessWidget {
  final TimerState state;

  const TimerControls({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(context),
            if (state.status == TimerStatus.running || 
                state.status == TimerStatus.paused) ...[
              const SizedBox(width: 16),
              _buildStopButton(context),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton(BuildContext context) {
    final bloc = context.read<TimerBloc>();
    
    switch (state.status) {
      case TimerStatus.initial:
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            bloc.add(TimerStarted(
              studyMode: state.studyMode,
              subject: state.selectedSubject,
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Start Focus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
        
      case TimerStatus.running:
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            bloc.add(TimerPaused());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Pause',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
        
      case TimerStatus.paused:
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            bloc.add(TimerResumed());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF10B981),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Resume',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
        
      case TimerStatus.completed:
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            bloc.add(TimerReset());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'New Session',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
        
      case TimerStatus.breakTime:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF10B981).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Text(
            'On Break',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
        
      case TimerStatus.cancelled:
        return ElevatedButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            bloc.add(TimerReset());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Start New',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        );
    }
  }

  Widget _buildStopButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Stop Session?'),
              content: const Text(
                'Are you sure you want to stop this session? Your progress will be saved.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<TimerBloc>().add(TimerCancelled());
                  },
                  child: const Text(
                    'Stop',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(
          color: Color(0xFFEF4444),
          width: 2,
        ),
      ),
      child: const Text(
        'Stop',
        style: TextStyle(
          color: Color(0xFFEF4444),
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}