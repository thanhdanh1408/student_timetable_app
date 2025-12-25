// lib/features/schedule/domain/repositories/schedule_repository.dart
import '../entities/schedule_entity.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleEntity>> getAll();
  Future<String> add(ScheduleEntity schedule);
  Future<void> update(ScheduleEntity schedule);
  Future<void> delete(String id);
}