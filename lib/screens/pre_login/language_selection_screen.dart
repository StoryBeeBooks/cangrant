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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      body: Stack(
        children: [
          // Background image covering full screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/172.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // Main content with orientation-aware layout
          SafeArea(
            child: isLandscape
                ? _buildLandscapeLayout(context, screenWidth, screenHeight)
                : _buildPortraitLayout(context, screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  // Portrait layout: Image at top-center, buttons below
  Widget _buildPortraitLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 1),

        // Language background image at upper-middle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.7,
              maxHeight: screenHeight * 0.35,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/language background.jpg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.05),

        // Language buttons below the image
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // English button
              _buildLanguageButton(
                context,
                label: 'English',
                onTap: () => _selectLanguage(context, 'en'),
                screenWidth: screenWidth,
              ),
              SizedBox(width: screenWidth * 0.05),

              // Chinese button
              _buildLanguageButton(
                context,
                label: '中文',
                onTap: () => _selectLanguage(context, 'zh'),
                screenWidth: screenWidth,
              ),
            ],
          ),
        ),

        const Spacer(flex: 2),
      ],
    );
  }

  // Landscape layout: Image on right, buttons on right
  Widget _buildLandscapeLayout(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Row(
      children: [
        // Left side - empty space or can add branding
        const Spacer(flex: 1),

        // Right side - Image and buttons
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Language background image
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.35,
                    maxHeight: screenHeight * 0.5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/language background.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),

              // Language buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // English button
                  _buildLanguageButton(
                    context,
                    label: 'English',
                    onTap: () => _selectLanguage(context, 'en'),
                    screenWidth: screenWidth,
                  ),
                  SizedBox(width: screenWidth * 0.03),

                  // Chinese button
                  _buildLanguageButton(
                    context,
                    label: '中文',
                    onTap: () => _selectLanguage(context, 'zh'),
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageButton(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    required double screenWidth,
  }) {
    // Calculate responsive button size
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
