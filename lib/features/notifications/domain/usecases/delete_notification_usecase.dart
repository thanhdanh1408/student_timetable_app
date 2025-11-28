// lib/features/notifications/domain/usecases/delete_notification_usecase.dart
import '../repositories/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;
  DeleteNotificationUsecase(this.repository);

  Future<void> call(int id) async {
    return await repository.delete(id);
  }
}
