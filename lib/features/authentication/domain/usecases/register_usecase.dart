// lib/features/authentication/domain/usecases/register_usecase.dart
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<UserEntity> call({
    required String fullname,
    required String email,
    required String password,
    String? phone,
  }) {
    return repository.register(
      fullname: fullname,
      email: email,
      password: password,
      phone: phone,
    );
  }
}