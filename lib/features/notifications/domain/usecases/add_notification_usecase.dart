// lib/features/notifications/domain/usecases/add_notification_usecase.dart
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class AddNotificationUsecase {
  final NotificationRepository repository;
  AddNotificationUsecase(this.repository);

  Future<void> call(NotificationEntity notification) async {
    return await repository.add(notification);
  }
}
