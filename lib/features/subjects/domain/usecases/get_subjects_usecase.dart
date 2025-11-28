// get_subjects_usecase.dart
import '../entities/subject_entity.dart';
import '../repositories/subjects_repository.dart';

class GetSubjectsUsecase {
  final SubjectsRepository repository;
  GetSubjectsUsecase(this.repository);
  Future<List<SubjectEntity>> call() => repository.getAll();
}