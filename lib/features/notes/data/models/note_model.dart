class NoteModel {
  final int? id;
  final String title;
  final String content;
  final DateTime createdAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    // Validação básica dos campos obrigatórios
    if (map['title'] == null) {
      throw ArgumentError('Campo title é obrigatório');
    }
    if (map['content'] == null) {
      throw ArgumentError('Campo content é obrigatório');
    }
    if (map['createdAt'] == null) {
      throw ArgumentError('Campo createdAt é obrigatório');
    }

    return NoteModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  // Método toString para facilitar debugging
  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: $content, createdAt: $createdAt)';
  }

  // Operadores de igualdade para comparar instâncias
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteModel &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, content, createdAt);

  // Método para criar cópia com alterações
  NoteModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
