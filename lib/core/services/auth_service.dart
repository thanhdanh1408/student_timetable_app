import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );

      // Create user profile in users table
      if (response.user != null) {
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
        );
      }

      return response;
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception('Sign in failed: ${e.message}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _supabaseService.client.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Sign out failed: ${e.message}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseService.client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw Exception('Reset password failed: ${e.message}');
    }
  }

  /// Create user profile in users table
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String fullName,
  }) async {
    try {
      await _supabaseService.client.from('users').insert({
        'user_id': userId,
        'email': email,
        'fullname': fullName,
      });

      // Create default settings
      await _supabaseService.client.from('settings').insert({
        'user_id': userId,
        'theme_mode': 'light',
        'notify_before': 15,
        'language': 'vi',
        'schedule_reminder_minutes': 15,
        'exam_reminder_minutes': 60,
        'enable_schedule_notifications': true,
        'enable_exam_notifications': true,
      });
    } catch (e) {
      print('Error creating user profile: $e');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _supabaseService.currentUser;
  }

  /// Get current user ID
  String? getCurrentUserId() {
    return _supabaseService.currentUserId;
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _supabaseService.isAuthenticated;
  }

  /// Get auth state changes stream
  Stream<AuthState> getAuthStateChanges() {
    return _supabaseService.authStateChanges;
  }
}
