import 'package:student_timetable_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String fullname, String studentCode, String email, String password);
}