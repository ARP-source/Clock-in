import 'package:flutter/material.dart';
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
            bloc.add(TimerStarted(
              studyMode: state.studyMode,
              subject: state.selectedSubject,
            ));
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Start Focus',
            style: TextStyle(fontSize: 18),
          ),
        );
        
      case TimerStatus.running:
        return ElevatedButton(
          onPressed: () {
            bloc.add(TimerPaused());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Pause',
            style: TextStyle(fontSize: 18),
          ),
        );
        
      case TimerStatus.paused:
        return ElevatedButton(
          onPressed: () {
            bloc.add(TimerResumed());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Resume',
            style: TextStyle(fontSize: 18),
          ),
        );
        
      case TimerStatus.completed:
        return ElevatedButton(
          onPressed: () {
            bloc.add(TimerReset());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'New Session',
            style: TextStyle(fontSize: 18),
          ),
        );
        
      case TimerStatus.breakTime:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.green),
          ),
          child: const Text(
            'On Break',
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
        
      case TimerStatus.cancelled:
        return ElevatedButton(
          onPressed: () {
            bloc.add(TimerReset());
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Start New',
            style: TextStyle(fontSize: 18),
          ),
        );
    }
  }

  Widget _buildStopButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        side: const BorderSide(color: Colors.red),
      ),
      child: const Text(
        'Stop',
        style: TextStyle(
          color: Colors.red,
          fontSize: 18,
        ),
      ),
    );
  }
}