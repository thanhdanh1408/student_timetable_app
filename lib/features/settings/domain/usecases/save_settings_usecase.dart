// lib/features/settings/domain/usecases/save_settings_usecase.dart
import '../entities/user_settings_entity.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUsecase {
  final SettingsRepository repository;
  SaveSettingsUsecase(this.repository);

  Future<void> call(UserSettingsEntity settings) async {
    return await repository.saveSettings(settings);
  }
}
