import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendaService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Stream<List<Map<String, dynamic>>> getItems() {
    final uid = _uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('agenda')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'text': doc['text'],
                  'date': doc['date'],
                  'completed': doc['completed'] ?? false,
                  'trainingId': doc.data().containsKey('trainingId')
                      ? doc['trainingId']
                      : null,
                })
            .toList());
  }

  Future<void> addItem(String text, DateTime date,
      {String? trainingId}) async {
    final uid = _uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('agenda')
        .add({
      'text': text,
      'date': date.toIso8601String(),
      'completed': false,
      if (trainingId != null) 'trainingId': trainingId,
    });
  }

  Future<void> toggleCompleted(String id, bool value) async {
    final uid = _uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('agenda')
        .doc(id)
        .update({'completed': value});
  }

  Future<void> deleteItem(String id) async {
    final uid = _uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .collection('agenda')
        .doc(id)
        .delete();
  }
}
