import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mygrants/services/supabase_service.dart';
import 'package:mygrants/screens/pre_login/onboarding_flow.dart';
import 'package:mygrants/screens/main_app/main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseService _supabaseService = SupabaseService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('DEBUG AUTH: Attempting Google sign-in');

      final response = await _supabaseService.signInWithGoogle();

      print(
        'DEBUG AUTH: Google sign-in successful! User: ${response.user?.email}',
      );

      if (mounted) {
        // Check if this is a new user
        final isNewUser =
            response.user?.createdAt == response.user?.lastSignInAt;

        if (isNewUser) {
          // Navigate to onboarding for new users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingFlow()),
          );
        } else {
          // Navigate to main screen for existing users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e) {
      print('DEBUG AUTH: Google sign-in error - $e');
      setState(() {
        String friendlyError = e.toString();
        if (friendlyError.contains('sign-in was cancelled')) {
          _errorMessage = 'Google sign-in was cancelled. Please try again.';
        } else if (friendlyError.contains('network')) {
          _errorMessage =
              'Network error. Please check your connection and try again.';
        } else {
          _errorMessage =
              'Google sign-in failed. ${friendlyError.replaceAll('Exception: ', '').replaceAll('Google sign-in failed: ', '')}';
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('DEBUG AUTH: Attempting Apple sign-in');

      final response = await _supabaseService.signInWithApple();

      print(
        'DEBUG AUTH: Apple sign-in successful! User: ${response.user?.email}',
      );

      if (mounted) {
        // Check if this is a new user
        final isNewUser =
            response.user?.createdAt == response.user?.lastSignInAt;

        if (isNewUser) {
          // Navigate to onboarding for new users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingFlow()),
          );
        } else {
          // Navigate to main screen for existing users
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      }
    } catch (e) {
      print('DEBUG AUTH: Apple sign-in error - $e');
      setState(() {
        String friendlyError = e.toString();
        if (friendlyError.contains('cancelled')) {
          _errorMessage = 'Apple sign-in was cancelled. Please try again.';
        } else if (friendlyError.contains('network')) {
          _errorMessage =
              'Network error. Please check your connection and try again.';
        } else {
          _errorMessage =
              'Apple sign-in failed. ${friendlyError.replaceAll('Exception: ', '').replaceAll('Apple sign-in failed: ', '')}';
        }
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image 172C covering full screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/172C.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),

          // Content overlay - positioned at bottom with better UX/UI design
          SafeArea(
            child: Column(
              children: [
                // Error message at top if present
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.045,
                      vertical: screenHeight * 0.018,
                    ),
                    margin: EdgeInsets.fromLTRB(
                      screenWidth * 0.06,
                      screenHeight * 0.02,
                      screenWidth * 0.06,
                      0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red[50]!, Colors.red[100]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red[300]!, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: Colors.red[700],
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign In Failed',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: (screenWidth * 0.04).clamp(
                                    14.0,
                                    16.0,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.red[800],
                                  fontSize: (screenWidth * 0.035).clamp(
                                    12.0,
                                    14.0,
                                  ),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.red[700],
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              _errorMessage = null;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Sign-in card container with darker semi-transparent background
                Container(
                  margin: EdgeInsets.fromLTRB(
                    screenWidth * 0.08,
                    0,
                    screenWidth * 0.08,
                    screenHeight * 0.08,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.04,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Welcome text - brighter and larger
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.08).clamp(26.0, 36.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      // Subtitle - brighter and larger
                      Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.048).clamp(17.0, 20.0),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(0, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: screenHeight * 0.035),

                      // Social Sign-In Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google Sign-In Button
                          _buildGoogleSignInButton(screenWidth, screenHeight),
                          SizedBox(width: screenWidth * 0.04),

                          // Apple Sign-In Button
                          _buildAppleSignInButton(screenWidth, screenHeight),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Privacy note with clickable links - brighter and larger
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: (screenWidth * 0.033).clamp(12.0, 14.0),
                            color: Colors.white,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          children: [
                            const TextSpan(
                              text: 'By signing in, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(
                                  'https://www.my-grants.com/app/terms-of-service',
                                ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(
                                  'https://www.my-grants.com/app/privacy-policy',
                                ),
                            ),
                          ],
                        ),
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

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open $urlString')));
      }
    }
  }

  Widget _buildGoogleSignInButton(double screenWidth, double screenHeight) {
    // Larger buttons for better UX - easier to tap
    final buttonSize = (screenWidth * 0.18).clamp(68.0, 88.0);
    final iconSize = (buttonSize * 0.6).clamp(40.0, 52.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: iconSize * 0.7,
                    width: iconSize * 0.7,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF4285F4),
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/Google Icon.png',
                    height: iconSize,
                    width: iconSize,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppleSignInButton(double screenWidth, double screenHeight) {
    // Larger buttons for better UX - easier to tap
    final buttonSize = (screenWidth * 0.18).clamp(68.0, 88.0);
    final iconSize = (buttonSize * 0.6).clamp(40.0, 52.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleAppleSignIn,
          borderRadius: BorderRadius.circular(18),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: iconSize * 0.7,
                    width: iconSize * 0.7,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Image.asset(
                    'assets/images/Apple Icon.png',
                    height: iconSize,
                    width: iconSize,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
