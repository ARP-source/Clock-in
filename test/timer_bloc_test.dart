import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:focustrophy/core/constants/study_modes.dart';
import 'package:focustrophy/core/services/penalty_timer_service.dart';
import 'package:focustrophy/features/timer/bloc/timer_bloc.dart';
import 'package:focustrophy/features/timer/bloc/timer_event.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';

void main() {
  group('TimerBloc', () {
    late PenaltyTimerService penaltyTimerService;
    late TimerBloc timerBloc;

    setUp(() {
      penaltyTimerService = PenaltyTimerService();
      timerBloc = TimerBloc(penaltyTimerService: penaltyTimerService);
    });

    tearDown(() {
      timerBloc.close();
      penaltyTimerService.dispose();
    });

    test('initial state is TimerState.initial', () {
      expect(timerBloc.state, const TimerState());
    });

    blocTest<TimerBloc, TimerState>(
      'emits running state when TimerStarted is added',
      build: () => timerBloc,
      act: (bloc) => bloc.add(const TimerStarted(
        studyMode: StudyMode.pomodoro,
        subject: null,
      )),
      expect: () => [
        const TimerState(
          status: TimerStatus.running,
          studyMode: StudyMode.pomodoro,
          elapsedTime: Duration.zero,
          penaltyTime: Duration.zero,
          isBreak: false,
        ),
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'emits paused state when TimerPaused is added',
      build: () => timerBloc,
      seed: () => const TimerState(status: TimerStatus.running),
      act: (bloc) => bloc.add(TimerPaused()),
      expect: () => [
        const TimerState(status: TimerStatus.paused),
      ],
    );

    blocTest<TimerBloc, TimerState>(
      'emits completed state when TimerReset is added',
      build: () => timerBloc,
      seed: () => const TimerState(status: TimerStatus.completed),
      act: (bloc) => bloc.add(TimerReset()),
      expect: () => [
        const TimerState(),
      ],
    );
  });

  group('PenaltyTimerService', () {
    late PenaltyTimerService service;

    setUp(() {
      service = PenaltyTimerService();
    });

    tearDown(() {
      service.dispose();
    });

    test('starts with zero values', () {
      expect(service.currentSessionDuration, Duration.zero);
      expect(service.totalPenaltyTime, Duration.zero);
      expect(service.isSessionActive, false);
    });

    test('can start and complete a session', () {
      service.startSession(presetDuration: const Duration(minutes: 1));
      expect(service.isSessionActive, true);
      
      service.completeSession();
      expect(service.isSessionActive, false);
    });
  });
}