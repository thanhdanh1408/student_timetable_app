// add_subject_usecase.dart
import '../entities/subject_entity.dart';
import '../repositories/subjects_repository.dart';

class AddSubjectUsecase {
  final SubjectsRepository repository;
  AddSubjectUsecase(this.repository);
  Future<void> call(SubjectEntity subject) => repository.add(subject);
}