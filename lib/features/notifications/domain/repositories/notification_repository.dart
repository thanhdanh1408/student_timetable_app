// lib/features/notifications/domain/repositories/notification_repository.dart
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getAll();
  Future<void> add(NotificationEntity notification);
  Future<void> update(int index, NotificationEntity notification);
  Future<void> delete(int id);
}
