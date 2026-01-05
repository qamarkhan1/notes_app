import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Note.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data() ?? {};

  final createdTs = data['created_at'];
  final updatedTs = data['updated_at'];

  return Note(
    id: doc.id,
    title: (data['title'] ?? '') as String,
    content: (data['content'] ?? '') as String,
    createdAt: (createdTs is Timestamp) ? createdTs.toDate() : DateTime.now(),
    updatedAt: (updatedTs is Timestamp) ? updatedTs.toDate() : DateTime.now(),
    userId: (data['user_id'] ?? '') as String,
  );
}


  Map<String, dynamic> toMap() => {
        'title': title,
        'content': content,
        'created_at': Timestamp.fromDate(createdAt),
        'updated_at': Timestamp.fromDate(updatedAt),
        'user_id': userId,
      };

  @override
  List<Object?> get props => [id, title, content, createdAt, updatedAt, userId];
}
