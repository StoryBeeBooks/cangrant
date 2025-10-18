import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cangrant/main.dart';
import 'package:cangrant/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English (US)';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English (US)', 'nativeName': 'English'},
    {'code': 'zh', 'name': 'Chinese (Simplified)', 'nativeName': '简体中文'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    setState(() {
      _selectedLanguage =
          _languages.firstWhere(
            (lang) => lang['code'] == languageCode,
            orElse: () => _languages[0],
          )['name'] ??
          'English (US)';
    });
  }

  Future<void> _saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);

    // Update the app locale
    if (context.mounted) {
      MyApp.setLocale(context, Locale(languageCode));
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('select_language')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _selectedLanguage),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final language = _languages[index];
            final isSelected = _selectedLanguage == language['name'];

            return ListTile(
              title: Text(language['name']!),
              subtitle: Text(language['nativeName']!),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Color(0xFF5E35B1))
                  : null,
              onTap: () async {
                setState(() {
                  _selectedLanguage = language['name']!;
                });
                await _saveLanguage(language['code']!);
                if (context.mounted) {
                  Navigator.pop(context, _selectedLanguage);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
