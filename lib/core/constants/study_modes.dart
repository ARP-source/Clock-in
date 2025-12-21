enum StudyMode {
  pomodoro('Pomodoro', 25, 5, 'Classic 25-minute focused work session with 5-minute break'),
  efficiency('Efficiency', 52, 17, '52 minutes of work followed by 17-minute break for optimal productivity'),
  ultradian('Ultradian', 90, 20, '90-minute deep work session with 20-minute break'),
  flow('Flow Mode', 0, 0, 'Continuous work mode - track until manually stopped');

  final String name;
  final int workMinutes;
  final int breakMinutes;
  final String description;

  const StudyMode(this.name, this.workMinutes, this.breakMinutes, this.description);

  bool get hasTimer => workMinutes > 0;
  bool get isFlowMode => this == StudyMode.flow;
}

enum SessionStatus {
  gold('Gold', 'Perfect session with no penalties!'),
  silver('Silver', 'Good session with some penalties.'),
  failed('Failed', 'Session was abandoned.');

  final String name;
  final String description;

  const SessionStatus(this.name, this.description);
}