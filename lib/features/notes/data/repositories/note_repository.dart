import 'package:notas_app/core/database/app_database.dart';
import '../models/note_model.dart';

class NoteRepository {
  final AppDatabase _database = AppDatabase();

  Future<int> insertNote(NoteModel note) async {
    final db = await _database.database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<NoteModel>> getNotes() async {
    final db = await _database.database;
    final maps = await db.query(
      'notes',
      orderBy: 'isPinned DESC, createdAt DESC',
    );
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await _database.database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _database.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> togglePinNote(int id, bool isPinned) async {
    final db = await _database.database;
    return await db.update(
      'notes',
      {'isPinned': isPinned ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
