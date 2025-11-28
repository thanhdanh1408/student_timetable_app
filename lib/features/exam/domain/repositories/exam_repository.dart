// lib/features/exam/domain/repositories/exam_repository.dart
import '../entities/exam_entity.dart';

abstract class ExamRepository {
  Future<List<ExamEntity>> getAll();
  Future<void> add(ExamEntity exam);
  Future<void> update(ExamEntity exam);
  Future<void> delete(int id);
}