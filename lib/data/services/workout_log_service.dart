import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutLogService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> logWorkout({
    required String trainingId,
    required String notes,
    required double? weight,
    required int? reps,
    required String sensation, // 'facil' | 'normal' | 'duro'
  }) async {
    final uid = _uid;
    if (uid == null) return;
    await _db
        .collection('users')
        .doc(uid)
        .collection('workoutLogs')
        .add({
      'trainingId': trainingId,
      'date': DateTime.now().toIso8601String(),
      'notes': notes,
      'weight': weight,
      'reps': reps,
      'sensation': sensation,
    });
  }

  Stream<List<Map<String, dynamic>>> getLogs() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('users')
        .doc(uid)
        .collection('workoutLogs')
        .orderBy('date', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {...d.data(), 'id': d.id}).toList());
  }
}
