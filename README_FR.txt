AH CARGO — Projet de départ Flutter

IMPORTANT
Cette archive contient une première base de code source, pas un APK prêt à installer.
Elle est indépendante de votre ancienne application.

Contenu de cette première étape
- Écran de connexion avec nom d'agent et mot de passe de démonstration KAGO26
- Sections Arrivées, Départs et Cargo
- Ajout manuel d'une opération : numéro de vol, indicatif avion, provenance/destination, heure, parking et notes
- Saisie automatiquement convertie en majuscules pour les codes
- Bouton ON/OFF de démonstration pour les alertes
- Crédit discret « Développé par Benterki Mohamed »

À compléter avant utilisation réelle
- Connexion à une base cloud sécurisée et synchronisation multi-téléphones
- Authentification réelle : le mot de passe intégré ici est uniquement une maquette et ne protège pas les données
- Alertes Android en arrière-plan / plein écran, permissions et tests sur les téléphones cibles
- Gestion des images des avions et stockage cloud
- Historique des modifications, suivi « À suivre », édition/suppression et filtres Interne/Externe fiables
- Tests et signature de l'APK

Pour ouvrir le projet
1. Installer Flutter SDK et Android Studio sur un ordinateur.
2. Extraire le ZIP.
3. Dans le dossier AH_Cargo, exécuter : flutter pub get
4. Puis : flutter run
5. Pour générer un APK de test : flutter build apk --debug
   Le fichier sera créé dans build/app/outputs/flutter-apk/app-debug.apk

Le SDK Flutter n'est pas inclus dans cette archive.
