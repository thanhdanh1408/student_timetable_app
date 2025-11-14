import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/domain/repositories/subjects_repository.dart';

class EditSubjectUsecase {
  final SubjectsRepository repository;

  EditSubjectUsecase(this.repository);

  Future<void> call(SubjectEntity subject) async {
    await repository.editSubject(subject);
  }
}