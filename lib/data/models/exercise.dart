class Exercise {
  final String name;
  final String description;
  final int duration; // en segundos
  final String type;
  final String imageUrl;

  Exercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.type,
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'type': type,
      'imageUrl': imageUrl,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      duration: (map['duration'] as num?)?.toInt() ?? 0,
      type: map['type'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
    );
  }
}
