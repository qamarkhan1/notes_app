import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_assignment/core/app_colors.dart';
import '../../bloc/notes/notes_bloc.dart';
import '../../bloc/notes/notes_event.dart';
import '../../data/models/note.dart';
// import '../../core/theme/app_colors.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  const NoteEditorScreen({super.key, this.note});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  bool _saving = false;

  bool get _isEdit => widget.note != null;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title.text = widget.note!.title;
      _content.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    final t = _title.text.trim();
    final c = _content.text.trim();

    if (t.isEmpty && c.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note cannot be empty'),
          backgroundColor: AppColors.youtubeRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      final bloc = context.read<NotesBloc>();
      if (_isEdit) {
        bloc.add(NotesUpdateRequested(note: widget.note!, title: t, content: c));
      } else {
        bloc.add(NotesCreateRequested(title: t, content: c));
      }
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: AppColors.youtubeRed),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.youtubeRed),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Discard',
        ),
        title: Text(
          _isEdit ? 'Edit Note' : 'New Note',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Save Button in AppBar for a cleaner look
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: FilledButton(
              onPressed: _saving ? null : _save,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.whatsappGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _saving
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                const Divider(height: 1, color: AppColors.outline),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Title Field - Borderless style
                        TextField(
                          controller: _title,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                          maxLines: null,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4)),
                            border: InputBorder.none,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Date/Status Indicator
                        Row(
                          children: [
                            Icon(Icons.edit_note_rounded, size: 18, color: AppColors.whatsappGreen.withOpacity(0.6)),
                            const SizedBox(width: 8),
                            Text(
                              _isEdit ? 'Editing your note' : 'Drafting new note',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Content Field - Borderless style
                        TextField(
                          controller: _content,
                          style: const TextStyle(fontSize: 18, height: 1.6, color: AppColors.textPrimary),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Start typing your thoughts...',
                            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4)),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Sync Hint
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  color: AppColors.background,
                  child: Text(
                    _isEdit ? 'Changes sync automatically to your account' : 'Notes are stored securely in the cloud',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}