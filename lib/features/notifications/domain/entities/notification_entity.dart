// lib/features/notifications/domain/entities/notification_entity.dart
import 'package:hive/hive.dart';

part 'notification_entity.g.dart';

@HiveType(typeId: 3)
class NotificationEntity extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final String type; // 'exam', 'schedule', 'general'

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final bool isRead;

  @HiveField(6)
  final String? relatedId; // ID of related entity (exam id, schedule id, etc.)

  NotificationEntity({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.relatedId,
  });
}
