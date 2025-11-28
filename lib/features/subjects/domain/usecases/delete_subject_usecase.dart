// delete_subject_usecase.dart
import '../repositories/subjects_repository.dart';

class DeleteSubjectUsecase {
  final SubjectsRepository repository;
  DeleteSubjectUsecase(this.repository);
  Future<void> call(int id) => repository.delete(id);
}