import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TranslationService {
  final _translator = OnDeviceTranslator(
    sourceLanguage: TranslateLanguage.french,
    targetLanguage: TranslateLanguage.english,
  );

  final _textRecognizer = TextRecognizer();

  Future<String> translateText(String text) async {
    try {
      final result = await _translator.translateText(text);
      return result;
    } catch (e) {
      throw Exception('Erreur de traduction: $e');
    }
  }

  Future<String> recognizeTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception('Erreur de reconnaissance de texte: $e');
    }
  }

  void dispose() {
    _translator.close();
    _textRecognizer.close();
  }
} 