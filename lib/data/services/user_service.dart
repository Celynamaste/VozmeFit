import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveUser(Usuario user) async {
    await _db
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<Usuario?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(uid, doc.data()!);
  }
}
