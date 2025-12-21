import 'package:hive/hive.dart';

part 'session.g.dart';

@HiveType(typeId: 1)
class Session {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String subjectId;
  
  @HiveField(2)
  final DateTime startTime;
  
  @HiveField(3)
  final int focusMinutes;
  
  @HiveField(4)
  final int penaltyMinutes;
  
  @HiveField(5)
  final String status; // Gold, Silver, Failed

  Session({
    required this.id,
    required this.subjectId,
    required this.startTime,
    required this.focusMinutes,
    required this.penaltyMinutes,
    required this.status,
  });

  // Generate a unique ID for new sessions
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Calculate total session duration
  int get totalMinutes => focusMinutes + penaltyMinutes;

  // Create a copy with updated fields
  Session copyWith({
    String? id,
    String? subjectId,
    DateTime? startTime,
    int? focusMinutes,
    int? penaltyMinutes,
    String? status,
  }) {
    return Session(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      startTime: startTime ?? this.startTime,
      focusMinutes: focusMinutes ?? this.focusMinutes,
      penaltyMinutes: penaltyMinutes ?? this.penaltyMinutes,
      status: status ?? this.status,
    );
  }
}