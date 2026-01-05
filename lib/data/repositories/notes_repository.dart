import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

class NotesRepository {
  final FirebaseFirestore _db;
  NotesRepository({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _notes => _db.collection('notes');

  Stream<List<Note>> watchNotesForUser(String userId) {
  return _notes
      .where('user_id', isEqualTo: userId)
      .snapshots()
      .map((snap) => snap.docs.map((d) => Note.fromDoc(d)).toList());
}


  Future<void> createNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    await _notes.add({
      'title': title.trim(),
      'content': content.trim(),
      'user_id': userId,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote({
    required String noteId,
    required String userId,
    required String title,
    required String content,
  }) async {
    await _notes.doc(noteId).update({
      'title': title.trim(),
      'content': content.trim(),
      'user_id': userId, // keeps rule validation happy
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String noteId) async {
    await _notes.doc(noteId).delete();
  }
}
