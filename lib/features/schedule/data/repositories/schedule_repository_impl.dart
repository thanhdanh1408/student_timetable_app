// lib/features/schedule/data/repositories/schedule_repository_impl.dart
import '/core/services/supabase_service.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  static final ScheduleRepositoryImpl _instance = ScheduleRepositoryImpl._internal();
  factory ScheduleRepositoryImpl() => _instance;
  ScheduleRepositoryImpl._internal();

  late SupabaseService _supabase = SupabaseService();

  @override
  Future<List<ScheduleEntity>> getAll() async {
    try {
      if (!_supabase.isAuthenticated) {
        print('❌ Not authenticated');
        return [];
      }

      final userId = _supabase.currentUserId;
      if (userId == null) {
        print('❌ User ID is null');
        return [];
      }

      // JOIN with subjects table to get subject and teacher names
      // Filter by user_id through subjects table
      final response = await _supabase.client
          .from('schedules')
          .select('*, subjects!inner(subject_name, teacher_name, user_id)')
          .eq('subjects.user_id', userId);

      print('📋 Raw response from schedules query: $response');

      final schedules = (response as List).map((e) {
        // Denormalize subject info from the joined data
        final subjectData = e['subjects'] as Map<String, dynamic>?;
        print('📋 Schedule: ${e['schedule_id']}, Subject data: $subjectData');
        e['subject_name'] = subjectData?['subject_name'];
        e['teacher_name'] = subjectData?['teacher_name'];
        final schedule = ScheduleEntity.fromJson(e);
        print(
          '✅ Denormalized schedule - subjectName: ${schedule.subjectName}, teacherName: ${schedule.teacherName}',
        );
        return schedule;
      }).toList();

      print('✅ Loaded ${schedules.length} schedules from Supabase');
      return schedules;
    } catch (e) {
      print('❌ Error loading schedules: $e');
      return [];
    }
  }

  @override
  Future<String> add(ScheduleEntity schedule) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      final userId = _supabase.currentUserId;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      final response = await _supabase.client.from('schedules').insert({
        'subject_id': schedule.subjectId,
        'day_of_week': schedule.dayOfWeek,
        'start_time': schedule.startTime,
        'end_time': schedule.endTime,
        'location': schedule.location,
        'color': schedule.color,
        'is_enabled': schedule.isEnabled,
      }).select().single();

      final scheduleId = response['schedule_id'] as String?;
      if (scheduleId == null || scheduleId.isEmpty) {
        throw Exception('Missing schedule_id from insert response');
      }
      print('✅ Schedule added to Supabase: ${schedule.subjectName}, ID: $scheduleId');
      return scheduleId;
    } catch (e) {
      print('❌ Error adding schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(ScheduleEntity schedule) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      if (schedule.id == null) {
        throw Exception('Schedule ID cannot be null');
      }

      await _supabase.client
          .from('schedules')
          .update({
            'subject_id': schedule.subjectId,
            'day_of_week': schedule.dayOfWeek,
            'start_time': schedule.startTime,
            'end_time': schedule.endTime,
            'location': schedule.location,
            'color': schedule.color,
            'is_enabled': schedule.isEnabled,
          })
          .eq('schedule_id', schedule.id!);

      print('✅ Schedule updated in Supabase: ${schedule.subjectName}');
    } catch (e) {
      print('❌ Error updating schedule: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      await _supabase.client.from('schedules').delete().eq('schedule_id', id.toString());

      print('✅ Schedule deleted from Supabase: ID $id');
    } catch (e) {
      print('❌ Error deleting schedule: $e');
      rethrow;
    }
  }
}
