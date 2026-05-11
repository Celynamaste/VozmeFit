import 'package:flutter_test/flutter_test.dart';
import 'package:vozmefit/data/models/training.dart';

void main() {
  group('Training.fromMap', () {
    test('deserializa todos los campos correctamente', () {
      final data = {
        'title': 'Fuerza Total',
        'level': 'Intermedio',
        'type': 'Fuerza',
        'description': 'Rutina de fuerza completa',
        'imageUrl': 'https://example.com/img.jpg',
        'duration': 45,
        'exercises': [
          {
            'name': 'Sentadilla',
            'description': 'Baja hasta paralelo',
            'duration': 60,
            'type': 'Piernas',
            'imageUrl': '',
          }
        ],
      };

      final training = Training.fromMap('id-1', data);

      expect(training.id, 'id-1');
      expect(training.title, 'Fuerza Total');
      expect(training.level, 'Intermedio');
      expect(training.type, 'Fuerza');
      expect(training.description, 'Rutina de fuerza completa');
      expect(training.duration, 45);
      expect(training.exercises.length, 1);
      expect(training.exercises.first.name, 'Sentadilla');
    });

    test('usa el campo "name" como fallback si "title" está vacío', () {
      final data = {
        'name': 'Cardio Básico',
        'level': 'Principiante',
        'type': 'Cardio',
        'exercises': [],
      };

      final training = Training.fromMap('id-2', data);

      expect(training.title, 'Cardio Básico');
    });

    test('usa valores por defecto si faltan campos', () {
      final training = Training.fromMap('id-3', {});

      expect(training.title, '');
      expect(training.level, '');
      expect(training.type, '');
      expect(training.description, '');
      expect(training.duration, 0);
      expect(training.exercises, isEmpty);
    });

    test('ignora ejercicios con formato incorrecto en la lista', () {
      final data = {
        'title': 'Test',
        'exercises': ['no es un mapa', 42, null],
      };

      final training = Training.fromMap('id-4', data);

      expect(training.exercises, isEmpty);
    });

    test('convierte duration de double a int', () {
      final training = Training.fromMap('id-5', {'duration': 30.0});

      expect(training.duration, 30);
    });
  });

  group('Training.toMap', () {
    test('serializa correctamente usando "name" como clave de título', () {
      final training = Training(
        id: 'id-1',
        title: 'Fuerza Total',
        level: 'Intermedio',
        type: 'Fuerza',
        description: 'Descripción',
        duration: 30,
        exercises: [],
      );

      final map = training.toMap();

      expect(map['name'], 'Fuerza Total');
      expect(map['level'], 'Intermedio');
      expect(map['type'], 'Fuerza');
      expect(map['description'], 'Descripción');
      expect(map['duration'], 30);
      expect(map['exercises'], isEmpty);
    });

    test('el id no se incluye en el mapa (lo gestiona Firestore)', () {
      final training = Training(
        id: 'id-1',
        title: 'Test',
        level: 'Principiante',
        type: 'Cardio',
        exercises: [],
      );

      expect(training.toMap().containsKey('id'), isFalse);
    });
  });
}
