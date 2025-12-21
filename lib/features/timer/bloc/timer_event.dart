import 'package:equatable/equatable.dart';
import 'package:focustrophy/core/constants/study_modes.dart';
import 'package:focustrophy/core/models/subject.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final StudyMode studyMode;
  final Subject? subject;

  const TimerStarted({
    required this.studyMode,
    this.subject,
  });

  @override
  List<Object> get props => [studyMode, subject ?? ''];
}

class TimerPaused extends TimerEvent {}

class TimerResumed extends TimerEvent {}

class TimerReset extends TimerEvent {}

class TimerCancelled extends TimerEvent {}

class TimerTicked extends TimerEvent {
  final Duration elapsedTime;
  final Duration penaltyTime;

  const TimerTicked({
    required this.elapsedTime,
    required this.penaltyTime,
  });

  @override
  List<Object> get props => [elapsedTime, penaltyTime];
}

class BreakStarted extends TimerEvent {}

class BreakTicked extends TimerEvent {
  final Duration breakTime;

  const BreakTicked(this.breakTime);

  @override
  List<Object> get props => [breakTime];
}

class BreakCompleted extends TimerEvent {}

class StudyModeSelected extends TimerEvent {
  final StudyMode studyMode;

  const StudyModeSelected(this.studyMode);

  @override
  List<Object> get props => [studyMode];
}

class SubjectSelected extends TimerEvent {
  final Subject? subject;

  const SubjectSelected(this.subject);

  @override
  List<Object> get props => [subject ?? ''];
}

class PenaltyAdded extends TimerEvent {
  final Duration penaltyDuration;

  const PenaltyAdded(this.penaltyDuration);

  @override
  List<Object> get props => [penaltyDuration];
}