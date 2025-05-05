import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import '../services/translation_service.dart';
import 'camera_screen.dart';
import 'splash_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _translationService = TranslationService();
  final _textController = TextEditingController();
  String _translatedText = '';
  bool _isLoading = false;

  // Langues disponibles
  final List<String> _languages = [
    'Afrikaans',
    'Albanais',
    'Allemand',
    'Anglais',
    'Arabe',
    'Arménien',
    'Azéri',
    'Bengali',
    'Bulgare',
    'Catalan',
    'Chinois (simplifié)',
    'Chinois (traditionnel)',
    'Coréen',
    'Croate',
    'Danois',
    'Espagnol',
    'Estonien',
    'Finnois',
    'Français',
    'Géorgien',
    'Grec',
    'Gujarati',
    'Hébreu',
    'Hindi',
    'Hongrois',
    'Indonésien',
    'Irlandais',
    'Islandais',
    'Italien',
    'Japonais',
    'Kannada',
    'Kazakh',
    'Kirghiz',
    'Letton',
    'Lituanien',
    'Macédonien',
    'Malais',
    'Malayalam',
    'Marathi',
    'Mongol',
    'Néerlandais',
    'Norvégien',
    'Ourdou',
    'Pendjabi',
    'Persan',
    'Polonais',
    'Portugais',
    'Roumain',
    'Russe',
    'Serbe',
    'Slovaque',
    'Slovène',
    'Suédois',
    'Swahili',
    'Tamoul',
    'Tchèque',
    'Thaï',
    'Turc',
    'Ukrainien',
    'Vietnamien',
  ];

  // Langues sélectionnées
  String _sourceLanguage = 'Français';
  String _targetLanguage = 'Anglais';

  // Map pour convertir les noms de langues en codes ML Kit
  final Map<String, TranslateLanguage> _languageCodes = {
    'Afrikaans': TranslateLanguage.afrikaans,
    'Albanais': TranslateLanguage.albanian,
    'Allemand': TranslateLanguage.german,
    'Anglais': TranslateLanguage.english,
    'Arabe': TranslateLanguage.arabic,
    'Bengali': TranslateLanguage.bengali,
    'Bulgare': TranslateLanguage.bulgarian,
    'Catalan': TranslateLanguage.catalan,
    'Chinois (simplifié)': TranslateLanguage.chinese,
    'Coréen': TranslateLanguage.korean,
    'Croate': TranslateLanguage.croatian,
    'Danois': TranslateLanguage.danish,
    'Espagnol': TranslateLanguage.spanish,
    'Estonien': TranslateLanguage.estonian,
    'Finnois': TranslateLanguage.finnish,
    'Français': TranslateLanguage.french,
    'Géorgien': TranslateLanguage.georgian,
    'Grec': TranslateLanguage.greek,
    'Gujarati': TranslateLanguage.gujarati,
    'Hébreu': TranslateLanguage.hebrew,
    'Hindi': TranslateLanguage.hindi,
    'Hongrois': TranslateLanguage.hungarian,
    'Indonésien': TranslateLanguage.indonesian,
    'Irlandais': TranslateLanguage.irish,
    'Islandais': TranslateLanguage.icelandic,
    'Italien': TranslateLanguage.italian,
    'Japonais': TranslateLanguage.japanese,
    'Kannada': TranslateLanguage.kannada,
    'Letton': TranslateLanguage.latvian,
    'Lituanien': TranslateLanguage.lithuanian,
    'Macédonien': TranslateLanguage.macedonian,
    'Malais': TranslateLanguage.malay,
    'Marathi': TranslateLanguage.marathi,
    'Néerlandais': TranslateLanguage.dutch,
    'Norvégien': TranslateLanguage.norwegian,
    'Ourdou': TranslateLanguage.urdu,
    'Persan': TranslateLanguage.persian,
    'Polonais': TranslateLanguage.polish,
    'Portugais': TranslateLanguage.portuguese,
    'Roumain': TranslateLanguage.romanian,
    'Russe': TranslateLanguage.russian,
    'Slovaque': TranslateLanguage.slovak,
    'Slovène': TranslateLanguage.slovenian,
    'Suédois': TranslateLanguage.swedish,
    'Swahili': TranslateLanguage.swahili,
    'Tamoul': TranslateLanguage.tamil,
    'Tchèque': TranslateLanguage.czech,
    'Thaï': TranslateLanguage.thai,
    'Turc': TranslateLanguage.turkish,
    'Ukrainien': TranslateLanguage.ukrainian,
    'Vietnamien': TranslateLanguage.vietnamese,
  };

  @override
  void dispose() {
    _translationService.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _translateText() async {
    if (_textController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez entrer un texte à traduire'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final translator = OnDeviceTranslator(
        sourceLanguage: _languageCodes[_sourceLanguage]!,
        targetLanguage: _languageCodes[_targetLanguage]!,
      );
      final result = await translator.translateText(_textController.text);
      translator.close();
      setState(() {
        _translatedText = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de traduction: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isLoading = true);
      try {
        final text = await _translationService.recognizeTextFromImage(image.path);
        
        if (text.trim().isEmpty) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Aucun texte détecté dans l\'image'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          return;
        }

        final translator = OnDeviceTranslator(
          sourceLanguage: _languageCodes[_sourceLanguage]!,
          targetLanguage: _languageCodes[_targetLanguage]!,
        );
        final translation = await translator.translateText(text);
        translator.close();
        setState(() {
          _textController.text = text;
          _translatedText = translation;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'extraction du texte: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erreur lors de la sélection de l\'image'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _openCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
          languageCodes: _languageCodes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traducteur ML Kit'),
        centerTitle: true,
        elevation: 0,
        actions: [
          Tooltip(
            message: Theme.of(context).brightness == Brightness.dark
                ? 'Passer en mode clair'
                : 'Passer en mode sombre',
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                key: ValueKey(Theme.of(context).brightness),
                icon: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: widget.onThemeToggle,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Sélection des langues avec des cartes
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Langues',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Source',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _sourceLanguage,
                                          isExpanded: true,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          dropdownColor: Theme.of(context).colorScheme.surface,
                                          items: _languages.map((String language) {
                                            return DropdownMenuItem<String>(
                                              value: language,
                                              child: Text(
                                                language,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                _sourceLanguage = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Cible',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Theme.of(context).colorScheme.outline,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: _targetLanguage,
                                          isExpanded: true,
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          dropdownColor: Theme.of(context).colorScheme.surface,
                                          items: _languages.map((String language) {
                                            return DropdownMenuItem<String>(
                                              value: language,
                                              child: Text(
                                                language,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue != null) {
                                              setState(() {
                                                _targetLanguage = newValue;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Champ de texte avec une carte
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Texte à traduire',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _textController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Entrez le texte à traduire...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _translateText,
                              icon: const Icon(Icons.translate),
                              label: const Text('Traduire'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Résultat de la traduction
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (_translatedText.isNotEmpty)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Traduction',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _translatedText,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Barre d'outils en bas avec des icônes modernes
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildToolButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Caméra',
                    onPressed: _openCamera,
                  ),
                  _buildToolButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Galerie',
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}