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

          // Content overlay - positioned in bottom right
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: screenWidth * 0.06,
                  bottom: screenHeight * 0.04,
                  left: screenWidth * 0.15, // Allow space on left for balance
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Error message (if any)
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.015,
                        ),
                        margin: EdgeInsets.only(bottom: screenHeight * 0.025),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.red[50]!, Colors.red[100]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red[300]!,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red[100]!.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Colors.red[700],
                              size: 22,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign In Failed',
                                    style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: (screenWidth * 0.037).clamp(
                                        13.0,
                                        15.0,
                                      ),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: (screenWidth * 0.033).clamp(
                                        12.0,
                                        14.0,
                                      ),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Colors.red[700],
                                size: 20,
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

                    // Sign in instruction text - positioned above buttons
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: (screenWidth * 0.042).clamp(15.0, 18.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 1),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    // Social Sign-In Buttons Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Google Sign-In Button
                        _buildGoogleSignInButton(screenWidth, screenHeight),
                        SizedBox(width: screenWidth * 0.03),

                        // Apple Sign-In Button
                        _buildAppleSignInButton(screenWidth, screenHeight),
                      ],
                    ),

                    // Privacy note with clickable links
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.025),
                      child: RichText(
                        textAlign: TextAlign.right,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: (screenWidth * 0.028).clamp(10.0, 12.0),
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          children: [
                            const TextSpan(
                              text: 'By signing in, you agree to our\n',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
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
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => _launchURL(
                                  'https://www.my-grants.com/app/privacy-policy',
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
    // Button size scales with screen size but maintains good proportions
    // Using smaller percentages for bottom-right placement
    final buttonSize = (screenWidth * 0.15).clamp(56.0, 72.0);
    final iconSize = (buttonSize * 0.65).clamp(36.0, 48.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: iconSize * 0.7,
                    width: iconSize * 0.7,
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
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
    // Button size scales with screen size but maintains good proportions
    final buttonSize = (screenWidth * 0.15).clamp(56.0, 72.0);
    final iconSize = (buttonSize * 0.65).clamp(36.0, 48.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _handleAppleSignIn,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    height: iconSize * 0.7,
                    width: iconSize * 0.7,
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
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
