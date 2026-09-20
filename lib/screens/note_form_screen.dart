import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note;

  const NoteFormScreen({
    super.key,
    this.note,
  });

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titreController;
  late final TextEditingController _contenuController;

  bool _isSaving = false;

  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();

    _titreController = TextEditingController(
      text: widget.note?.titre ?? '',
    );

    _contenuController = TextEditingController(
      text: widget.note?.contenu ?? '',
    );
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      if (_isEditing) {
        final noteModifiee = Note(
          id: widget.note!.id,
          titre: _titreController.text.trim(),
          contenu: _contenuController.text.trim(),
          dateCreation: widget.note!.dateCreation,
        );

        await DatabaseHelper.instance.modifierNote(noteModifiee);
      } else {
        final nouvelleNote = Note(
          titre: _titreController.text.trim(),
          contenu: _contenuController.text.trim(),
          dateCreation: DateTime.now().toIso8601String(),
        );

        await DatabaseHelper.instance.ajouterNote(nouvelleNote);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Une erreur est survenue lors de l’enregistrement.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2585E8),
        foregroundColor: Colors.white,
        title: Text(
          _isEditing ? 'Modifier la note' : 'Nouvelle note',
        ),
        actions: [
          IconButton(
            tooltip: 'Enregistrer',
            onPressed: _isSaving ? null : _enregistrer,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Titre',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _titreController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Entrez le titre de la note...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir un titre.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 24),

                const Text(
                  'Contenu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _contenuController,
                  maxLines: 10,
                  minLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Écrivez votre note ici...',
                    filled: true,
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez saisir le contenu de la note.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _enregistrer,
                    icon: _isSaving
                        ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving
                          ? 'Enregistrement...'
                          : 'Enregistrer',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
