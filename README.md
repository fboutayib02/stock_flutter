# Stock Flutter — Suivi carburant & entretien

Application mobile Flutter (partiel Vip Coding) : suivi de pleins et d’entretiens par conducteur, avec **DDDA**, **GoRouter**, **Riverpod**, **dio** et **Firebase** (Auth + Firestore).

- Dépôt GitHub : [fboutayib02/stock_flutter](https://github.com/fboutayib02/stock_flutter.git)
- Collaborateur à inviter : **M-Lahmer**

> Le sujet demande `tracker_flutter` ; votre dépôt `stock_flutter` convient si le formateur l’accepte.

## Architecture (DDDA)

**DDDA** = 4 couches séparées (pas seulement des dossiers « DDD ») :

| Couche | Rôle | Dossier |
|--------|------|---------|
| **D**omaine | Entités + contrats (`abstract` repositories) | `lib/domain/` |
| **D**onnées | Modèles Firestore + implémentations | `lib/data/` |
| **A**pplication | Cas d’utilisation (use cases) | `lib/application/use_cases/` |
| **D**esign | UI Flutter + Riverpod + GoRouter | `lib/presentation/` |

Règle de dépendance : **Design → Application → Domaine ← Données**.  
L’UI n’appelle jamais Firestore directement, seulement des **use cases**.

```
lib/
├── core/              # router, dio, DI repositories
├── domain/
├── data/
├── application/       # use_cases/ + di/
├── presentation/
├── app.dart
└── main.dart
```

**Multi-tenant** : chaque conducteur a ses données sous `users/{userId}/…`.

## Prérequis

1. [Flutter](https://docs.flutter.dev/get-started/install) installé
2. Projet [Firebase Console](https://console.firebase.google.com/) avec :
   - **Authentication** → Email / mot de passe activé
   - **Cloud Firestore** activé
3. Sur Windows : activer le **mode développeur** (symlinks pour les plugins Firebase)

## Configuration Firebase

```bash
cd stock_flutter
dart pub global activate flutterfire_cli
flutterfire configure
```

Cela remplace `lib/firebase_options.dart` et ajoute les fichiers natifs (`google-services.json`, etc.).

Déployez les règles de sécurité :

```bash
firebase deploy --only firestore
```

(`firestore.rules` + `firestore.indexes.json` à la racine)

## Lancer l’app

```bash
flutter pub get
flutter run
```

## Fonctionnalités

| Fonction | Écran / route |
|----------|----------------|
| Connexion conducteur | `/login` |
| Liste véhicules + stats mensuelles | `/` |
| Ajouter véhicule | `/vehicles/add` |
| Plein carburant | `/fuel/add` |
| Historique carburant (filtres date / véhicule) | `/fuel/history` |
| Entretien | `/maintenance/add` |
| Historique entretiens (filtre date / véhicule) | `/maintenance/history` |
| Conseil éco-conduite (API via **dio**) | Carte sur le dashboard |

## Git — commits & push

Après chaque modification significative :

```bash
git add .
git commit -m "feat: description courte"
git push origin master
```

## Livrables finaux (sujet)

- Inviter **M-Lahmer** sur le dépôt GitHub
- Noter le **temps passé** et les **tokens** consommés après validation des tests
