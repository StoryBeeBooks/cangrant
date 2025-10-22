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
          // Background image covering full screen dynamically
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use BoxFit.cover to fill the screen while maintaining aspect ratio
                return Image.asset(
                  'assets/images/172.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                );
              },
            ),
          ),

          // Language buttons
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),

                // Language buttons at the bottom
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                    vertical: MediaQuery.of(context).size.height * 0.05,
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
                      SizedBox(width: MediaQuery.of(context).size.width * 0.05),

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
    // Calculate responsive button size
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth * 0.25).clamp(100.0, 130.0);
    final buttonHeight = (screenWidth * 0.12).clamp(45.0, 60.0);

    return Container(
      width: buttonWidth,
      height: buttonHeight,
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
              style: TextStyle(
                fontSize: (screenWidth * 0.04).clamp(14.0, 18.0),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF7BA4BC), // Blue from the sailboat/water
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
