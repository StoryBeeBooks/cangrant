import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  // TODO: Replace these with your actual Supabase credentials
  // Get them from: https://app.supabase.com/project/_/settings/api
  static const String supabaseUrl = 'https://tvhcnjimfdfsentmngij.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR2aGNuamltZmRmc2VudG1uZ2lqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA3MDkxMzEsImV4cCI6MjA3NjI4NTEzMX0._OWLCxSV4UxUxKqkhXOrs5txzdLb1jYYAD_rCOzP2sA';

  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  // Get the Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // Check if user is currently logged in
  bool isUserLoggedIn() {
    return client.auth.currentSession != null;
  }

  // Get current user
  User? getCurrentUser() {
    return client.auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(email: email, password: password);
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }
}
