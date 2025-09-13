import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';

class NoteEditPage extends StatefulWidget {
  final NoteModel? note; // se vier preenchida, é edição

  const NoteEditPage({super.key, this.note});

  @override
  State<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends State<NoteEditPage> {
  final NoteRepository repository = NoteRepository();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final note = NoteModel(
      id: widget.note?.id,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );

    if (widget.note == null) {
      await repository.insertNote(note);
    } else {
      await repository.updateNote(note);
    }

    Navigator.pop(context, true);
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "Nova Nota" : "Editar Nota"),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await repository.deleteNote(widget.note!.id!);
                Navigator.pop(context, true);
              },
            ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Título",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "Escreva sua nota...",
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
