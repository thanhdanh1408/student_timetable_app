// delete_schedule_usecase.dart
import '../repositories/schedule_repository.dart';

class DeleteScheduleUsecase {
  final ScheduleRepository repository;
  DeleteScheduleUsecase(this.repository);
  Future<void> call(int id) => repository.delete(id);
}