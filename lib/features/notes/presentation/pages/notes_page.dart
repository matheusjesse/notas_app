import 'package:flutter/material.dart';
import '../../data/repositories/note_repository.dart';
import '../../data/models/note_model.dart';
import 'note_edit_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteRepository repository = NoteRepository();
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final result = await repository.getNotes();
    setState(() {
      notes = result;
    });
  }

  Future<void> _navigateToEdit({NoteModel? note}) async {
    final saved = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditPage(note: note),
      ),
    );
    if (saved == true) {
      _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
      ),
      body: notes.isEmpty
          ? const Center(child: Text("Nenhuma nota ainda"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () => _navigateToEdit(note: note), // abrir edição
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEdit(), // abrir nova nota (igual WhatsApp)
        child: const Icon(Icons.add),
      ),
    );
  }
}
