import 'package:student_timetable_app/features/subjects/domain/entities/subject_entity.dart';
import 'package:student_timetable_app/features/subjects/domain/repositories/subjects_repository.dart';

class GetSubjectsUsecase {
  final SubjectsRepository repository;

  GetSubjectsUsecase(this.repository);

  Future<List<SubjectEntity>> call() async {
    return await repository.getSubjects();
  }
}