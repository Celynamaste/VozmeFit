import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vozmefit/data/models/exercise.dart';
import '../models/training.dart';

class TrainingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTraining(Training training) async {
    await _db.collection('trainings').doc(training.id).set(training.toMap());
  }

  Future<List<Training>> getTrainings() async {
    final snapshot = await _db.collection('trainings').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      final exercises = (data['exercises'] as List)
          .map((e) => Exercise(
                name: e['name'],
                description: e['description'],
                duration: e['duration'], type: '',
              ))
          .toList();

      return Training(
        id: doc.id,
        title: data['title'],
        level: data['level'],
        exercises: exercises, type: '',
      );
    }).toList();
  }

  Future<void> deleteTraining(String id) async {}
}
