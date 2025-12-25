// lib/features/exam/data/repositories/exam_repository_impl.dart
import '/core/services/supabase_service.dart';
import '../../domain/entities/exam_entity.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  static final ExamRepositoryImpl _instance = ExamRepositoryImpl._internal();
  factory ExamRepositoryImpl() => _instance;
  ExamRepositoryImpl._internal();

  late SupabaseService _supabase = SupabaseService();

  @override
  Future<List<ExamEntity>> getAll() async {
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
          .from('exams')
          .select('*, subjects!inner(subject_name, teacher_name, user_id)')
          .eq('subjects.user_id', userId);

      print('📋 Raw response from exams query: $response');

      final exams = (response as List).map((e) {
        // Denormalize subject info from the joined data
        final subjectData = e['subjects'] as Map<String, dynamic>?;
        print('📋 Exam: ${e['exam_id']}, Subject data: $subjectData');
        e['subject_name'] = subjectData?['subject_name'];
        e['teacher_name'] = subjectData?['teacher_name'];
        final exam = ExamEntity.fromJson(e);
        print(
          '✅ Denormalized exam - subjectName: ${exam.subjectName}, teacherName: ${exam.teacherName}',
        );
        return exam;
      }).toList();

      // Sort by exam date
      exams.sort((a, b) {
        if (a.examDate == null || b.examDate == null) return 0;
        return a.examDate!.compareTo(b.examDate!);
      });

      print('✅ Loaded ${exams.length} exams from Supabase');
      return exams;
    } catch (e) {
      print('❌ Error loading exams: $e');
      return [];
    }
  }

  @override
  Future<String> add(ExamEntity exam) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      final userId = _supabase.currentUserId;
      if (userId == null) {
        throw Exception('User ID is null');
      }

      final response = await _supabase.client.from('exams').insert({
        'subject_id': exam.subjectId,
        'exam_date': exam.examDate != null ? exam.examDate!.toIso8601String() : null,
        'exam_time': exam.examTime,
        'exam_name': exam.examName,
        'exam_room': exam.examRoom,
        'color': exam.color,
        'is_completed': exam.isCompleted,
      }).select().single();

      final examId = response['exam_id'] as String?;
      if (examId == null || examId.isEmpty) {
        throw Exception('Missing exam_id from insert response');
      }

      print('✅ Exam added to Supabase: ${exam.examName} (ID: $examId)');
      return examId;
    } catch (e) {
      print('❌ Error adding exam: $e');
      rethrow;
    }
  }

  @override
  Future<void> update(ExamEntity exam) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      if (exam.id == null) {
        throw Exception('Exam ID cannot be null');
      }

      await _supabase.client
          .from('exams')
          .update({
            'subject_id': exam.subjectId,
            'exam_date': exam.examDate != null ? exam.examDate!.toIso8601String() : null,
            'exam_time': exam.examTime,
            'exam_name': exam.examName,
            'exam_room': exam.examRoom,
            'color': exam.color,
            'is_completed': exam.isCompleted,
          })
          .eq('exam_id', exam.id!);

      print('✅ Exam updated in Supabase: ${exam.examName}');
    } catch (e) {
      print('❌ Error updating exam: $e');
      rethrow;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      if (!_supabase.isAuthenticated) {
        throw Exception('Not authenticated');
      }

      await _supabase.client.from('exams').delete().eq('exam_id', id);

      print('✅ Exam deleted from Supabase: ID $id');
    } catch (e) {
      print('❌ Error deleting exam: $e');
      rethrow;
    }
  }
}
