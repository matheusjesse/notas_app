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
    final maps = await db.query('notes', orderBy: 'createdAt DESC');
    return maps.map((map) => NoteModel.fromMap(map)).toList();
  }
}
