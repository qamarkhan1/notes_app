import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/note.dart';
import '../../data/repositories/notes_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _repo;
  String? _uid;

  NotesBloc(this._repo)
      : super(const NotesState(loading: true, allNotes: [], searchQuery: '')) {
    on<NotesStarted>(_onStarted);
    on<NotesSearchChanged>(_onSearchChanged);
    on<NotesCreateRequested>(_onCreate);
    on<NotesUpdateRequested>(_onUpdate);
    on<NotesDeleteRequested>(_onDelete);
  }

  Future<void> _onStarted(NotesStarted event, Emitter<NotesState> emit) async {
    _uid = event.uid;

    emit(state.copyWith(loading: true, error: null));

    await emit.forEach<List<Note>>(
      _repo.watchNotesForUser(event.uid),
      onData: (notes) => state.copyWith(
        loading: false,
        allNotes: notes,
        error: null,
      ),
      onError: (error, stackTrace) => state.copyWith(
        loading: false,
        error: error.toString(),
      ),
    );
  }

  void _onSearchChanged(NotesSearchChanged event, Emitter<NotesState> emit) {
    emit(state.copyWith(searchQuery: event.query, error: null));
  }

  Future<void> _onCreate(NotesCreateRequested event, Emitter<NotesState> emit) async {
    try {
      final uid = _uid;
      if (uid == null) return;

      await _repo.createNote(
        userId: uid,
        title: event.title,
        content: event.content,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onUpdate(NotesUpdateRequested event, Emitter<NotesState> emit) async {
    try {
      final uid = _uid;
      if (uid == null) return;

      await _repo.updateNote(
        noteId: event.note.id,
        userId: uid,
        title: event.title,
        content: event.content,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDelete(NotesDeleteRequested event, Emitter<NotesState> emit) async {
    try {
      await _repo.deleteNote(event.noteId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
