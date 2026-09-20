import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      'mes_notes.db',
    );

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titre TEXT NOT NULL,
        contenu TEXT NOT NULL,
        date_creation TEXT NOT NULL
      )
    ''');
  }

  Future<int> ajouterNote(Note note) async {
    final db = await database;

    return await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> obtenirNotes() async {
    final db = await database;

    final maps = await db.query(
      'notes',
      orderBy: 'id DESC',
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  Future<int> modifierNote(Note note) async {
    final db = await database;

    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> supprimerNote(int id) async {
    final db = await database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
