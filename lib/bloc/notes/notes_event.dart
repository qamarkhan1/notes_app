import 'package:equatable/equatable.dart';
import '../../data/models/note.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

class NotesStarted extends NotesEvent {
  final String uid;
  const NotesStarted(this.uid);
  @override
  List<Object?> get props => [uid];
}

class NotesSearchChanged extends NotesEvent {
  final String query;
  const NotesSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class NotesCreateRequested extends NotesEvent {
  final String title;
  final String content;
  const NotesCreateRequested({required this.title, required this.content});
  @override
  List<Object?> get props => [title, content];
}

class NotesUpdateRequested extends NotesEvent {
  final Note note;
  final String title;
  final String content;
  const NotesUpdateRequested({required this.note, required this.title, required this.content});
  @override
  List<Object?> get props => [note, title, content];
}

class NotesDeleteRequested extends NotesEvent {
  final String noteId;
  const NotesDeleteRequested(this.noteId);
  @override
  List<Object?> get props => [noteId];
}

/// internal event to sync stream results into state
class NotesInternalSynced extends NotesEvent {
  final List<Note> notes;
  const NotesInternalSynced(this.notes);
  @override
  List<Object?> get props => [notes];
}


class NotesSynced extends NotesEvent {
  final List<Note> notes;
  const NotesSynced(this.notes);

  @override
  List<Object?> get props => [notes];
}
