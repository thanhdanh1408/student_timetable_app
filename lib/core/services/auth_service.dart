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
      print('🔐 SignUp attempt: email=$email, password=${password.length} chars');
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );

      print('✅ SignUp success: user_id=${response.user?.id}');

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
      print('❌ SignUp failed: ${e.message} (status: ${e.statusCode})');
      throw Exception('Đăng ký thất bại: ${e.message}');
    } catch (e) {
      print('❌ SignUp error: $e');
      throw Exception('Lỗi đăng ký: $e');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 SignIn attempt: email=$email');
      final response = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('✅ SignIn success: user_id=${response.user?.id}');
      return response;
    } on AuthException catch (e) {
      print('❌ SignIn failed: ${e.message} (status: ${e.statusCode})');
      throw Exception('Đăng nhập thất bại: ${e.message}');
    } catch (e) {
      print('❌ SignIn error: $e');
      throw Exception('Lỗi đăng nhập: $e');
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
      print('📝 Creating user profile: userId=$userId, email=$email');
      
      await _supabaseService.client.from('users').insert({
        'user_id': userId,
        'email': email,
        'fullname': fullName,
        'created_at': DateTime.now().toIso8601String(),
      });

      print('✅ User profile created');

      // Create default settings
      await _supabaseService.client.from('user_settings').insert({
        'user_id': userId,
        'dark_mode': false,
        'notifications': true,
        'language': 'vi',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      print('✅ User settings created');
    } catch (e) {
      print('❌ Error creating user profile: $e');
      rethrow;
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
