// lib/features/authentication/domain/usecases/logout_usecase.dart
import '../repositories/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;
  LogoutUsecase(this.repository);
  Future<void> call() => repository.logout();
}