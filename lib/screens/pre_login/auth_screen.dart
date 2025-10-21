import 'dart:io';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true; // Toggle between login and sign up
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print(
        'DEBUG AUTH: Attempting ${_isLogin ? 'login' : 'signup'} with email: ${_emailController.text.trim()}',
      );

      if (_isLogin) {
        // Log in
        final response = await _supabaseService.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        print('DEBUG AUTH: Login successful! User: ${response.user?.email}');

        if (mounted) {
          // Navigate to main screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        // Sign up
        final response = await _supabaseService.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        print('DEBUG AUTH: Signup successful! User: ${response.user?.email}');

        if (mounted) {
          // Navigate to onboarding questionnaire
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingFlow()),
          );
        }
      }
    } catch (e) {
      print('DEBUG AUTH: Error - $e');
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
        _errorMessage =
            'Google sign-in failed: ${e.toString().replaceAll('Exception: ', '')}';
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
        _errorMessage =
            'Apple sign-in failed: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),

                // Logo
                Icon(
                  Icons.card_giftcard,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  _isLogin ? 'Sign in to continue' : 'Sign up to get started',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Error message
                if (_errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Social sign-in buttons
                _buildGoogleSignInButton(),
                const SizedBox(height: 12),

                // Only show Apple Sign-In on iOS and macOS
                if (Platform.isIOS || Platform.isMacOS) ...[
                  _buildAppleSignInButton(),
                  const SizedBox(height: 24),
                ] else
                  const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 24),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Main action button (Email/Password)
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailAuth,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _isLogin
                              ? 'Log In with Email'
                              : 'Create Account with Email',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),

                // Toggle between login and sign up
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _errorMessage = null;
                          });
                        },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign Up"
                        : 'Already have an account? Log In',
                  ),
                ),

                // Forgot password (only show for login)
                if (_isLogin)
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_emailController.text.isEmpty) {
                              setState(() {
                                _errorMessage =
                                    'Please enter your email to reset password';
                              });
                              return;
                            }

                            try {
                              await _supabaseService.resetPassword(
                                _emailController.text.trim(),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Password reset link sent! Check your email.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              setState(() {
                                _errorMessage =
                                    'Failed to send reset email: $e';
                              });
                            }
                          },
                    child: const Text('Forgot Password?'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Image.network(
        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
        height: 24,
        width: 24,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.g_mobiledata, size: 24),
      ),
      label: Text(
        _isLogin ? 'Sign in with Google' : 'Sign up with Google',
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  Widget _buildAppleSignInButton() {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _handleAppleSignIn,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.black,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.apple, size: 24, color: Colors.white),
      label: Text(
        _isLogin ? 'Sign in with Apple' : 'Sign up with Apple',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
