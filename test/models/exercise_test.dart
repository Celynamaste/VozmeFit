import 'package:flutter_test/flutter_test.dart';
import 'package:vozmefit/data/models/exercise.dart';

void main() {
  group('Exercise.fromMap', () {
    test('deserializa todos los campos correctamente', () {
      final map = {
        'name': 'Sentadilla',
        'description': 'Baja hasta paralelo',
        'duration': 45,
        'type': 'Piernas',
        'imageUrl': 'https://example.com/img.jpg',
      };

      final exercise = Exercise.fromMap(map);

      expect(exercise.name, 'Sentadilla');
      expect(exercise.description, 'Baja hasta paralelo');
      expect(exercise.duration, 45);
      expect(exercise.type, 'Piernas');
      expect(exercise.imageUrl, 'https://example.com/img.jpg');
    });

    test('usa valores por defecto si faltan campos', () {
      final exercise = Exercise.fromMap({});

      expect(exercise.name, '');
      expect(exercise.description, '');
      expect(exercise.duration, 0);
      expect(exercise.type, '');
      expect(exercise.imageUrl, '');
    });

    test('convierte duration de double a int', () {
      final exercise = Exercise.fromMap({'duration': 30.0});

      expect(exercise.duration, 30);
      expect(exercise.duration, isA<int>());
    });
  });

  group('Exercise.toMap', () {
    test('serializa correctamente', () {
      final exercise = Exercise(
        name: 'Flexión',
        description: 'Cuerpo recto',
        duration: 30,
        type: 'Pecho',
      );

      final map = exercise.toMap();

      expect(map['name'], 'Flexión');
      expect(map['description'], 'Cuerpo recto');
      expect(map['duration'], 30);
      expect(map['type'], 'Pecho');
      expect(map['imageUrl'], '');
    });

    test('roundtrip: toMap -> fromMap devuelve el mismo ejercicio', () {
      final original = Exercise(
        name: 'Burpee',
        description: 'Ejercicio completo',
        duration: 60,
        type: 'HIIT',
        imageUrl: 'https://example.com/burpee.jpg',
      );

      final recovered = Exercise.fromMap(original.toMap());

      expect(recovered.name, original.name);
      expect(recovered.description, original.description);
      expect(recovered.duration, original.duration);
      expect(recovered.type, original.type);
      expect(recovered.imageUrl, original.imageUrl);
    });
  });
}
