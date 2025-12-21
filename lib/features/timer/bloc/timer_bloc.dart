import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focustrophy/core/services/penalty_timer_service.dart';
import 'package:focustrophy/features/timer/bloc/timer_event.dart';
import 'package:focustrophy/features/timer/bloc/timer_state.dart';
import 'package:hive/hive.dart';
import 'package:focustrophy/core/models/session.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final PenaltyTimerService _penaltyTimerService;
  Timer? _timer;

  TimerBloc({required PenaltyTimerService penaltyTimerService})
      : _penaltyTimerService = penaltyTimerService,
        super(const TimerState()) {
    
    // Set up penalty timer service callbacks
    _penaltyTimerService.onPenaltyAdded = (penaltyTime) {
      add(PenaltyAdded(penaltyTime));
    };

    _penaltyTimerService.onSessionUpdate = (sessionDuration) {
      add(TimerTicked(
        elapsedTime: sessionDuration,
        penaltyTime: _penaltyTimerService.totalPenaltyTime,
      ));
    };

    _penaltyTimerService.onSessionCompleted = () {
      if (state.isBreak) {
        add(BreakCompleted());
      } else {
        _startBreak();
      }
    };

    on<TimerStarted>(_onTimerStarted);
    on<TimerPaused>(_onTimerPaused);
    on<TimerResumed>(_onTimerResumed);
    on<TimerReset>(_onTimerReset);
    on<TimerCancelled>(_onTimerCancelled);
    on<TimerTicked>(_onTimerTicked);
    on<BreakStarted>(_onBreakStarted);
    on<BreakTicked>(_onBreakTicked);
    on<BreakCompleted>(_onBreakCompleted);
    on<StudyModeSelected>(_onStudyModeSelected);
    on<SubjectSelected>(_onSubjectSelected);
    on<PenaltyAdded>(_onPenaltyAdded);
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(state.copyWith(
      status: TimerStatus.running,
      studyMode: event.studyMode,
      selectedSubject: event.subject,
      elapsedTime: Duration.zero,
      penaltyTime: Duration.zero,
      isBreak: false,
      error: null,
    ));

    final presetDuration = event.studyMode.isFlowMode 
        ? null 
        : Duration(minutes: event.studyMode.workMinutes);
    
    _penaltyTimerService.startSession(presetDuration: presetDuration);
  }

  void _onTimerPaused(TimerPaused event, Emitter<TimerState> emit) {
    _penaltyTimerService.pauseSession();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void _onTimerResumed(TimerResumed event, Emitter<TimerState> emit) {
    _penaltyTimerService.resumeSession();
    emit(state.copyWith(status: TimerStatus.running));
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _timer?.cancel();
    _penaltyTimerService.resetPenalty();
    emit(const TimerState());
  }

  void _onTimerCancelled(TimerCancelled event, Emitter<TimerState> emit) {
    _timer?.cancel();
    _penaltyTimerService.cancelSession();
    emit(state.copyWith(status: TimerStatus.cancelled));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(state.copyWith(
      elapsedTime: event.elapsedTime,
      penaltyTime: event.penaltyTime,
    ));
  }

  void _onBreakStarted(BreakStarted event, Emitter<TimerState> emit) {
    if (state.studyMode.isFlowMode) return;

    emit(state.copyWith(
      status: TimerStatus.breakTime,
      isBreak: true,
      elapsedTime: Duration.zero,
    ));

    // Start break timer using events
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(BreakTicked(state.elapsedTime + const Duration(seconds: 1)));
    });
  }

  void _onBreakTicked(BreakTicked event, Emitter<TimerState> emit) {
    emit(state.copyWith(elapsedTime: event.breakTime));
    
    // Check if break is complete
    if (event.breakTime.inSeconds >= state.studyMode.breakMinutes * 60) {
      add(BreakCompleted());
    }
  }

  void _onBreakCompleted(BreakCompleted event, Emitter<TimerState> emit) {
    _timer?.cancel();
    _saveSession();
    emit(state.copyWith(
      status: TimerStatus.completed,
      isBreak: false,
    ));
  }

  void _saveSession() {
    final subjectId = state.selectedSubject?.id ?? 'general';
    final focusMinutes = state.elapsedTime.inMinutes;
    final penaltyMinutes = state.penaltyTime.inMinutes;
    
    // Determine status based on penalty ratio
    String status;
    if (penaltyMinutes == 0) {
      status = 'Gold';
    } else if (penaltyMinutes <= focusMinutes * 0.1) {
      status = 'Silver';
    } else {
      status = 'Failed';
    }
    
    final session = Session(
      id: Session.generateId(),
      subjectId: subjectId,
      startTime: _penaltyTimerService.sessionStartTime ?? DateTime.now(),
      focusMinutes: focusMinutes,
      penaltyMinutes: penaltyMinutes,
      status: status,
    );
    
    Hive.box<Session>('sessions').put(session.id, session);
  }

  void _onStudyModeSelected(StudyModeSelected event, Emitter<TimerState> emit) {
    emit(state.copyWith(studyMode: event.studyMode));
  }

  void _onSubjectSelected(SubjectSelected event, Emitter<TimerState> emit) {
    emit(state.copyWith(selectedSubject: event.subject));
  }

  void _onPenaltyAdded(PenaltyAdded event, Emitter<TimerState> emit) {
    final newPenaltyTime = state.penaltyTime + event.penaltyDuration;
    emit(state.copyWith(penaltyTime: newPenaltyTime));
  }

  void _startBreak() {
    add(BreakStarted());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _penaltyTimerService.dispose();
    return super.close();
  }
}