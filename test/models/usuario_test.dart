import 'package:flutter_test/flutter_test.dart';
import 'package:vozmefit/data/models/usuario.dart';

void main() {
  group('Usuario.fromMap', () {
    test('deserializa todos los campos correctamente', () {
      final data = {
        'email': 'carlos@test.com',
        'displayName': 'Carlos',
        'role': 'trainer',
        'level': 'Avanzado',
      };

      final usuario = Usuario.fromMap('uid-1', data);

      expect(usuario.uid, 'uid-1');
      expect(usuario.email, 'carlos@test.com');
      expect(usuario.displayName, 'Carlos');
      expect(usuario.role, 'trainer');
      expect(usuario.level, 'Avanzado');
    });

    test('usa valores por defecto si faltan campos', () {
      final usuario = Usuario.fromMap('uid-2', {});

      expect(usuario.email, '');
      expect(usuario.displayName, '');
      expect(usuario.role, 'user');
      expect(usuario.level, 'Principiante');
    });

    test('el rol por defecto es "user"', () {
      final usuario = Usuario.fromMap('uid-3', {'email': 'a@b.com'});

      expect(usuario.role, 'user');
    });

    test('el nivel por defecto es "Principiante"', () {
      final usuario = Usuario.fromMap('uid-4', {});

      expect(usuario.level, 'Principiante');
    });
  });

  group('Usuario.toMap', () {
    test('serializa correctamente sin incluir el uid', () {
      const usuario = Usuario(
        uid: 'uid-1',
        email: 'carlos@test.com',
        displayName: 'Carlos',
        role: 'user',
        level: 'Intermedio',
      );

      final map = usuario.toMap();

      expect(map.containsKey('uid'), isFalse);
      expect(map['email'], 'carlos@test.com');
      expect(map['displayName'], 'Carlos');
      expect(map['role'], 'user');
      expect(map['level'], 'Intermedio');
    });
  });

  group('Usuario constructor', () {
    test('el nivel tiene "Principiante" como valor por defecto', () {
      const usuario = Usuario(
        uid: 'uid-1',
        email: '',
        displayName: '',
        role: 'user',
      );

      expect(usuario.level, 'Principiante');
    });
  });
}
