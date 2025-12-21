import 'package:equatable/equatable.dart';
import 'package:focustrophy/core/constants/study_modes.dart';
import 'package:focustrophy/core/models/subject.dart';

enum TimerStatus {
  initial,
  running,
  paused,
  breakTime,
  completed,
  cancelled,
}

class TimerState extends Equatable {
  final TimerStatus status;
  final StudyMode studyMode;
  final Subject? selectedSubject;
  final Duration elapsedTime;
  final Duration penaltyTime;
  final Duration breakTime;
  final bool isBreak;
  final String? error;

  const TimerState({
    this.status = TimerStatus.initial,
    this.studyMode = StudyMode.pomodoro,
    this.selectedSubject,
    this.elapsedTime = Duration.zero,
    this.penaltyTime = Duration.zero,
    this.breakTime = Duration.zero,
    this.isBreak = false,
    this.error,
  });

  TimerState copyWith({
    TimerStatus? status,
    StudyMode? studyMode,
    Subject? selectedSubject,
    Duration? elapsedTime,
    Duration? penaltyTime,
    Duration? breakTime,
    bool? isBreak,
    String? error,
  }) {
    return TimerState(
      status: status ?? this.status,
      studyMode: studyMode ?? this.studyMode,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      penaltyTime: penaltyTime ?? this.penaltyTime,
      breakTime: breakTime ?? this.breakTime,
      isBreak: isBreak ?? this.isBreak,
      error: error ?? this.error,
    );
  }

  Duration get totalTime => elapsedTime + penaltyTime;
  
  /// Returns the remaining time for countdown display (for preset modes like Pomodoro)
  Duration get remainingTime {
    if (studyMode.isFlowMode) return totalTime; // Flow mode counts up
    final targetMinutes = isBreak ? studyMode.breakMinutes : studyMode.workMinutes;
    final targetDuration = Duration(minutes: targetMinutes);
    final remaining = targetDuration - elapsedTime;
    return remaining.isNegative ? Duration.zero : remaining;
  }
  
  /// Returns the time to display (countdown for preset modes, count up for flow mode)
  Duration get displayTime {
    if (studyMode.isFlowMode) return totalTime;
    return remainingTime;
  }
  
  double get progress {
    if (studyMode.isFlowMode) return 0.0;
    final target = isBreak ? studyMode.breakMinutes : studyMode.workMinutes;
    if (target == 0) return 0.0;
    return (totalTime.inSeconds / (target * 60)).clamp(0.0, 1.0);
  }

  bool get isWorkSession => !isBreak && status == TimerStatus.running;
  bool get isBreakSession => isBreak && status == TimerStatus.running;

  @override
  List<Object?> get props => [
    status,
    studyMode,
    selectedSubject,
    elapsedTime,
    penaltyTime,
    breakTime,
    isBreak,
    error,
  ];
}