import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class WorkoutService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Todos los entrenamientos disponibles
  Stream<List<Map<String, dynamic>>> getWorkouts() {
    return _db.collection('workouts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Entrenamientos asignados al usuario
  Stream<List<Map<String, dynamic>>> getAssignedWorkouts() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('assigned_workouts')
        .snapshots()
        .asyncMap((snapshot) async {
      final List<Map<String, dynamic>> result = [];

      for (var doc in snapshot.docs) {
        final workoutId = doc.id;
        final workoutSnap =
            await _db.collection('workouts').doc(workoutId).get();

        if (workoutSnap.exists) {
          final data = workoutSnap.data()!;
          data['id'] = workoutSnap.id;
          data['assignedAt'] = doc.data()['assignedAt'];
          result.add(data);
        }
      }

      return result;
    });
  }

  // Asignar entrenamiento al usuario
  Future<void> assignWorkoutToUser(String workoutId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db
        .collection('users')
        .doc(user.uid)
        .collection('assigned_workouts')
        .doc(workoutId)
        .set({
      'assignedAt': DateTime.now().toIso8601String(),
    });
  }
}
