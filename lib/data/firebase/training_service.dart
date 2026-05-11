import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/training.dart';

class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTraining(Training training) async {
    await _db.collection('workouts').doc(training.id).set(training.toMap());
  }

  Future<List<Training>> getTrainings() async {
    final snapshot = await _db.collection('workouts').get();
    return snapshot.docs
        .map((doc) => Training.fromMap(doc.id, doc.data()))
        .toList();
  }

  Stream<List<Training>> streamTrainings() {
    return _db.collection('workouts').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Training.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> deleteTraining(String id) async {
    await _db.collection('workouts').doc(id).delete();
  }

  Future<void> updateTraining(Training training) async {
    await _db.collection('workouts').doc(training.id).set(training.toMap());
  }

  Future<Training?> getTrainingById(String id) async {
    final doc = await _db.collection('workouts').doc(id).get();
    if (!doc.exists) return null;
    return Training.fromMap(doc.id, doc.data()!);
  }
}
