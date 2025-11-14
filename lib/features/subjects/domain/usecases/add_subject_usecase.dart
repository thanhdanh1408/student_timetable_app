import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/domain/repositories/subjects_repository.dart';

class AddSubjectUsecase {
  final SubjectsRepository repository;

  AddSubjectUsecase(this.repository);

  Future<void> call(SubjectEntity subject) async {
    await repository.addSubject(subject);
  }
}