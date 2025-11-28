// add_schedule_usecase.dart
import '../entities/schedule_entity.dart';
import '../repositories/schedule_repository.dart';

class AddScheduleUsecase {
  final ScheduleRepository repository;
  AddScheduleUsecase(this.repository);
  Future<void> call(ScheduleEntity schedule) => repository.add(schedule);
}