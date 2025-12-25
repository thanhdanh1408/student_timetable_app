// lib/features/subjects/domain/repositories/subjects_repository.dart
import '../entities/subject_entity.dart';

abstract class SubjectsRepository {
  Future<List<SubjectEntity>> getAll();
  Future<void> add(SubjectEntity subject);
  Future<void> update(SubjectEntity subject);
  Future<void> delete(String id);
}