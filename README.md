# mlkit_translate (app_translate)

![logo.png](https://github.com/NourCharfi/mlkit_translate/blob/main/logo.png?raw=true)

Résumé
------
mlkit_translate est une application Flutter développée pour démontrer l'utilisation de Google ML Kit en traitement d'image et traduction on-device. Le projet illustre un pipeline simple : capture d'image → reconnaissance de texte (OCR) → traduction du texte détecté — tout en respectant les bonnes pratiques de développement mobile.

Objectifs pédagogiques
---------------------
- Comprendre l'intégration de SDK natifs dans une application Flutter.
- Expérimenter la reconnaissance de texte (OCR) avec `google_mlkit_text_recognition`.
- Implémenter la traduction on-device avec `google_mlkit_translation`.
- Maîtriser la gestion des permissions, de la caméra et du stockage sur Android/iOS.
- Produire une application prête pour démonstration en soutenance ou portfolio.

Fonctionnalités
--------------
- Capture d'images via la caméra ou import depuis la galerie.
- Détection et extraction automatique du texte présent sur l'image (OCR).
- Traduction locale (on-device) du texte détecté vers la langue cible.
- Gestion des permissions et états (modèle téléchargé / non téléchargé).
- Exemple d'UI simple pour visualiser texte source et traduction.

Technologies & dépendances principales
-------------------------------------
- Flutter (Dart) — SDK UI
- google_mlkit_text_recognition
- google_mlkit_translation
- camera
- image_picker
- permission_handler
- path_provider

Prérequis
---------
- Flutter SDK >= 3.7.0
- Android Studio (ou Xcode pour iOS) avec émulateur ou appareil réel
- Connexion Internet lors du premier téléchargement de certains modèles ML (si nécessaire)

Installation rapide
------------------
1. Cloner le dépôt :
   ```bash
   git clone https://github.com/NourCharfi/mlkit_translate.git
   cd mlkit_translate
   ```

2. Installer les dépendances :
   ```bash
   flutter pub get
   ```

3. Lancer l'application :
   ```bash
   flutter run -d <device-id>
   ```

Configuration Android & iOS (essentiels)
----------------------------------------
Android
- Vérifier `android/app/build.gradle` : minSdkVersion compatible avec les dépendances.
- Ajouter les permissions dans `android/app/src/main/AndroidManifest.xml` :
  ```xml
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
  <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  ```
- Pour Android 13+ : adapter les permissions de média si besoin.

iOS
- Dans `ios/Runner/Info.plist`, ajouter :
  - `NSCameraUsageDescription`
  - `NSPhotoLibraryUsageDescription`

Remarques
--------
- Certaines étapes natives (setup Gradle, modifs Info.plist) peuvent être nécessaires selon la version des plugins.
- Consulte toujours la documentation des packages sur pub.dev pour les dernières instructions :
  - https://pub.dev/packages/google_mlkit_text_recognition
  - https://pub.dev/packages/google_mlkit_translation

Exemple de flux (concept)
-------------------------
1. Obtenir une image (camera/gallery).
2. Créer un `InputImage` et appeler `TextRecognizer` pour extraire le texte.
3. Initialiser un traducteur on-device et traduire le texte (s'assurer que le modèle cible est téléchargé).
4. Afficher texte original et traduction.

Exemple de code (pseudocode — vérifier signatures réelles)
```dart
final inputImage = InputImage.fromFilePath(imagePath);
final textRecognizer = TextRecognizer();
final RecognizedText recognized = await textRecognizer.processImage(inputImage);
final String sourceText = recognized.text;
await textRecognizer.close();

final translator = OnDeviceTranslator(
  sourceLanguage: TranslateLanguage.english,
  targetLanguage: TranslateLanguage.french,
);
await translator.downloadModelIfNeeded();
final String translated = await translator.translateText(sourceText);
await translator.close();
```

Structure du projet
------------------
- lib/          — code source Flutter (UI, logique)
- android/      — code natif Android
- ios/          — code natif iOS
- assets/       — images et ressources (ex: `assets/images/`)
- test/         — tests unitaires / widget tests
- pubspec.yaml  — dépendances et configuration Flutter

Crédits & références
--------------------
- Google ML Kit — https://developers.google.com/ml-kit
- Packages Dart/Flutter sur pub.dev :
  - google_mlkit_text_recognition
  - google_mlkit_translation
