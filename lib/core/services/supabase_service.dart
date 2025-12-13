import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  /// Initialize Supabase
  Future<void> initialize(String url, String anonKey) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: true,
    );
  }

  /// Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  /// Get current user
  User? get currentUser => client.auth.currentUser;

  /// Get current user ID
  String? get currentUserId => currentUser?.id;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  /// Get auth state stream
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
