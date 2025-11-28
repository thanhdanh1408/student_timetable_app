// lib/features/notifications/domain/usecases/get_notifications_usecase.dart
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final NotificationRepository repository;
  GetNotificationsUsecase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.getAll();
  }
}
