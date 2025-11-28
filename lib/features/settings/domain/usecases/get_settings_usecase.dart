// lib/features/settings/domain/usecases/get_settings_usecase.dart
import '../entities/user_settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUsecase {
  final SettingsRepository repository;
  GetSettingsUsecase(this.repository);

  Future<UserSettingsEntity?> call(String userId) async {
    return await repository.getSettings(userId);
  }
}
