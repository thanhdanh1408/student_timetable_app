import 'package:student_timetable_app/features/subjects/domain/repositories/subjects_repository.dart';

class DeleteSubjectUsecase {
  final SubjectsRepository repository;

  DeleteSubjectUsecase(this.repository);

  Future<void> call(int subjectId) async {
    await repository.deleteSubject(subjectId);
  }
}