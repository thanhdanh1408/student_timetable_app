// lib/features/notifications/data/repositories/notification_repository_impl.dart
import '/core/services/supabase_service.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static final NotificationRepositoryImpl _instance =
      NotificationRepositoryImpl._internal();
  factory NotificationRepositoryImpl() => _instance;
  NotificationRepositoryImpl._internal();

  final SupabaseService _supabase = SupabaseService();

  @override
  Future<List<NotificationEntity>> getAll() async {
    try {
      if (!_supabase.isAuthenticated) return [];

      final userId = _supabase.currentUserId;
      if (userId == null) return [];

      final nowIso = DateTime.now().toUtc().toIso8601String();

      try {
        final response = await _supabase.client
            .from('notifications')
            .select()
            .eq('user_id', userId)
            // Only show notifications that are actually due.
            .lte('scheduled_for', nowIso)
            .order('scheduled_for', ascending: false)
            .order('created_at', ascending: false);

        return (response as List)
            .map((e) => NotificationEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {
        // Backward-compatible fallback if DB hasn't been migrated yet.
        final response = await _supabase.client
            .from('notifications')
            .select()
            .eq('user_id', userId)
            .order('created_at', ascending: false);

        return (response as List)
            .map((e) => NotificationEntity.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      print('❌ Error loading notifications: $e');
      return [];
    }
  }

  @override
  Future<void> add(NotificationEntity notification) async {
    try {
      if (!_supabase.isAuthenticated) throw Exception('Not authenticated');

      final userId = _supabase.currentUserId;
      if (userId == null) throw Exception('User ID is null');

      final payload = {
        'user_id': userId,
        ...notification.toJson(),
      };

      try {
        await _supabase.client.from('notifications').insert(payload);
      } catch (e) {
        // Backward-compatible fallback if scheduled_for column isn't present yet.
        if (e.toString().contains('scheduled_for')) {
          final fallbackPayload = Map<String, dynamic>.from(payload)
            ..remove('scheduled_for');
          await _supabase.client.from('notifications').insert(fallbackPayload);
        } else {
          rethrow;
        }
      }

      print('✅ Notification added to Supabase');
    } catch (e) {
      print('❌ Error adding notification: $e');
      rethrow;
    }
  }

  Future<String?> _resolveIdFromKey(int key) async {
    final list = await getAll();
    if (key < 0 || key >= list.length) return null;
    return list[key].id;
  }

  @override
  Future<void> update(int key, NotificationEntity notification) async {
    try {
      if (!_supabase.isAuthenticated) throw Exception('Not authenticated');

      final id = notification.id ?? await _resolveIdFromKey(key);
      if (id == null) throw Exception('Notification ID is null');

      final payload = notification.toJson();

      try {
        await _supabase.client
            .from('notifications')
            .update(payload)
            .eq('notification_id', id);
      } catch (e) {
        // Backward-compatible fallback if scheduled_for column isn't present yet.
        if (e.toString().contains('scheduled_for')) {
          final fallbackPayload = Map<String, dynamic>.from(payload)
            ..remove('scheduled_for');
          await _supabase.client
              .from('notifications')
              .update(fallbackPayload)
              .eq('notification_id', id);
        } else {
          rethrow;
        }
      }

      print('✅ Notification updated in Supabase');
    } catch (e) {
      print('❌ Error updating notification: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(int key) async {
    try {
      if (!_supabase.isAuthenticated) throw Exception('Not authenticated');

      final id = await _resolveIdFromKey(key);
      if (id == null) throw Exception('Notification not found for key=$key');

      await deleteById(id);
    } catch (e) {
      print('❌ Error deleting notification: $e');
      rethrow;
    }
  }

  Future<void> deleteById(String id) async {
    try {
      if (!_supabase.isAuthenticated) throw Exception('Not authenticated');

      await _supabase.client.from('notifications').delete().eq('notification_id', id);

      print('✅ Notification deleted from Supabase');
    } catch (e) {
      print('❌ Error deleting notification by id: $e');
      rethrow;
    }
  }
}
