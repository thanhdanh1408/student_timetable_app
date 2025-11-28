// update_schedule_usecase.dart
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class UpdateScheduleUsecase {
  final ScheduleRepository repository;
  UpdateScheduleUsecase(this.repository);
  Future<void> call(ScheduleEntity schedule) => repository.update(schedule);
}