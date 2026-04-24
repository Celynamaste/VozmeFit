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

  factory Training.fromMap(String id, Map<String, dynamic> data) {
    final exercises = (data['exercises'] as List? ?? [])
        .map((e) => Exercise.fromMap(e as Map<String, dynamic>))
        .toList();

    return Training(
      id: id,
      title: data['title'] as String? ?? '',
      level: data['level'] as String? ?? '',
      type: data['type'] as String? ?? '',
      exercises: exercises,
    );
  }

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
