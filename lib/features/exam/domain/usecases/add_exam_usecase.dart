// add_exam_usecase.dart
import '../entities/exam_entity.dart';
import '../repositories/exam_repository.dart';

class AddExamUsecase {
  final ExamRepository repository;
  AddExamUsecase(this.repository);
  Future<void> call(ExamEntity exam) => repository.add(exam);
}