import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mygrants/screens/pre_login/auth_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  Future<void> _selectLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    // Save language preference to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);

    // Navigate to auth screen
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/172.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Spacer(),

              // Language buttons at the bottom
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // English button
                    _buildLanguageButton(
                      context,
                      label: 'English',
                      onTap: () => _selectLanguage(context, 'en'),
                    ),
                    const SizedBox(width: 16),

                    // Chinese button
                    _buildLanguageButton(
                      context,
                      label: '中文',
                      onTap: () => _selectLanguage(context, 'zh'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E35B1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
