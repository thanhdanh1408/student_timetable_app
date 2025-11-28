// lib/features/authentication/domain/repositories/auth_repository.dart
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  
  Future<UserEntity> register({
    required String fullname,
    required String email,
    required String password,
    String? phone,
  });

  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}