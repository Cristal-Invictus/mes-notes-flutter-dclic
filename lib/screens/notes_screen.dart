import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';
import 'note_form_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> _notes = [];
  List<Note> _notesFiltrees = [];

  bool _isLoading = true;

  final TextEditingController _searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _chargerNotes();

    _searchController.addListener(_filtrerNotes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filtrerNotes);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _chargerNotes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notes = await DatabaseHelper.instance.obtenirNotes();

      if (!mounted) return;

      setState(() {
        _notes = notes;
        _notesFiltrees = notes;
        _isLoading = false;
      });

      _filtrerNotes();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible de charger les notes.',
          ),
        ),
      );
    }
  }

  void _filtrerNotes() {
    final recherche = _searchController.text
        .trim()
        .toLowerCase();

    setState(() {
      if (recherche.isEmpty) {
        _notesFiltrees = List.from(_notes);
      } else {
        _notesFiltrees = _notes.where((note) {
          return note.titre.toLowerCase().contains(recherche) ||
              note.contenu.toLowerCase().contains(recherche);
        }).toList();
      }
    });
  }

  Future<void> _ouvrirFormulaire({
    Note? note,
  }) async {
    final resultat = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => NoteFormScreen(
          note: note,
        ),
      ),
    );

    if (resultat == true) {
      await _chargerNotes();
    }
  }

  Future<void> _supprimerNote(Note note) async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer la note ?'),
          content: Text(
            'Voulez-vous vraiment supprimer « ${note.titre} » ?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmer != true || note.id == null) {
      return;
    }

    await DatabaseHelper.instance.supprimerNote(note.id!);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note supprimée.'),
      ),
    );

    await _chargerNotes();
  }

  String _formaterDate(String date) {
    try {
      final parsed = DateTime.parse(date);

      final jour = parsed.day.toString().padLeft(2, '0');
      final mois = parsed.month.toString().padLeft(2, '0');
      final annee = parsed.year;

      return '$jour/$mois/$annee';
    } catch (_) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2585E8),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          'Mes Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2585E8),
        foregroundColor: Colors.white,
        onPressed: () {
          _ouvrirFormulaire();
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                8,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher une note...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : _notesFiltrees.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                onRefresh: _chargerNotes,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    100,
                  ),
                  itemCount: _notesFiltrees.length,
                  itemBuilder: (context, index) {
                    final note = _notesFiltrees[index];

                    return _buildNoteCard(note);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final rechercheActive =
        _searchController.text.trim().isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              rechercheActive
                  ? Icons.search_off
                  : Icons.note_add_outlined,
              size: 72,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              rechercheActive
                  ? 'Aucune note trouvée'
                  : 'Aucune note pour le moment',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              rechercheActive
                  ? 'Essayez un autre mot-clé.'
                  : 'Appuyez sur le bouton + pour créer votre première note.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          _ouvrirFormulaire(note: note);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  color: Color(0xFF2585E8),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.titre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      note.contenu,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _formaterDate(note.dateCreation),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  IconButton(
                    tooltip: 'Modifier',
                    onPressed: () {
                      _ouvrirFormulaire(note: note);
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Supprimer',
                    onPressed: () {
                      _supprimerNote(note);
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
