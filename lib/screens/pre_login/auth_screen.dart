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

          // Content overlay
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),

                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.018,
                        ),
                        margin: EdgeInsets.only(bottom: screenHeight * 0.03),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _errorMessage!,
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 14,
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

                    // Social Sign-In Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Sign-In Button
                        _buildGoogleSignInButton(screenWidth),
                        SizedBox(width: screenWidth * 0.04),

                        // Apple Sign-In Button
                        _buildAppleSignInButton(screenWidth),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Sign in instruction
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: (screenWidth * 0.045).clamp(16.0, 20.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Privacy note with clickable links
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                      ),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: (screenWidth * 0.03).clamp(11.0, 14.0),
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By signing in, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                color: Colors.white,
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
                              style: TextStyle(
                                color: Colors.white,
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

                    const Spacer(),
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

  Widget _buildGoogleSignInButton(double screenWidth) {
    final buttonSize = (screenWidth * 0.18).clamp(60.0, 80.0);
    final iconSize = (screenWidth * 0.12).clamp(40.0, 52.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          onTap: _isLoading ? null : _handleGoogleSignIn,
          borderRadius: BorderRadius.circular(16),
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

  Widget _buildAppleSignInButton(double screenWidth) {
    final buttonSize = (screenWidth * 0.18).clamp(60.0, 80.0);
    final iconSize = (screenWidth * 0.12).clamp(40.0, 52.0);

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          onTap: _isLoading ? null : _handleAppleSignIn,
          borderRadius: BorderRadius.circular(16),
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
