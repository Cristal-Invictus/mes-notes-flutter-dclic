class Note {
  final int? id;
  final String titre;
  final String contenu;
  final String dateCreation;

  const Note({
    this.id,
    required this.titre,
    required this.contenu,
    required this.dateCreation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'contenu': contenu,
      'date_creation': dateCreation,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      titre: map['titre'] as String,
      contenu: map['contenu'] as String,
      dateCreation: map['date_creation'] as String,
    );
  }

  Note copyWith({
    int? id,
    String? titre,
    String? contenu,
    String? dateCreation,
  }) {
    return Note(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      dateCreation: dateCreation ?? this.dateCreation,
    );
  }
}
