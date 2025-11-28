// get_schedules_usecase.dart
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class GetSchedulesUsecase {
  final ScheduleRepository repository;
  GetSchedulesUsecase(this.repository);
  Future<List<ScheduleEntity>> call() => repository.getAll();
}