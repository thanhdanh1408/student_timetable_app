// delete_exam_usecase.dart
import '../repositories/exam_repository.dart';

class DeleteExamUsecase {
  final ExamRepository repository;
  DeleteExamUsecase(this.repository);
  Future<void> call(int id) => repository.delete(id);
}