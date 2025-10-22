import 'package:flutter/material.dart';
import 'package:mygrants/services/supabase_service.dart';
import 'package:mygrants/screens/pre_login/language_selection_screen.dart';
import 'package:mygrants/screens/main_app/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SupabaseService _supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndNavigate();
  }

  Future<void> _checkAuthenticationAndNavigate() async {
    // Show splash screen for 2-3 seconds minimum
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is logged in
    final bool isLoggedIn = _supabaseService.isUserLoggedIn();

    // Navigate based on authentication status
    if (isLoggedIn) {
      // User is logged in, go to main app
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      // User is not logged in, go to language selection
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LanguageSelectionScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/loading image.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
