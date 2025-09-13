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

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notas"),
        backgroundColor: Colors.green.shade700,
      ),
      body: notes.isEmpty
          ? const Center(child: Text("Nenhuma nota ainda"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.shade300,
                        child: Text(
                          note.title.isNotEmpty
                              ? note.title[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        note.title.isNotEmpty ? note.title : "Sem título",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      subtitle: Text(
                        note.content.isNotEmpty
                            ? note.content
                            : "Sem conteúdo",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        _formatDate(note.createdAt),
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () => _navigateToEdit(note: note),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        onPressed: () => _navigateToEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
