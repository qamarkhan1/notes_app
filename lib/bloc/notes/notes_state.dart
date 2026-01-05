import 'package:equatable/equatable.dart';
import '../../data/models/note.dart';

class NotesState extends Equatable {
  final bool loading;
  final String? error;
  final String searchQuery;

  final List<Note> allNotes;

  const NotesState({
    required this.loading,
    required this.allNotes,
    required this.searchQuery,
    this.error,
  });

  List<Note> get filteredNotes {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return allNotes;
    return allNotes.where((n) => n.title.toLowerCase().contains(q)).toList();
  }

  NotesState copyWith({
    bool? loading,
    String? error,
    String? searchQuery,
    List<Note>? allNotes,
  }) {
    return NotesState(
      loading: loading ?? this.loading,
      allNotes: allNotes ?? this.allNotes,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, error, searchQuery, allNotes];
}
