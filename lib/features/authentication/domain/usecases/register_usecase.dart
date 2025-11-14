import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';
import 'package:student_timetable_app/features/authentication/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<UserEntity> call(String fullname, String studentCode, String email, String password) async {
    return await repository.register(fullname, studentCode, email, password);
  }
}