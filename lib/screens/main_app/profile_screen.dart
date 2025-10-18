import 'package:flutter/material.dart';
import 'package:cangrant/services/supabase_service.dart';
import 'package:cangrant/screens/pre_login/auth_screen.dart';
import 'package:cangrant/screens/main_app/saved_grants_screen.dart';
import 'package:cangrant/screens/main_app/language_screen.dart';
import 'package:cangrant/screens/main_app/help_center_screen.dart';
import 'package:cangrant/screens/main_app/privacy_policy_screen.dart';
import 'package:cangrant/screens/main_app/terms_of_use_screen.dart';
import 'package:cangrant/screens/main_app/about_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English (US)';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _darkModeEnabled = prefs.getBool('darkMode') ?? false;
      final languageCode = prefs.getString('language') ?? 'en';
      _selectedLanguage = languageCode == 'zh' ? 'Chinese (Simplified)' : 'English (US)';
    });
  }

  Future<void> _saveNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', value);
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _saveDarkModePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _darkModeEnabled = value;
    });
    // TODO: Implement dark mode theme switching
  }

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

  String _getUserInitials(String? email) {
    if (email == null || email.isEmpty) return 'SC';
    final parts = email.split('@')[0].split('.');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return email.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final supabaseService = SupabaseService();
    final user = supabaseService.getCurrentUser();
    final userEmail = user?.email ?? 'sarah.chen@example.com';
    final userName = user?.email?.split('@')[0].replaceAll('.', ' ') ?? 'Sarah Chen';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Purple header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Text(
                        _getUserInitials(userEmail),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5E35B1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Saved Grants Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: Color(0xFF5E35B1),
                      ),
                    ),
                    title: const Text(
                      'Saved Grants',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text('0 grants saved'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SavedGrantsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Preferences Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Notifications
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF90CAF9).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            title: const Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text('Grant alerts & reminders'),
                            trailing: Switch(
                              value: _notificationsEnabled,
                              onChanged: _saveNotificationPreference,
                              activeColor: const Color(0xFF5E35B1),
                            ),
                          ),
                          const Divider(height: 1),

                          // Dark Mode
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCE93D8).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.dark_mode,
                                color: Color(0xFF8E24AA),
                              ),
                            ),
                            title: const Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text('Appearance preference'),
                            trailing: Switch(
                              value: _darkModeEnabled,
                              onChanged: _saveDarkModePreference,
                              activeColor: const Color(0xFF5E35B1),
                            ),
                          ),
                          const Divider(height: 1),

                          // Language
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFA5D6A7).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.language,
                                color: Color(0xFF388E3C),
                              ),
                            ),
                            title: const Text(
                              'Language',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(_selectedLanguage),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LanguageSelectionScreen(),
                                ),
                              );
                              if (result != null) {
                                setState(() {
                                  _selectedLanguage = result;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Support & Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Support & Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // Help Center
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFCC80).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.help,
                                color: Color(0xFFFF9800),
                              ),
                            ),
                            title: const Text(
                              'Help Center',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HelpCenterScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),

                          // Privacy Policy
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF80DEEA).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.privacy_tip,
                                color: Color(0xFF00ACC1),
                              ),
                            ),
                            title: const Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),

                          // Terms of Use
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFBCAAA4).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.description,
                                color: Color(0xFF6D4C41),
                              ),
                            ),
                            title: const Text(
                              'Terms of Use',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TermsOfUseScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(height: 1),

                          // About
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF9FA8DA).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.info,
                                color: Color(0xFF5C6BC0),
                              ),
                            ),
                            title: const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: const Text('Version 1.0.0'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AboutScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sign Out Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () => _signOut(context),
                    borderRadius: BorderRadius.circular(16),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Your Saved Grants section at bottom
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Your Saved Grants',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 80), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}
