// lib/features/settings/data/repositories/settings_repository_impl.dart
import '/core/services/supabase_service.dart';
import '../../domain/entities/user_settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SupabaseService _supabase = SupabaseService();

  @override
  Future<UserSettingsEntity?> getSettings(String userId) async {
    try {
      if (!_supabase.isAuthenticated) return null;

      final response = await _supabase.client
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return _createDefaultSettings(userId);
      }

      return UserSettingsEntity.fromJson(response);
    } catch (e) {
      print('❌ Error loading settings: $e');
      return _createDefaultSettings(userId);
    }
  }

  @override
  Future<void> saveSettings(UserSettingsEntity settings) async {
    try {
      if (!_supabase.isAuthenticated) throw Exception('Not authenticated');

      // Upsert: insert if not exists, update if exists
      await _supabase.client.from('user_settings').upsert(
        settings.toJson(),
        onConflict: 'user_id',
      );

      print('✅ Settings saved to Supabase');
    } catch (e) {
      print('❌ Error saving settings: $e');
      rethrow;
    }
  }

  UserSettingsEntity _createDefaultSettings(String userId) {
    return UserSettingsEntity(
      userId: userId,
      darkMode: false,
      notifications: true,
      language: 'vi',
    );
  }
}
