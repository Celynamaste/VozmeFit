import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/training.dart';

class RoutineService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> addToRoutine(String trainingId) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection('users')
        .doc(uid)
        .collection('myRoutine')
        .doc(trainingId)
        .set({'addedAt': DateTime.now().toIso8601String()});
  }

  Future<void> removeFromRoutine(String trainingId) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection('users')
        .doc(uid)
        .collection('myRoutine')
        .doc(trainingId)
        .delete();
  }

  Future<bool> isInRoutine(String trainingId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _db
        .collection('users')
        .doc(uid)
        .collection('myRoutine')
        .doc(trainingId)
        .get();
    return doc.exists;
  }

  Stream<List<Training>> getMyRoutine() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('myRoutine')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .asyncMap((snap) async {
      final trainings = <Training>[];
      for (final doc in snap.docs) {
        final tDoc =
            await _db.collection('trainings').doc(doc.id).get();
        if (tDoc.exists) {
          trainings.add(Training.fromMap(tDoc.id, tDoc.data()!));
        }
      }
      return trainings;
    });
  }
}
