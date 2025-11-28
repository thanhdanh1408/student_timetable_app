// lib/features/settings/domain/entities/user_settings_entity.dart
import 'package:hive/hive.dart';

part 'user_settings_entity.g.dart';

@HiveType(typeId: 4)
class UserSettingsEntity extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final bool darkMode;

  @HiveField(2)
  final bool notifications;

  @HiveField(3)
  final String language; // 'vi', 'en'

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

  UserSettingsEntity({
    required this.userId,
    this.darkMode = false,
    this.notifications = true,
    this.language = 'vi',
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
