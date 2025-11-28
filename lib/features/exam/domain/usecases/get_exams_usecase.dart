// get_exams_usecase.dart
import '../entities/exam_entity.dart';
import '../repositories/exam_repository.dart';

class GetExamsUsecase {
  final ExamRepository repository;
  GetExamsUsecase(this.repository);
  Future<List<ExamEntity>> call() => repository.getAll();
}