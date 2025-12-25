// lib/features/notifications/domain/usecases/update_notification_usecase.dart
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class UpdateNotificationUsecase {
  final NotificationRepository repository;

  UpdateNotificationUsecase(this.repository);

  Future<void> call(int key, NotificationEntity notification) async {
    return repository.update(key, notification);
  }
}
