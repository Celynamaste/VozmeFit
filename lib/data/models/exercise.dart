class Exercise {
  final String name;
  final String description;
  final int duration; // en segundos
  final String type;  // tipo de ejercicio (Cardio, Fuerza, etc.)

  Exercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'type': type,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'],
      description: map['description'],
      duration: map['duration'],
      type: map['type'],
    );
  }
}
