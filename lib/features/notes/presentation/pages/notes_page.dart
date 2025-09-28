import 'package:flutter/material.dart';
import '../../data/repositories/note_repository.dart';
import '../../data/models/note_model.dart';
import 'note_mdx_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteRepository repository = NoteRepository();
  List<NoteModel> notes = [];
  List<NoteModel> filteredNotes = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final result = await repository.getNotes();
    setState(() {
      notes = result;
      filteredNotes = result;
    });
  }

  Future<void> _navigateToEdit({NoteModel? note}) async {
    final saved = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteMdxPage(note: note)),
    );
    if (saved == true) {
      _loadNotes();
    }
  }

  Future<void> _togglePin(NoteModel note) async {
    await repository.togglePinNote(note.id!, !note.isPinned);
    _loadNotes();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note.isPinned ? 'Nota desfixada' : 'Nota fixada no topo'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _startSearch() {
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      isSearching = false;
      searchController.clear();
      filteredNotes = notes;
    });
  }

  void _filterNotes(String query) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      filteredNotes =
          notes.where((note) {
            return note.title.toLowerCase().contains(lowerQuery) ||
                note.content.toLowerCase().contains(lowerQuery);
          }).toList();
    });
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
    final primaryColor = Colors.blue.shade600;
    final accentColor = Colors.blue.shade400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title:
            !isSearching
                ? const Text("Notas", style: TextStyle(color: Colors.white))
                : TextField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Buscar notas...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  onChanged: _filterNotes,
                ),
        actions: [
          !isSearching
              ? IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: _startSearch,
              )
              : IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _stopSearch,
              ),
        ],
      ),
      body:
          filteredNotes.isEmpty
              ? const Center(
                child: Text(
                  "Nenhuma nota ainda",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
              : ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
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
                        title: Row(
                          children: [
                            if (note.isPinned) ...[
                              Icon(
                                Icons.push_pin,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                note.title.isNotEmpty
                                    ? note.title
                                    : "Sem título",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDate(note.createdAt),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'pin') {
                                  _togglePin(note);
                                }
                              },
                              itemBuilder:
                                  (context) => [
                                    PopupMenuItem(
                                      value: 'pin',
                                      child: Row(
                                        children: [
                                          Icon(
                                            note.isPinned
                                                ? Icons.push_pin_outlined
                                                : Icons.push_pin,
                                            size: 20,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            note.isPinned
                                                ? 'Desafixar'
                                                : 'Fixar',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ],
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
