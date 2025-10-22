import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

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

  // ============================================
  // Social Authentication - Google Sign-In
  // ============================================

  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: Platform.isAndroid
            ? '162637828951-ql1ktn0a5274u7imfgnok16tup5etofc.apps.googleusercontent.com'
            : null,
      );

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      // Sign in to Supabase with Google credentials
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      print('Google Sign-In Error: $e');
      throw Exception('Google sign-in failed: $e');
    }
  }

  // ============================================
  // Social Authentication - Apple Sign-In
  // ============================================

  Future<AuthResponse> signInWithApple() async {
    try {
      // Trigger Apple Sign-In flow
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken == null) {
        throw Exception('Failed to get Apple ID token');
      }

      // Sign in to Supabase with Apple credentials
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: credential.identityToken!,
      );

      return response;
    } catch (e) {
      print('Apple Sign-In Error: $e');
      throw Exception('Apple sign-in failed: $e');
    }
  }

  // ============================================
  // Metered Paywall - Free Views Tracking
  // ============================================

  // Get user's remaining free views
  Future<int> getFreeViewsRemaining() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return 0;

      final response = await client
          .from('profiles')
          .select('free_views_remaining')
          .eq('user_id', userId)
          .single();

      return response['free_views_remaining'] ?? 3;
    } catch (e) {
      print('Error getting free views: $e');
      // Default to 3 if profile doesn't exist yet
      return 3;
    }
  }

  // Decrement free views count
  Future<int> decrementFreeViews() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return 0;

      // Get current count
      final current = await getFreeViewsRemaining();

      if (current <= 0) return 0;

      final newCount = current - 1;

      // Update database
      await client
          .from('profiles')
          .update({'free_views_remaining': newCount})
          .eq('user_id', userId);

      return newCount;
    } catch (e) {
      print('Error decrementing free views: $e');
      return 0;
    }
  }

  // Check if user has active subscription
  Future<bool> hasActiveSubscription() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await client
          .from('profiles')
          .select('subscription_tier, subscription_expires_at')
          .eq('user_id', userId)
          .single();

      final tier = response['subscription_tier'] as String?;
      final expiresAt = response['subscription_expires_at'] as String?;

      // Check if premium tier
      if (tier != 'premium' && tier != 'pro') return false;

      // Check if not expired
      if (expiresAt != null) {
        final expiryDate = DateTime.parse(expiresAt);
        if (expiryDate.isBefore(DateTime.now())) return false;
      }

      return true;
    } catch (e) {
      print('Error checking subscription: $e');
      return false;
    }
  }

  // Reset free views (for testing or monthly reset)
  Future<void> resetFreeViews({int count = 3}) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return;

      await client
          .from('profiles')
          .update({'free_views_remaining': count})
          .eq('user_id', userId);
    } catch (e) {
      print('Error resetting free views: $e');
    }
  }
}
