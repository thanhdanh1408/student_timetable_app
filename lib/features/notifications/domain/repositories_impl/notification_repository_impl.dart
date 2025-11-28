// lib/features/notifications/domain/repositories_impl/notification_repository_impl.dart
import 'package:hive/hive.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  static const String _boxName = 'notifications_box';
  late Box<NotificationEntity> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<NotificationEntity>(_boxName);
    } else {
      _box = Hive.box<NotificationEntity>(_boxName);
    }
    _initialized = true;
  }

  @override
  Future<List<NotificationEntity>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> add(NotificationEntity notification) async {
    await _box.add(notification);
  }

  @override
  Future<void> delete(int id) async {
    await _box.deleteAt(id);
  }
}
