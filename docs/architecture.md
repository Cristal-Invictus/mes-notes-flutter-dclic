# Architecture de l'application Mes Notes

## 1. Présentation

Mes Notes est une application mobile Flutter permettant à un utilisateur authentifié de créer, consulter, rechercher, modifier et supprimer des notes stockées localement.

L'application repose sur une architecture simple séparant :

- l'interface utilisateur ;
- l'accès aux données ;
- les modèles ;
- les services de session.

---

## 2. Organisation générale

```text
lib/
├── database/
│   └── database_helper.dart
│
├── models/
│   └── note.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── notes_screen.dart
│   └── note_form_screen.dart
│
├── services/
│   └── session_service.dart
│
└── main.dart
```

---

## 3. Point d'entrée

Le fichier `main.dart` constitue le point d'entrée de l'application.

Au démarrage, il initialise Flutter puis vérifie si une session utilisateur a été conservée.

```text
Démarrage
   ↓
Vérification de la session
   ↓
Session présente ?
   ├── Oui → Mes Notes
   └── Non → Connexion
```

---

## 4. Couche interface

### LoginScreen

`login_screen.dart` gère l'interface de connexion.

Il permet :

- la saisie du nom d'utilisateur ;
- la saisie du mot de passe ;
- l'affichage ou le masquage du mot de passe ;
- la gestion des erreurs de connexion ;
- l'option « Se souvenir de moi ».

L'écran interroge `DatabaseHelper` pour vérifier les identifiants.

### NotesScreen

`notes_screen.dart` est l'écran principal de l'application.

Il assure :

- l'affichage des notes ;
- la recherche ;
- l'accès au formulaire d'ajout ;
- la modification ;
- la suppression ;
- la déconnexion.

### NoteFormScreen

`note_form_screen.dart` sert à la fois pour la création et la modification.

Lorsqu'aucune note n'est fournie, le formulaire crée une nouvelle note.

Lorsqu'une note existante est fournie, les champs sont préremplis afin de permettre sa modification.

---

## 5. Modèle de données

Le fichier `models/note.dart` représente une note.

Une note possède :

```text
id
titre
contenu
dateCreation
```

Le modèle assure également la conversion entre un objet Dart et une ligne SQLite.

```text
Objet Note
   ↓
toMap()
   ↓
SQLite
```

et :

```text
SQLite
   ↓
fromMap()
   ↓
Objet Note
```

---

## 6. Base de données

La classe `DatabaseHelper` centralise toutes les opérations SQLite.

La base utilisée est :

```text
mes_notes.db
```

Elle contient deux tables principales :

```text
notes
users
```

### Table notes

Elle contient les notes enregistrées par l'utilisateur.

### Table users

Elle contient les données nécessaires à l'authentification locale.

Le mot de passe n'est pas stocké directement.

Un hash est généré avant son stockage et sa comparaison.

---

## 7. CRUD

Les principales opérations sont :

```text
CREATE → ajouterNote()
READ   → obtenirNotes()
UPDATE → modifierNote()
DELETE → supprimerNote()
```

Ces méthodes permettent à l'interface de manipuler les notes sans exécuter directement du SQL.

---

## 8. Gestion de session

Le fichier `session_service.dart` utilise `SharedPreferences`.

Il permet de conserver uniquement l'information indiquant si l'utilisateur souhaite rester connecté.

```text
remember_me = true
```

Aucun mot de passe n'est stocké dans `SharedPreferences`.

Lors d'une déconnexion, l'information de session est supprimée.

---

## 9. Navigation

La navigation entre les écrans utilise `Navigator`.

```text
LoginScreen
     ↓
NotesScreen
     ↓
NoteFormScreen
```

Après une connexion réussie, `Navigator.pushReplacement()` empêche le retour vers l'écran de connexion avec le bouton retour.

Lors de la déconnexion, la pile de navigation est nettoyée avant de revenir à `LoginScreen`.

---

## 10. Gestion des erreurs

L'application traite plusieurs situations :

```text
Identifiants incorrects
Champs obligatoires vides
Erreur de lecture SQLite
Erreur d'enregistrement
Suppression accidentelle
```

Des messages explicites sont affichés à l'utilisateur.

---

## 11. Choix UX

L'application utilise Material Design 3.

La couleur principale est :

```text
#2585E8
```

Les actions principales sont représentées par des icônes facilement identifiables :

```text
+   Ajouter
✏️  Modifier
🗑️  Supprimer
↪   Déconnexion
```

Une confirmation est demandée avant toute suppression ou déconnexion.

---

## 12. Écoconception

L'application adopte plusieurs choix simples :

```text
Stockage local
Pas de serveur distant
Pas de requêtes réseau permanentes
Interface légère
Dépendances limitées
Données chargées à la demande
```

Cela réduit les échanges réseau et limite les ressources nécessaires au fonctionnement de l'application.
