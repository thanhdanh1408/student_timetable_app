// update_exam_usecase.dart
import '../entities/exam_entity.dart';
import '../repositories/exam_repository.dart';

class UpdateExamUsecase {
  final ExamRepository repository;
  UpdateExamUsecase(this.repository);
  Future<void> call(ExamEntity exam) => repository.update(exam);
}