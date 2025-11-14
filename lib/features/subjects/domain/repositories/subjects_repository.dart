import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';

abstract class SubjectsRepository {
  Future<List<SubjectEntity>> getSubjects();
  Future<void> addSubject(SubjectEntity subject);
  Future<void> editSubject(SubjectEntity subject);
  Future<void> deleteSubject(int subjectId);
}