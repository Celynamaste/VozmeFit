import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendaService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> getItems() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('agenda')
        .orderBy('date')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {
              'id': doc.id,
              'text': doc['text'],
              'date': doc['date'],
              'completed': doc['completed'],
            }).toList());
  }

  Future<void> addItem(String text, DateTime date) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('agenda')
        .add({
          'text': text,
          'date': date.toIso8601String(),
          'completed': false,
        });
  }

  Future<void> toggleCompleted(String id, bool value) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('agenda')
        .doc(id)
        .update({'completed': value});
  }

  Future<void> deleteItem(String id) async {
    await _db
        .collection('users')
        .doc(_uid)
        .collection('agenda')
        .doc(id)
        .delete();
  }
}
