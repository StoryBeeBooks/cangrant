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
      body: Stack(
        children: [
          // Background image covering full screen
          Positioned.fill(
            child: Image.asset('assets/images/172.png', fit: BoxFit.cover),
          ),

          // Language buttons
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),

                // Language buttons at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 40.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // English button
                      _buildLanguageButton(
                        context,
                        label: 'English',
                        onTap: () => _selectLanguage(context, 'en'),
                      ),
                      const SizedBox(width: 20),

                      // Chinese button
                      _buildLanguageButton(
                        context,
                        label: '中文',
                        onTap: () => _selectLanguage(context, 'zh'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 110,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7BA4BC), // Blue from the sailboat/water
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
