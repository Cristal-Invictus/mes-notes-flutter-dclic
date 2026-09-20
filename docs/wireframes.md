# Wireframes — Mes Notes

## Objectif

Les wireframes ont été réalisés avant le développement afin de définir l'organisation des principales interfaces.

Ils servent de référence pour l'implémentation Flutter.

---

## 1. Écran de connexion

L'écran de connexion contient :

```text
Logo Mes Notes

Mes Notes
Organisez vos idées simplement

Nom d'utilisateur
Mot de passe

☐ Se souvenir de moi

[ Se connecter ]
```

En cas d'erreur :

```text
Identifiant ou mot de passe incorrect.
```

### Objectifs UX

L'interface doit être simple, lisible et permettre de comprendre immédiatement l'action attendue.

---

## 2. Écran principal

Après authentification, l'utilisateur arrive sur l'écran principal.

```text
┌──────────────────────────────┐
│ Mes Notes                  ↪ │
├──────────────────────────────┤
│ 🔍 Rechercher une note...    │
│                              │
│ ┌──────────────────────────┐ │
│ │ Titre de la note        │ │
│ │ Contenu...              │ │
│ │ Date             ✏️ 🗑️ │ │
│ └──────────────────────────┘ │
│                              │
│                         +    │
└──────────────────────────────┘
```

Les actions disponibles sont :

```text
Recherche
Ajout
Modification
Suppression
Déconnexion
```

---

## 3. Ajout d'une note

Le bouton `+` ouvre le formulaire de création.

```text
┌──────────────────────────────┐
│ ← Nouvelle note          ✓   │
├──────────────────────────────┤
│                              │
│ Titre                        │
│ [________________________]   │
│                              │
│ Contenu                      │
│ [                        ]   │
│ [                        ]   │
│ [                        ]   │
│                              │
│      [ Enregistrer ]         │
└──────────────────────────────┘
```

Les deux champs sont obligatoires.

---

## 4. Modification d'une note

La modification reprend le même formulaire.

Les champs sont automatiquement remplis avec les informations existantes.

```text
Modifier la note

Titre
[Titre actuel]

Contenu
[Contenu actuel]

[ Enregistrer ]
```

---

## 5. Suppression

Une confirmation est affichée avant de supprimer définitivement une note.

```text
Supprimer la note ?

Voulez-vous vraiment supprimer cette note ?

[ Annuler ]   [ Supprimer ]
```

---

## 6. Déconnexion

Une confirmation est également demandée :

```text
Déconnexion

Voulez-vous vraiment vous déconnecter ?

[ Annuler ]   [ Se déconnecter ]
```

---

## Correspondance avec l'application

Les interfaces Flutter finales respectent la structure générale définie dans les wireframes tout en appliquant Material Design 3 pour améliorer la lisibilité et l'ergonomie.
