class Usuario {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'user' | 'trainer'
  final String level; // 'Principiante' | 'Intermedio' | 'Avanzado'

  const Usuario({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.level = 'Principiante',
  });

  factory Usuario.fromMap(String uid, Map<String, dynamic> data) {
    return Usuario(
      uid: uid,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      level: data['level'] as String? ?? 'Principiante',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'role': role,
      'level': level,
    };
  }
}
