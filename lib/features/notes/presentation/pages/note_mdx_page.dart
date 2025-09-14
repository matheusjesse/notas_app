import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';

class NoteMdxPage extends StatefulWidget {
  final NoteModel? note;

  const NoteMdxPage({super.key, this.note});

  @override
  State<NoteMdxPage> createState() => _NoteMdxPageState();
}

class _NoteMdxPageState extends State<NoteMdxPage> {
  final NoteRepository repository = NoteRepository();
  bool isEditing = false;
  late TextEditingController _controller;
  NoteModel?
  _currentNote; // Adicionar nota atual para manter os dados atualizados
  bool _hasBeenModified = false; // Para rastrear se houve modificações

  @override
  void initState() {
    super.initState();
    // Se estiver criando nova nota, já entra em edição
    isEditing = widget.note == null;
    _currentNote = widget.note; // Inicializar com a nota passada
    _controller = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final lines = _controller.text.split('\n');
    String title = _currentNote?.title ?? "Nova Nota";
    String content =
        _controller.text; // Preservar o conteúdo original integralmente

    // Se a primeira linha for um cabeçalho markdown (#), usa como título
    if (lines.isNotEmpty && lines[0].trim().startsWith('#')) {
      title = lines[0].replaceFirst('#', '').trim();
      // NÃO remover a primeira linha do conteúdo - preservar tudo
    } else if (lines.isNotEmpty && lines[0].trim().isNotEmpty) {
      // Se não for cabeçalho, usa a primeira linha como título
      title = lines[0].trim();
    }

    final note = NoteModel(
      id: _currentNote?.id,
      title: title,
      content: content, // Salvar o conteúdo completo
      createdAt: _currentNote?.createdAt ?? DateTime.now(),
    );

    try {
      if (_currentNote == null) {
        final insertedId = await repository.insertNote(note);
        // Criar a nota atual com o ID correto retornado do banco
        _currentNote = NoteModel(
          id: insertedId,
          title: title,
          content: content,
          createdAt: note.createdAt,
        );
        _hasBeenModified = true;
      } else {
        await repository.updateNote(note);
        // Atualizar a nota atual com os novos dados
        _currentNote = note;
      }

      setState(() {
        isEditing = false;
      });

      // Mostrar feedback que salvou
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nota salva com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Marcar que houve modificação
      _hasBeenModified = true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar nota: $e')));
      }
    }
  }

  void _toggleCheckbox(int lineIndex) {
    final lines = _controller.text.split('\n');
    if (lineIndex < lines.length) {
      final line = lines[lineIndex];
      final checkboxRegex = RegExp(r'^(\s*-?\s*)\[(\s*|x|X)\](\s*.*)');
      final match = checkboxRegex.firstMatch(line);

      if (match != null) {
        final prefix = match.group(1) ?? '';
        final currentState = match.group(2)?.toLowerCase();
        final suffix = match.group(3) ?? '';

        // Alternar estado: se é 'x', muda para ' ', se não é 'x', muda para 'x'
        final newState = currentState == 'x' ? ' ' : 'x';
        lines[lineIndex] = '$prefix[$newState]$suffix';

        _controller.text = lines.join('\n');
        setState(() {});

        // Salvar automaticamente quando um checkbox for alterado
        _saveCheckboxChange();
      }
    }
  }

  Future<void> _saveCheckboxChange() async {
    if (_currentNote != null) {
      final lines = _controller.text.split('\n');
      String title = _currentNote!.title;
      String content = _controller.text;

      // Se a primeira linha for um cabeçalho markdown (#), usa como título
      if (lines.isNotEmpty && lines[0].trim().startsWith('#')) {
        title = lines[0].replaceFirst('#', '').trim();
      } else if (lines.isNotEmpty && lines[0].trim().isNotEmpty) {
        title = lines[0].trim();
      }

      final note = NoteModel(
        id: _currentNote!.id,
        title: title,
        content: content,
        createdAt: _currentNote!.createdAt,
      );

      try {
        await repository.updateNote(note);
        // Atualizar a nota atual com os novos dados
        _currentNote = note;
        // Marcar que houve modificação
        _hasBeenModified = true;
      } catch (e) {
        // Em caso de erro, reverter a mudança
        debugPrint('Erro ao salvar checkbox: $e');
      }
    }
  }

  Future<void> _deleteNote() async {
    if (_currentNote != null && _currentNote!.id != null) {
      await repository.deleteNote(_currentNote!.id!);

      _hasBeenModified = true;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nota deletada!'),
            duration: Duration(seconds: 1),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  String _getCurrentTitle() {
    final lines = _controller.text.split('\n');

    // Se a primeira linha for um cabeçalho markdown (#), usa como título
    if (lines.isNotEmpty && lines[0].trim().startsWith('#')) {
      return lines[0].replaceFirst('#', '').trim();
    } else if (lines.isNotEmpty && lines[0].trim().isNotEmpty) {
      // Se não for cabeçalho, usa a primeira linha como título
      return lines[0].trim();
    }

    return _currentNote?.title ?? "Nova Nota";
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Impede o pop automático
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Sempre retornar o status de modificação
          Navigator.pop(context, _hasBeenModified);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getCurrentTitle()),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _hasBeenModified);
            },
          ),
          actions: [
            if (!isEditing && _currentNote != null)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteNote,
              ),
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () async {
                if (isEditing) {
                  await _saveNote();
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isEditing
                  ? TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText:
                          "Digite sua nota em MDX...\n\nDica: Use # para títulos\n- [ ] para checkboxes",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(
                        () {},
                      ); // Atualiza o título na AppBar quando o conteúdo muda
                    },
                  )
                  : SingleChildScrollView(
                    child: Builder(
                      builder: (context) {
                        // Reset o contador de checkboxes antes de renderizar
                        int checkboxIndex = 0;
                        return MarkdownBody(
                          data: _controller.text,
                          selectable: true,
                          styleSheet: MarkdownStyleSheet(
                            h1: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            h2: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            h3: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            h4: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            p: const TextStyle(fontSize: 16),
                            listBullet: const TextStyle(fontSize: 16),
                          ),
                          checkboxBuilder: (checked) {
                            // Capturar o índice atual antes de incrementar
                            final currentIndex = checkboxIndex++;

                            // Encontrar o índice da linha deste checkbox específico
                            final lines = _controller.text.split('\n');
                            int currentCheckboxCount = 0;
                            int targetLineIndex = -1;

                            for (int i = 0; i < lines.length; i++) {
                              final checkboxRegex = RegExp(
                                r'^(\s*-?\s*)\[(\s*|x|X)\]\s*(.*)',
                              );
                              final match = checkboxRegex.firstMatch(lines[i]);
                              if (match != null) {
                                if (currentCheckboxCount == currentIndex) {
                                  targetLineIndex = i;
                                  break;
                                }
                                currentCheckboxCount++;
                              }
                            }

                            return GestureDetector(
                              onTap: () {
                                if (targetLineIndex >= 0) {
                                  _toggleCheckbox(targetLineIndex);
                                }
                              },
                              child: Transform.translate(
                                offset: const Offset(0, 3),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    checked
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    size: 18,
                                    color: checked ? Colors.green : Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
        ),
      ),
    );
  }
}
