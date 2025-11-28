// lib/features/settings/domain/repositories_impl/settings_repository_impl.dart
import 'package:hive/hive.dart';
import '../entities/user_settings_entity.dart';
import '../repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _boxName = 'settings_box';
  late Box<UserSettingsEntity> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<UserSettingsEntity>(_boxName);
    } else {
      _box = Hive.box<UserSettingsEntity>(_boxName);
    }
    _initialized = true;
  }

  @override
  Future<UserSettingsEntity?> getSettings(String userId) async {
    try {
      for (var settings in _box.values) {
        if (settings.userId == userId) {
          return settings;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveSettings(UserSettingsEntity settings) async {
    // Check if settings already exist, update or add
    final existing = await getSettings(settings.userId);
    if (existing != null) {
      final index = _box.values.toList().indexOf(existing);
      await _box.putAt(index, settings);
    } else {
      await _box.add(settings);
    }
  }
}
