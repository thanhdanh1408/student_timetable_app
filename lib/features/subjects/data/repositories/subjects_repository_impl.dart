// lib/features/subjects/data/repositories/subjects_repository_impl.dart
import '/core/services/supabase_service.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/repositories/subjects_repository.dart';

class SubjectsRepositoryImpl implements SubjectsRepository {
  static final SubjectsRepositoryImpl _instance = SubjectsRepositoryImpl._internal();
  factory SubjectsRepositoryImpl() => _instance;
  SubjectsRepositoryImpl._internal();

  late SupabaseService _supabase = SupabaseService();

  @override
  Future<List<SubjectEntity>> getAll() async {
    try {
      if (!_supabase.isAuthenticated || _supabase.currentUserId == null) {
        print('❌ Not authenticated');
        return [];
      }

      final response = await _supabase.client
          .from('subjects')
          .select()
          .eq('user_id', _supabase.currentUserId!);

      final subjects = (response as List).map((e) => SubjectEntity.fromJson(e)).toList();

      print('✅ Loaded ${subjects.length} subjects from Supabase');
      return subjects;
    } catch (e) {
      print('❌ Error loading subjects: $e');
      return [];
    }
  }

  @override
  Future<void> add(SubjectEntity subject) async {
    try {
      if (!_supabase.isAuthenticated || _supabase.currentUserId == null) {
        throw Exception('Not authenticated');
      }

      print('📝 [SubjectsRepository] Attempting to add subject: ${subject.subjectName}');
      print('📝 [SubjectsRepository] User authenticated: ${_supabase.currentUserId}');

      final response = await _supabase.client.from('subjects').insert({
        'user_id': _supabase.currentUserId!,
        'subject_name': subject.subjectName,
        'teacher_name': subject.teacherName,
        'color': subject.color,
        'credit': subject.credit,
      }).select();

      print('✅ Subject added to Supabase: ${subject.subjectName}');
      print('✅ Response: $response');
    } catch (e) {
      print('❌ Error adding subject: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(SubjectEntity subject) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      if (subject.id == null) {
        throw Exception('Subject ID cannot be null');
      }

      await _supabase.client
          .from('subjects')
          .update({
            'subject_name': subject.subjectName,
            'teacher_name': subject.teacherName,
            'color': subject.color,
            'credit': subject.credit,
          })
          .eq('subject_id', subject.id!);

      print('✅ Subject updated in Supabase: ${subject.subjectName}');
    } catch (e) {
      print('❌ Error updating subject: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      await _supabase.client.from('subjects').delete().eq('subject_id', id.toString());

      print('✅ Subject deleted from Supabase: ID $id');
    } catch (e) {
      print('❌ Error deleting subject: $e');
      rethrow;
    }
  }
}
