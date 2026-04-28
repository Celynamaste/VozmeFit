import 'exercise.dart';

class Training {
  final String id;
  final String title;
  final String level;
  final String type;
  final String description;
  final String imageUrl;
  final int duration; // en minutos
  final List<Exercise> exercises;

  Training({
    required this.id,
    required this.title,
    required this.level,
    required this.type,
    this.description = '',
    this.imageUrl = '',
    this.duration = 0,
    required this.exercises,
  });

  factory Training.fromMap(String id, Map<String, dynamic> data) {
    final rawExercises = data['exercises'];
    List<Exercise> exercises = [];
    if (rawExercises is List) {
      exercises = rawExercises
          .whereType<Map>()
          .map((e) => Exercise.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }
    final title = (data['title'] as String?)?.isNotEmpty == true
        ? data['title'] as String
        : (data['name'] as String? ?? '');

    return Training(
      id: id,
      title: title,
      level: data['level'] as String? ?? '',
      type: data['type'] as String? ?? '',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      duration: (data['duration'] as num?)?.toInt() ?? 0,
      exercises: exercises,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': title,
      'level': level,
      'type': type,
      'description': description,
      'imageUrl': imageUrl,
      'duration': duration,
      'exercises': exercises.map((e) => e.toMap()).toList(),
    };
  }
}
