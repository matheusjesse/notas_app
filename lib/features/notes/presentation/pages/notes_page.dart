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
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0 &&
        date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return "Hoje";
    } else if (difference == 1 ||
        (now.day - date.day == 1 &&
            now.month == date.month &&
            now.year == date.year)) {
      return "Ontem";
    } else {
      return "${date.day.toString().padLeft(2, '0')}/"
             "${date.month.toString().padLeft(2, '0')}/"
             "${date.year}";
    }
  }


  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue.shade600; // azul principal
    final accentColor = Colors.blue.shade400;  // azul mais leve (para ícones/avatares)

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notas",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text(
                "Nenhuma nota ainda",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: accentColor,
                        child: Text(
                          note.title.isNotEmpty
                              ? note.title[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        note.title.isNotEmpty ? note.title : "Sem título",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      onTap: () => _navigateToEdit(note: note),
                    ),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () => _navigateToEdit(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
