// lib/features/notifications/domain/usecases/delete_notification_usecase.dart
import '../repositories/notification_repository.dart';

class DeleteNotificationUsecase {
  final NotificationRepository repository;
  DeleteNotificationUsecase(this.repository);

  Future<void> call(int key) async {
    return await repository.delete(key);
  }
}
