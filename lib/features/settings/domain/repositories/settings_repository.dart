// lib/features/settings/domain/repositories/settings_repository.dart
import '../entities/user_settings_entity.dart';

abstract class SettingsRepository {
  Future<UserSettingsEntity?> getSettings(String userId);
  Future<void> saveSettings(UserSettingsEntity settings);
}
