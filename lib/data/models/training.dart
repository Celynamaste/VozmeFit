import 'exercise.dart';

class Training {
  final String id;
  final String title;
  final String level;
  final String type;
  final List<Exercise> exercises;

  Training({
    required this.id,
    required this.title,
    required this.level,
    required this.type,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'level': level,
      'type': type,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }
}
