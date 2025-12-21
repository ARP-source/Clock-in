import 'package:hive/hive.dart';

part 'subject.g.dart';

@HiveType(typeId: 0)
class Subject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final int colorHex;

  Subject({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  // Generate a unique ID for new subjects
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Create a copy with updated fields
  Subject copyWith({
    String? id,
    String? name,
    int? colorHex,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
    );
  }
}