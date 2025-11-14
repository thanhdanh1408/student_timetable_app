import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';
import 'package:student_timetable_app/features/authentication/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return await repository.login(email, password);
  }
}