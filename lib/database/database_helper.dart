import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  // =========================================================
  // ACCÈS À LA BASE DE DONNÉES
  // =========================================================

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

    return openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  // =========================================================
  // CRÉATION DE LA BASE
  // =========================================================

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

    await _createUsersTable(db);
  }

  // =========================================================
  // MIGRATION VERSION 1 → VERSION 2
  // =========================================================

  Future<void> _upgradeDatabase(
      Database db,
      int oldVersion,
      int newVersion,
      ) async {
    if (oldVersion < 2) {
      await _createUsersTable(db);
    }
  }

  // =========================================================
  // TABLE UTILISATEURS
  // =========================================================

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL
      )
    ''');

    // Compte administrateur de démonstration.
    const username = 'admin';
    const password = '1234';

    // Sel utilisé pour le compte de démonstration.
    const salt = '26e270df7b4e40501a3b75c1f4f02ff2';

    final passwordHash = _hashPassword(
      password,
      salt,
    );

    await db.insert(
      'users',
      {
        'username': username,
        'password_hash': passwordHash,
        'salt': salt,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // =========================================================
  // HASH DU MOT DE PASSE
  // =========================================================

  String _hashPassword(
      String password,
      String salt,
      ) {
    final bytes = utf8.encode(
      '$salt$password',
    );

    return sha256.convert(bytes).toString();
  }

  // =========================================================
  // AUTHENTIFICATION
  // =========================================================

  Future<bool> authentifierUtilisateur(
      String username,
      String password,
      ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (result.isEmpty) {
      return false;
    }

    final user = result.first;

    final salt = user['salt'] as String;
    final storedHash = user['password_hash'] as String;

    final enteredHash = _hashPassword(
      password,
      salt,
    );

    return enteredHash == storedHash;
  }

  // =========================================================
  // CREATE — AJOUTER UNE NOTE
  // =========================================================

  Future<int> ajouterNote(Note note) async {
    final db = await database;

    return db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // =========================================================
  // READ — RÉCUPÉRER LES NOTES
  // =========================================================

  Future<List<Note>> obtenirNotes() async {
    final db = await database;

    final maps = await db.query(
      'notes',
      orderBy: 'id DESC',
    );

    return maps
        .map(
          (map) => Note.fromMap(map),
    )
        .toList();
  }

  // =========================================================
  // UPDATE — MODIFIER UNE NOTE
  // =========================================================

  Future<int> modifierNote(Note note) async {
    final db = await database;

    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // =========================================================
  // DELETE — SUPPRIMER UNE NOTE
  // =========================================================

  Future<int> supprimerNote(int id) async {
    final db = await database;

    return db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
