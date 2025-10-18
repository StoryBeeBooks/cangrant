import 'package:flutter/material.dart';
import 'package:cangrant/services/supabase_service.dart';
import 'package:cangrant/screens/pre_login/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final supabaseService = SupabaseService();
    await supabaseService.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();
    final user = supabaseService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User info header
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.email ?? 'User',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Menu options
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to edit profile
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Preferences'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to preferences
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help Center'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to help center
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
              ),

              const Spacer(),

              // Sign out button
              ElevatedButton(
                onPressed: () => _signOut(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Sign Out', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
