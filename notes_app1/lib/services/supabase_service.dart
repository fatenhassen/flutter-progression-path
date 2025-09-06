import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  Stream<List<Note>> getNotes({String? category, String? searchQuery}) {
    final user = _supabase.auth.currentUser;
    if (user == null) return Stream.value([]);

    final stream = _supabase.from('notes').stream(primaryKey: ['id']);

    return stream.map((rows) {
      var notes = rows.map((m) => Note.fromMap(m)).toList();

      notes = notes.where((n) => n.userId == user.id).toList();

      if (category != null && category.isNotEmpty) {
        notes = notes.where((n) => (n.category ?? '') == category).toList();
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        notes = notes
            .where((n) => (n.title ?? '').toLowerCase().contains(q))
            .toList();
      }

      notes.sort((a, b) {
        final aDate = a.updatedAt ?? a.createdAt;
        final bDate = b.updatedAt ?? b.createdAt;
        return (bDate ?? DateTime.fromMillisecondsSinceEpoch(0)).compareTo(
          aDate ?? DateTime.fromMillisecondsSinceEpoch(0),
        );
      });

      return notes;
    });
  }

  Future<void> createNote(String title, String content, String category) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('notes').insert({
      'title': title,
      'content': content,
      'category': category,
      'user_id': user.id,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
    required String category,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('notes')
        .update({
          'title': title,
          'content': content,
          'category': category,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id)
        .eq('user_id', user.id);
  }

  Future<void> deleteNote(String id) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.from('notes').delete().eq('id', id).eq('user_id', user.id);
  }
}
