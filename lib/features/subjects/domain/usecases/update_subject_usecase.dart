// update_subject_usecase.dart
import '../entities/subject_entity.dart';
import '../repositories/subjects_repository.dart';

class UpdateSubjectUsecase {
  final SubjectsRepository repository;
  UpdateSubjectUsecase(this.repository);
  Future<void> call(SubjectEntity subject) => repository.update(subject);
}